"""
    AbstractREDCapClient

Supertype of [`REDCapProject`](@ref) and [`REDCapSuperUser`](@ref). A client holds the API
URL, a token and a transport. Every API function takes a client as its first argument.
"""
abstract type AbstractREDCapClient end

const URL_PATTERN = r"^https://[^/\s]+(/\S*)?/api/$"
const INSECURE_URL_PATTERN = r"^http://[^/\s]+(/\S*)?/api/$"

function validate_url(url::AbstractString, allow_insecure::Bool)
    occursin(URL_PATTERN, url) && return URI(url)
    if occursin(INSECURE_URL_PATTERN, url)
        allow_insecure && return URI(url)
        throw(ArgumentError("REDCap URL uses plain http://; pass allow_insecure=true to allow this"))
    end
    throw(ArgumentError("invalid REDCap API URL $(repr(url)): it must look like \"https://example.org/redcap/api/\""))
end

function validate_token(token::AbstractString, len::Int, what::String)
    occursin(Regex("^[0-9A-F]{$len}\$"), token) && return String(token)
    throw(ArgumentError("invalid $what: expected $len uppercase hexadecimal characters"))
end

function env_default(var::String)
    value = get(ENV, var, nothing)
    value === nothing && throw(ArgumentError("environment variable $var is not set; set it or pass the value as a keyword argument"))
    return value
end

"""
    REDCapProject(; url=ENV["REDCAP_API_URL"], token=ENV["REDCAP_API_TOKEN"],
                    transport=HTTPTransport(), allow_insecure=false)

A client for one REDCap project, holding a 32-character project API token.

`url` and `token` fall back to the environment variables independently, and only when the
client is constructed, so `REDCapProject(token=ENV["STUDY_A"])` works. The URL must have the
form `https://…/api/`; plain `http://` is accepted only with `allow_insecure=true`.

`show` prints only the last four characters of the token.
"""
struct REDCapProject <: AbstractREDCapClient
    url::URI
    token::String
    transport::AbstractTransport
    function REDCapProject(url::AbstractString, token::AbstractString, transport::AbstractTransport; allow_insecure::Bool = false)
        return new(validate_url(url, allow_insecure), validate_token(token, 32, "REDCap project token"), transport)
    end
end

function REDCapProject(;
        url::AbstractString = env_default("REDCAP_API_URL"),
        token::AbstractString = env_default("REDCAP_API_TOKEN"),
        transport::AbstractTransport = HTTPTransport(),
        allow_insecure::Bool = false,
    )
    return REDCapProject(url, token, transport; allow_insecure)
end

"""
    REDCapSuperUser(; url=ENV["REDCAP_API_URL"], token=ENV["REDCAP_API_SUPER_TOKEN"],
                      transport=HTTPTransport(), allow_insecure=false)

A client holding a 64-character super API token, which can create projects
(see `create_project`). Otherwise behaves like [`REDCapProject`](@ref).
"""
struct REDCapSuperUser <: AbstractREDCapClient
    url::URI
    token::String
    transport::AbstractTransport
    function REDCapSuperUser(url::AbstractString, token::AbstractString, transport::AbstractTransport; allow_insecure::Bool = false)
        return new(validate_url(url, allow_insecure), validate_token(token, 64, "REDCap super token"), transport)
    end
end

function REDCapSuperUser(;
        url::AbstractString = env_default("REDCAP_API_URL"),
        token::AbstractString = env_default("REDCAP_API_SUPER_TOKEN"),
        transport::AbstractTransport = HTTPTransport(),
        allow_insecure::Bool = false,
    )
    return REDCapSuperUser(url, token, transport; allow_insecure)
end

function Base.show(io::IO, c::AbstractREDCapClient)
    return print(io, nameof(typeof(c)), "(", c.url, ", token=", token_suffix(c.token), ")")
end
