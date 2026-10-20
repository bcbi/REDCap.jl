#
# Response handling: REDCapResponse -> the method's declared Julia type, or REDCapError.
#

is_success(resp::REDCapResponse) = 200 <= resp.status < 300

"""
    error_message(body) -> String

REDCap's error message: the `error` field of a JSON body when present, otherwise the
body text.
"""
function error_message(body::AbstractString)
    text = strip(body)
    parsed = try_parse_json(text)
    if parsed isa AbstractDict && haskey(parsed, "error")
        return string(parsed["error"])
    end
    return isempty(text) ? "(empty response body)" : String(text)
end

function try_parse_json(text::AbstractString)
    return try
        JSON.parse(text)
    catch
        nothing
    end
end

function response_error(spec::MethodSpec, client::AbstractREDCapClient, status::Integer, message::AbstractString)
    return REDCapError(Int(status), redact_token(message, client.token), spec.name)
end

"""
    check_status(spec, client, resp)

Throw a `REDCapError` for a non-2xx response.
"""
function check_status(spec::MethodSpec, client::AbstractREDCapClient, resp::REDCapResponse)
    is_success(resp) && return nothing
    throw(response_error(spec, client, resp.status, error_message(String(copy(resp.body)))))
end

"""
    handle_response(spec, client, resp)

Convert a response into the return type declared by `spec.returns`.
"""
function handle_response(spec::MethodSpec, client::AbstractREDCapClient, resp::REDCapResponse)
    check_status(spec, client, resp)
    return convert_response(Val(spec.returns), spec, client, resp)
end

unexpected(spec, client, resp, what) = throw(
    response_error(spec, client, resp.status, "unexpected response (expected $what): " * first(String(copy(resp.body)), 500)),
)

function parse_json_body(spec, client, resp, what)
    parsed = try_parse_json(String(copy(resp.body)))
    parsed === nothing && unexpected(spec, client, resp, what)
    parsed isa AbstractDict && haskey(parsed, "error") &&
        throw(response_error(spec, client, resp.status, string(parsed["error"])))
    return parsed
end

function convert_response(::Val{:table}, spec, client, resp)
    parsed = parse_json_body(spec, client, resp, "a JSON array")
    parsed isa AbstractVector && all(x -> x isa AbstractDict, parsed) ||
        unexpected(spec, client, resp, "a JSON array of objects")
    return table_from_rows(parsed)
end

function convert_response(::Val{:dict}, spec, client, resp)
    parsed = parse_json_body(spec, client, resp, "a JSON object")
    parsed isa AbstractDict || unexpected(spec, client, resp, "a JSON object")
    return plain_json(parsed)::Dict{String, Any}
end

function convert_response(::Val{:ids}, spec, client, resp)
    parsed = parse_json_body(spec, client, resp, "a JSON array of record IDs")
    parsed isa AbstractVector && all(x -> x isa Union{AbstractString, Integer}, parsed) ||
        unexpected(spec, client, resp, "a JSON array of record IDs")
    return String[string(x) for x in parsed]
end

# REDCap reports counts as a bare number, or as {"count": n}.
function convert_response(::Val{:int}, spec, client, resp)
    text = strip(String(copy(resp.body)))
    n = tryparse(Int, text)
    n === nothing || return n
    parsed = parse_json_body(spec, client, resp, "a count")
    if parsed isa AbstractDict && haskey(parsed, "count")
        c = parsed["count"]
        c isa Integer && return Int(c)
        c isa AbstractString && (m = tryparse(Int, c); m === nothing || return m)
    end
    return unexpected(spec, client, resp, "a count")
end

convert_response(::Val{:string}, spec, client, resp) = String(strip(String(copy(resp.body))))

convert_response(::Val{:xml}, spec, client, resp) = String(copy(resp.body))

function convert_response(::Val{:version}, spec, client, resp)
    v = tryparse(VersionNumber, strip(String(copy(resp.body))))
    v === nothing && unexpected(spec, client, resp, "a version number")
    return v
end

# REDCap answers some calls with "1" and others with an empty body or `{}`.
# TODO(verify): the exact success body of each `:nothing` method; any 2xx body is accepted.
convert_response(::Val{:nothing}, spec, client, resp) = nothing

function convert_response(::Val{:file}, spec, client, resp)
    content_type = header_value(resp, "Content-Type")
    mime = content_type === nothing ? "application/octet-stream" : String(strip(first(split(content_type, ';'))))
    name = header_param(content_type, "name")
    name === nothing && (name = header_param(header_value(resp, "Content-Disposition"), "filename"))
    return REDCapDownload(something(name, ""), mime, copy(resp.body))
end

# The new project's token is never echoed into an error message.
function convert_response(::Val{:client}, spec, client, resp)
    token = String(strip(String(copy(resp.body))))
    occursin(r"^[0-9A-F]{32}$", token) ||
        throw(response_error(spec, client, resp.status, "unexpected response (expected a project API token)"))
    return REDCapProject(string(client.url), token, client.transport; allow_insecure = client.url.scheme == "http")
end

# createFolder answers with `[{"folder_id": n}]`.
function convert_response(::Val{:folder}, spec, client, resp)
    parsed = parse_json_body(spec, client, resp, "a folder ID")
    if parsed isa AbstractVector && length(parsed) == 1 && only(parsed) isa AbstractDict && haskey(only(parsed), "folder_id")
        id = only(parsed)["folder_id"]
        id isa Integer && return Int(id)
        id isa AbstractString && (n = tryparse(Int, id); n === nothing || return n)
    end
    return unexpected(spec, client, resp, "a folder ID")
end

function header_value(resp::REDCapResponse, name::AbstractString)
    i = findfirst(h -> lowercase(first(h)) == lowercase(name), resp.headers)
    return i === nothing ? nothing : last(resp.headers[i])
end

"""
    header_param(value, key)

The value of `key=...` in a header such as `application/pdf; name="file.pdf"`.
"""
function header_param(value::Union{Nothing, AbstractString}, key::AbstractString)
    value === nothing && return nothing
    for part in split(value, ';')
        k, eq, v = partition(strip(part), '=')
        if eq && lowercase(k) == lowercase(key)
            return String(strip(strip(v), '"'))
        end
    end
    return nothing
end

function partition(s::AbstractString, c::Char)
    i = findfirst(c, s)
    i === nothing && return (String(s), false, "")
    return (String(strip(s[1:prevind(s, i)])), true, String(s[nextind(s, i):end]))
end
