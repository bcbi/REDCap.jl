const REDCap_token = String
const REDCap_super_token = String
function assert_valid(s::Symbol, x::String)
	return if s == :token
		occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", x) ? x : throw(ArgumentError("Invalid REDCap token"))
	elseif s==:super_token
		occursin(r"^[0-9A-F]{64}$", x) ? x : throw(ArgumentError("Invalid REDCap super token"))
	else
		throw(ArgumentError)
	end
end

#=
struct REDCap_token <: AbstractString
       id::String
       function REDCap_token(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap token")
       end
	is_valid(token) = occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", token)
end
REDCap_token(x::REDCap_token) = x
Base.print(x::REDCap_token) = print(x.id)
URIs.escapeuri(key::String, value::REDCap.REDCap_token) = URIs.escapeuri(key, value.id)
Base.show(io::IO, token::REDCap_token) = print(io, token.id)
String(x::REDCap_token) = x.id
#macro redcap_token_str(t); REDCap_token(t) ; end #TODO: Is this macro even helpful in any way?
=#

#TODO: add type assertions for all the kwargs somewhere?
# Or make sure they're on the list

#=
struct REDCap_super_token <: AbstractString
       id::String
       function REDCap_super_token(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap super-token")
       end
	is_valid(token) = occursin(r"^[0-9A-F]{64}$", token)
end
#REDCap_token(x::REDCap_super_token) = x #TODO: improve name - this could be confusing
Base.print(x::REDCap_super_token) = print(x.id) #TODO: just define once on a supertype?
URIs.escapeuri(key::String, value::REDCap.REDCap_super_token) = URIs.escapeuri(key, value.id)
String(x::REDCap_super_token) = x.id

=#
#=
struct REDCap_url
       id::String
       function REDCap_url(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap URL")
       end
	is_valid(url) = occursin(r"^https:\/\/.*\/api\/?$", url)
end
Base.print(x::REDCap_url) = print(x.id)
=#
REDCap_url = URIs.URI

#TODO: actually use this struct (WIP)
#TODO: add another for content
struct REDCap_format
       id::Symbol
       function REDCap_format(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap format")
       end
       is_valid(format) = format ∈ [:csv,:json,:xml]
       end
Base.print(x::REDCap_format) = print(x.id)
String(x::REDCap_format) = x.id

redcap_action_parameter = Union{Symbol, Nothing}
redcap_content_parameter = Union{Symbol, Nothing}
redcap_data_parameter = Union{Dict, String, Nothing} #TODO: this can be nothing in REDCap.request(), but must be mandatory wherever it is a method parameter. Otherwise, it changes the method behavior, which would contradict the guarantee of the function name
redcap_filterLogic_parameter = Union{String, Nothing}
redcap_odm_parameter = Union{String, Nothing}

redcap_super_token_parameter = Union{REDCap_super_token, String}
redcap_token_parameter = Union{REDCap_token, REDCap_super_token, String}
redcap_either_token = Union{redcap_token_parameter, redcap_super_token_parameter}
redcap_url_parameter = Union{REDCap_url,String}

redcap_array = Union{Array, Nothing}
redcap_bool = Union{Bool, Nothing}
redcap_formatter = Union{Symbol, Nothing}
redcap_symbol = Union{Symbol, Nothing}
redcap_timestamp = Union{DateTime, Nothing} #TODO: YYYY-MM-DD HH:MM

redcap_generic_parameter = Any

#URIs.URI(x::REDCap.REDCap_url) = URIs.URI(x.id)
#Base.iterate(x::REDCap.REDCap_token) = Base.iterate(x.id)
