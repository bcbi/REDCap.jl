struct REDCap_content 
	id::Symbol
	REDCap_content(id) = id ∈ [:arm,:dag,:userDagMapping,:event,:exportFieldNames,:fileRepository,:file,:formEventMapping,:instrument,:pdf,:log,:metadata,:project,:project_settings,:project_xml,:record,:generateNextRecordName,:record,:version,:repeatingFormsEvents,:report,:surveyLink,:participantList,:surveyQueueLink,:userRole,:userRoleMapping,:user,] ? new(id) : throw(ArgumentError("Invalid content parameter"))
end
Base.display(x::REDCap_content) = Base.display(x.id)
Base.string(x::REDCap_content) = Base.string(x.id)
Base.convert(String,x::REDCap_content) = string(x)

const REDCap_url = URIs.URI
const redcap_url_parameter = Union{REDCap_url,String}
const redcap_token_parameter = String
const redcap_super_token_parameter = String
const redcap_action_parameter = Union{Symbol, Nothing}
const redcap_data_parameter = Any
#const redcap_data_parameter = Union{IOStream, Dict, String, Nothing} #TODO: this can be nothing in REDCap.request(), but must be mandatory wherever it is a method parameter. Otherwise, it changes the method behavior, which would contradict the guarantee of the function name
const redcap_filterLogic_parameter = Union{String, Nothing}
const redcap_odm_parameter = Union{String, Nothing}

const redcap_array = Union{Array, Nothing}
const redcap_bool = Union{Bool, Nothing}
const redcap_format_parameter = Union{String, Symbol, Nothing}
const redcap_returnFormat_parameter = redcap_format_parameter
#const redcap_formatter = Union{Symbol, Nothing}
const redcap_symbol = Union{Symbol, Nothing}
const redcap_timestamp = Union{DateTime, Nothing} #TODO: YYYY-MM-DD HH:MM

redcap_generic_parameter = Union{
	redcap_action_parameter,
	redcap_data_parameter,
	redcap_filterLogic_parameter,
	redcap_odm_parameter,
	redcap_array,
	redcap_bool,
	redcap_format_parameter,
	#redcap_formatter,
	redcap_symbol,
	redcap_timestamp,
	}

struct REDCap_format
	id::redcap_format_parameter
	REDCap_format(id::Symbol) = id ∈ [:csv,:json,:xml] ? new(id) : throw(ArgumentError("Invalid format parameter"))
	REDCap_format(id::String) = id ∈ ["csv","json","xml"] ? new(Symbol(id)) : throw(ArgumentError("Invalid format parameter"))
	REDCap_format(id::Nothing) = nothing
end
Base.display(x::REDCap_format) = Base.display(x.id)
Base.string(x::REDCap_format) = Base.string(x.id)
Base.convert(String,x::REDCap_format) = string(x)

struct REDCap_token
	id::String
	REDCap_token(id) = occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", id) ? new(id) : throw(ArgumentError("Invalid REDCap token"))
end
Base.display(x::REDCap_token) = display(x.id)
Base.string(x::REDCap_token) = string(x.id)
Base.convert(String,x::REDCap_token) = string(x)

struct REDCap_super_token
	id::String
	REDCap_super_token(id) = occursin(r"^[0-9A-F]{64}$", id) ? new(id) : throw(ArgumentError("Invalid REDCap super token"))
end
Base.display(x::REDCap_super_token) = display(x.id)
Base.string(x::REDCap_super_token) = string(x.id)
Base.convert(String,x::REDCap_super_token) = string(x)

#const redcap_token_parameter = Union{REDCap_token, REDCap_super_token}

#const redcap_either_token = Union{redcap_token_parameter, redcap_super_token_parameter}

#macro redcap_token_str(t); REDCap_token(t) ; end #TODO: Is this macro helpful in any way?

#TODO: add type assertions for all the kwargs somewhere?
# Or assert they're in any type

