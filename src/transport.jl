"""
    AbstractTransport

Sends a `REDCapRequest` and returns a `REDCapResponse`. Implementations define
`REDCap.send_request(transport, request)`.
"""
abstract type AbstractTransport end

"""
    HTTPTransport(; kwargs...)

The real transport, which POSTs requests with HTTP.jl. TLS certificates are always
verified and HTTP.jl's automatic retries are disabled, since writes are not safe to repeat.
Extra keyword arguments (e.g. timeouts) are passed on to `HTTP.post`.
"""
struct HTTPTransport <: AbstractTransport
    options::NamedTuple
    HTTPTransport(; kwargs...) = new(NamedTuple(kwargs))
end

Base.show(io::IO, ::HTTPTransport) = print(io, "HTTPTransport()")

function send_request(t::HTTPTransport, req::REDCapRequest)
    content_type, body = encode_body(req)
    response = HTTP.post(
        req.url, ["Content-Type" => content_type, "Accept" => "*/*"], body;
        t.options...,
        retry = false,
        status_exception = false,
        require_ssl_verification = true,
    )
    headers = Pair{String, String}[String(k) => String(v) for (k, v) in response.headers]
    return REDCapResponse(Int(response.status), headers, Vector{UInt8}(response.body))
end

"""
    MockTransport(handler)
    MockTransport(responses::REDCapResponse...)

A transport for tests. It records every request it receives in `requests` and answers
with `handler(request)` (any callable returning a `REDCapResponse`), or with the given
responses in order. It never touches the network.
"""
struct MockTransport <: AbstractTransport
    handler::Any
    requests::Vector{REDCapRequest}
    MockTransport(handler) = new(handler, REDCapRequest[])
end

function MockTransport(responses::REDCapResponse...)
    queue = collect(responses)
    return MockTransport() do req
        isempty(queue) && error("MockTransport: no response left for $(req.method)")
        popfirst!(queue)
    end
end

Base.show(io::IO, t::MockTransport) = print(io, "MockTransport(", length(t.requests), " requests)")

function send_request(t::MockTransport, req::REDCapRequest)
    push!(t.requests, req)
    return t.handler(req)::REDCapResponse
end

"""
    RecordingTransport(inner, dir)

Wraps another transport (usually [`HTTPTransport`](@ref)) and saves every
request/response pair to a JSON fixture file in `dir`, for replay in tests.

Tokens are removed: the `token` field is dropped, the request's token is replaced
wherever it appears, and the project token returned by `create_project` is replaced
with zeros. Only the `Content-Type` and `Content-Disposition` headers are kept.
**Fixtures can still contain personal data** (record values, usernames, logging): review
them before committing.
"""
struct RecordingTransport <: AbstractTransport
    inner::AbstractTransport
    dir::String
    counter::Base.RefValue{Int}
    function RecordingTransport(inner::AbstractTransport, dir::AbstractString)
        mkpath(dir)
        return new(inner, String(dir), Ref(0))
    end
end

Base.show(io::IO, t::RecordingTransport) = print(io, "RecordingTransport(", t.inner, ", ", repr(t.dir), ")")

const KEPT_HEADERS = ("content-type", "content-disposition")
const PLACEHOLDER_PROJECT_TOKEN = "0"^32

function send_request(t::RecordingTransport, req::REDCapRequest)
    resp = send_request(t.inner, req)
    t.counter[] += 1
    path = joinpath(t.dir, string(req.method, "-", lpad(t.counter[], 3, '0'), ".json"))
    write(path, fixture_json(req, resp))
    return resp
end

"""
    fixture_json(req, resp) -> String

A fixture for a request/response pair, with the token removed.
"""
function fixture_json(req::REDCapRequest, resp::REDCapResponse)
    token = request_token(req)
    scrub(s) = redact_token(s, token)
    fields = [[k, scrub(v)] for (k, v) in req.fields if k != "token"]
    headers = [[k, scrub(v)] for (k, v) in resp.headers if lowercase(k) in KEPT_HEADERS]
    body = resp.body
    if req.method === :create_project && 200 <= resp.status < 300
        body = Vector{UInt8}(codeunits(PLACEHOLDER_PROJECT_TOKEN))
    end
    response = Dict{String, Any}("status" => resp.status, "headers" => headers)
    if isvalid(String, body)
        response["body"] = scrub(String(copy(body)))
    else
        response["body_hex"] = bytes2hex(body)
    end
    fixture = Dict{String, Any}(
        "method" => String(req.method),
        "source" => "recorded",
        "request" => Dict("fields" => fields, "file" => req.file === nothing ? nothing : req.file.filename),
        "response" => response,
    )
    return JSON.json(fixture; pretty = true)
end

"""
    load_fixture(path) -> (method::Symbol, request::REDCapRequest, response::REDCapResponse, fixture::Dict)

Read a fixture written by [`RecordingTransport`](@ref) (or by hand in the same format).
The request gets a placeholder URL and token.
"""
function load_fixture(path::AbstractString)
    fixture = JSON.parse(read(path, String); dicttype = Dict{String, Any})
    method = Symbol(fixture["method"])
    fields = Pair{String, String}["token" => "0"^32]
    for f in get(get(fixture, "request", Dict()), "fields", [])
        push!(fields, String(f[1]) => String(f[2]))
    end
    req = REDCapRequest(method, URI("https://example.test/api/"), fields, nothing)
    r = fixture["response"]
    headers = Pair{String, String}[String(h[1]) => String(h[2]) for h in get(r, "headers", [])]
    body = haskey(r, "body_hex") ? hex2bytes(r["body_hex"]) : Vector{UInt8}(codeunits(r["body"]))
    return method, req, REDCapResponse(Int(r["status"]), headers, body), fixture
end
