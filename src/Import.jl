include("Utils.jl")

"""
	import_project_information(config::Config, infoData; format::String="json")

update basic attributes of given REDCap project.

Parameters:
config::Config - struct containing url and api-key
infoData -
format::String - "json", "xml", "csv", or "odm". declares format of imported data

Returns:

"""

function import_project_information(config::Config, infoData; format::String="json")
	output = api_pusher("import", "project_settings", config, infoData=infoData, format=format)
	return output
end


"""
	import_metadata(config::Config, metaData; format::String="json", returnFormat::String="json")

import metadata (i.e., Data Dictionary) into a project.

Parameters:
config::Config - struct containing url and api-key
metaData -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_metadata(config::Config, metaData; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "metadata", config, metaData=metaData, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_user(config::Config, userData; format::String="json", returnFormat::String="json")

update/import new users into a project.

Parameters:
config::Config - struct containing url and api-key
userData -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_user(config::Config, userData; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "user", config, userData=userData, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_arms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json")

update/import Arms into a project.

Parameters:
config::Config - struct containing url and api-key
armData -
override::Int -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_arms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json")
	output = api_pusher("import", "arm", config, armData=armData, override=override, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_events(config::Config, userData; override::Int=0, format::String="json", returnFormat::String="json")

update/import Events into a project.

Parameters:
config::Config - struct containing url and api-key
userData -
override::Int -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_events(config::Config, userData; override::Int=0, format::String="json", returnFormat::String="json")
	output = api_pusher("import", "event", config, userData=userData, override=override, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_records(config::Config, data::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false, dateFormat::String="YMD",
						returnContent::String="count", returnFormat::String="json")

import a set of records for a project.

Parameters:
config::Config - struct containing url and api-key
data::Any -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
dtype::String -
overwriteBehavior::String -
forceNumber::Bool -
dateFormat::String -
returnContent::String -
returnFormat::String - error message format

Returns:

"""

function import_records(config::Config, data::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false, dateFormat::String="YMD",
						returnContent::String="count", returnFormat::String="json")
	output = api_pusher("import", "record", config, data=data, format=format, dtype=dtype, 
							overwriteBehavior=overwriteBehavior, forceNumber=forceNumber, dateFormat=dateFormat,
							returnContent=returnContent, returnFormat=returnFormat)
	return output
end


"""
	import_insrument_event_mappings(config::Config, instData, arms; format::String="json", returnFormat::String="json")

import Instrument-Event Mappings into a project 

NOTE: This only works for longitudinal projects.

Parameters:
config::Config - struct containing url and api-key
instData -
arms -
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_insrument_event_mappings(config::Config, instData, arms; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "formEventMapping", config, instData=instData, arms=arms, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")

upload a document to specific record/field.

Parameters:
config::Config - struct containing url and api-key
record::Int -
field::String -
event::String -
repeat_instance::Int -
file -
returnFormat::String - error message format

Returns:

"""

function import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")
	output = api_pusher("import", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							file=file, returnFormat=returnFormat)
	return output
end