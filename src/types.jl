struct REDCap_action 
	id::Symbol
	REDCap_action(id) = id ∈ [:createFolder,:delete,:export,:import,:list,:rename,:switch] ? new(id) : throw(ArgumentError("Invalid action parameter"))
end
Base.display(x::REDCap_action) = Base.display(x.id)
Base.string(x::REDCap_action) = Base.string(x.id)
Base.convert(String,x::REDCap_action) = string(x)

#TODO: help users fix formatting errors - I left out the final slash and had trouble debugging
# Maybe a function that checks for common mistakes
REDCap_url(x) = occursin(r"^https:\/\/.*\/api\/$", x) ? URIs.URI(x) : throw(ArgumentError("Invalid REDCap url"))

REDCap_datetime(x::String) = DateTime(x,"yyyy-m-dd H:M")
REDCap_datetime(x::Date) = DateTime(x)
REDCap_datetime(x::DateTime) = x
REDCap_datetime(x::Nothing) = nothing

struct REDCap_format
	id
	REDCap_format(id::Symbol) = REDCap_format(string(id))
	REDCap_format(id::String) = lowercase(id) ∈ Set(["csv","json","xml"]) ? new(Symbol(id)) : throw(ArgumentError("Invalid format parameter"))
	REDCap_format(id::Nothing) = nothing
end
Base.display(x::REDCap_format) = Base.display(x.id)
Base.string(x::REDCap_format) = Base.string(x.id)
Base.convert(String,x::REDCap_format) = string(x)

#TODO: multiple methods with Val here?
function REDCap_data(x::Dict, format::Union{Nothing,REDCap_format}; xml_tag=nothing)
	return if format == REDCap_format(:json)
		string('[',JSON.json(x),']')
	elseif format == REDCap_format(:csv)
		join(keys(x),',') * "\n" * join(values(x),',')
	else # default, assume XML
		#TODO: this looks ugly and isn't tested. test every data paramater that take an xml_tag
		attribute = isnothing(xml_tag) ? "" : string('<',xml_tag,'>')
		close_attribute = isnothing(xml_tag) ? "" : string("</",xml_tag,'>')

		"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" *
		attribute *
		"<item>" * 
		join([string('<',k,'>',v,"</",k,'>') for (k,v) in x]) *
		"</item>" *
		close_attribute
	end
end
#TODO: someway to throw an error if there's no comma to make the args a NamedTupe? I can't think of anything
#TODO: consider converting all collections to NamedTuples, then to string?
REDCap_data(x::NamedTuple, format::Union{REDCap_format,Nothing}; xml_tag=nothing) = REDCap_data(x |> pairs |> Dict, format, xml_tag=xml_tag)
#TODO: Remove this for 3.0.0
REDCap_data(x::String, format::Union{REDCap_format, Nothing}; xml_tag=nothing) = x
#TODO: handle large files?
REDCap_data(x::IOStream, format::Union{REDCap_format, Nothing}; xml_tag=nothing) = read(x,String)

struct REDCap_token
	id
	REDCap_token(id) = occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", id) ? new(id) : throw(ArgumentError("Invalid REDCap token"))
end
Base.display(x::REDCap_token) = display(x.id)
Base.string(x::REDCap_token) = string(x.id)
Base.convert(String,x::REDCap_token) = string(x)

struct REDCap_super_token
	id
	REDCap_super_token(id) = occursin(r"^[0-9A-F]{64}$", id) ? new(id) : throw(ArgumentError("Invalid REDCap super token"))
end
Base.display(x::REDCap_super_token) = display(x.id)
Base.string(x::REDCap_super_token) = string(x.id)
Base.convert(String,x::REDCap_super_token) = string(x)

