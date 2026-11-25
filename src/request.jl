"""
    REDCapUpload(field, filename, content, mime)

A file sent as a multipart form part, as used by the file upload methods.
"""
struct REDCapUpload
    field::String
    filename::String
    content::Vector{UInt8}
    mime::String
end

"""
    REDCapRequest

A fully built, validated API request: the target URL, the form fields in the order they
are sent (including `token`), and an optional multipart file. Building one does no I/O.
`show` never prints the token.
"""
struct REDCapRequest
    method::Symbol
    url::URI
    fields::Vector{Pair{String, String}}
    file::Union{Nothing, REDCapUpload}
end

"""
    REDCapResponse(status, headers, body)

A transport's answer to a `REDCapRequest`.
"""
struct REDCapResponse
    status::Int
    headers::Vector{Pair{String, String}}
    body::Vector{UInt8}
end

REDCapResponse(status::Integer, body::AbstractString; headers = Pair{String, String}[]) =
    REDCapResponse(Int(status), headers, Vector{UInt8}(codeunits(body)))

"""
    field_value(req::REDCapRequest, name) -> Union{String,Nothing}

The value of the form field `name`, or `nothing` if the request doesn't contain it.
"""
function field_value(req::REDCapRequest, name::AbstractString)
    i = findfirst(p -> first(p) == name, req.fields)
    return i === nothing ? nothing : last(req.fields[i])
end

request_token(req::REDCapRequest) = something(field_value(req, "token"), "")

"""
    redacted_fields(req) -> Vector{Pair{String,String}}

The request's form fields with the token replaced, for logging and display.
"""
function redacted_fields(req::REDCapRequest)
    token = request_token(req)
    return [k => (k == "token" ? REDACTED : redact_token(v, token)) for (k, v) in req.fields]
end

function Base.show(io::IO, req::REDCapRequest)
    print(io, "REDCapRequest(", req.method, ", ", req.url, ", ")
    show(io, redacted_fields(req))
    req.file === nothing || print(io, ", file=", req.file.filename)
    return print(io, ")")
end

"""
    encode_body(req; boundary) -> (content_type, body::Vector{UInt8})

Encode the request as `application/x-www-form-urlencoded`, or as `multipart/form-data`
when it carries a file. Pure; `boundary` is a parameter so the output can be tested.
"""
function encode_body(req::REDCapRequest; boundary::AbstractString = multipart_boundary())
    if req.file === nothing
        body = join((escapeuri(k) * "=" * escapeuri(v) for (k, v) in req.fields), "&")
        return "application/x-www-form-urlencoded", Vector{UInt8}(codeunits(body))
    end
    buf = IOBuffer()
    for (k, v) in req.fields
        print(buf, "--", boundary, "\r\n")
        print(buf, "Content-Disposition: form-data; name=\"", k, "\"\r\n\r\n")
        print(buf, v, "\r\n")
    end
    f = req.file
    print(buf, "--", boundary, "\r\n")
    print(buf, "Content-Disposition: form-data; name=\"", f.field, "\"; filename=\"", escape_quotes(f.filename), "\"\r\n")
    print(buf, "Content-Type: ", f.mime, "\r\n\r\n")
    write(buf, f.content)
    print(buf, "\r\n--", boundary, "--\r\n")
    return "multipart/form-data; boundary=" * boundary, take!(buf)
end

multipart_boundary() = "REDCapjl" * join(rand(['0':'9'; 'a':'z'], 24))

escape_quotes(s::AbstractString) = replace(s, "\"" => "%22", "\r" => "", "\n" => "")

"""
    REDCapDownload

A file exported from REDCap: `filename` (from the response headers; may be empty),
`mime` type, and the file's bytes in `data`. Save it with `write(path, d.data)`.
"""
struct REDCapDownload
    filename::String
    mime::String
    data::Vector{UInt8}
end

function Base.show(io::IO, d::REDCapDownload)
    return print(io, "REDCapDownload(", repr(d.filename), ", ", d.mime, ", ", length(d.data), " bytes)")
end
