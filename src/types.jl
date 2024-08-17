struct REDCap_token
       id::String
       function REDCap_token(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap token")
       end
	is_valid(token) = occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", token)
       end
Base.print(x::REDCap_token) = print(x.id)
#macro redcap_token_str(t); REDCap_token(t) ; end #TODO: Is this macro even helpful in any way?

#TODO: add type assertions for all the kwargs somewhere?
# Or make sure they're on the list

struct REDCap_super_token
       id::String
       function REDCap_super_token(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap super-token")
       end
	is_valid(token) = occursin(r"^[0-9A-F]{64}$", token)
       end
Base.print(x::REDCap_super_token) = print(x.id) #TODO: just define once on a supertype?

struct REDCap_url
       id::String
       function REDCap_url(id)
       is_valid(id) ? new(id) : @error("Invalid REDCap token")
       end
	is_valid(url) = occursin(r"^https:\/\/.*\/api\/?$", url)
end
Base.print(x::REDCap_url) = print(x.id)

redcap_action_parameter = Union{Symbol, Nothing}
redcap_content_parameter = Union{Symbol, Nothing}

redcap_data_parameter = Union{Dict, String, Nothing} #TODO: this can be nothing in REDCap.request(), but must be mandatory wherever it is a method parameter. Otherwise, it changes the method behavior, which would contradict the guarantee of the function name
redcap_filterLogic_parameter = Union{String, Nothing}
redcap_odm_parameter = Union{String, Nothing}

#TODO: Deprecate these, since they must always have a value?
# I'm leaning towards keeping them, just in case.
redcap_token_parameter = Union{REDCap_token, Nothing}
redcap_super_token_parameter = Union{REDCap_super_token, Nothing}
redcap_url_parameter = Union{REDCap_url}

redcap_array = Union{Array, Nothing}
redcap_bool = Union{Bool, Nothing}
redcap_formatter = Union{Symbol, Nothing}
redcap_symbol = Union{Symbol, Nothing}
redcap_timestamp = Union{DateTime, Nothing} #TODO: YYYY-MM-DD HH:MM

redcap_generic_parameter = Any

