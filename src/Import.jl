include("Utils.jl")

"""
	import_project_information(config::Config, infoData; format::String="json")

update basic attributes of given REDCap project.

Parameters:
config::Config - struct containing url and api-key
infoData - data to be imported
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
metaData - data to be imported
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
userData - data to be imported
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
armData - data to be imported
override::Int - 0 (false) 1 (true) - overwrites existing arms
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
userData - data to be imported
override::Int - 0 (false) 1 (true) - overwrites existing events
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
data::Any - data to be imported
format::String - "json", "xml", "csv", or "odm". declares format of imported data
dtype::String - "flat" (one record per row) or "eav" (one data point per row)
overwriteBehavior::String - flag to decide if blank values overwrite existing values or not
forceNumber::Bool - force auto-numbering and overwrite given id number
dateFormat::String - "YMD", "MDY", or "DMY"
returnContent::String - "count" (number of successfully uploaded records), "ids" (list of record numbers imported), "auto-ids" (pair of assigned id and given id)
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
	import_insrument_event_mappings(config::Config, instData; format::String="json", returnFormat::String="json")

import Instrument-Event Mappings into a project 

NOTE: This only works for longitudinal projects.

Parameters:
config::Config - struct containing url and api-key
instData - data to be imported
format::String - "json", "xml", "csv", or "odm". declares format of imported data
returnFormat::String - error message format

Returns:

"""

function import_insrument_event_mappings(config::Config, instData; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "formEventMapping", config, instData=instData, arms=arms, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")

upload a document to specific record/field.

Parameters:
config::Config - struct containing url and api-key
record::Int - destination record id
field::String - destination field
event::String - destination event
repeat_instance::Int - number of repeated instances (long project)
file - file to be imported
returnFormat::String - error message format

Returns:

"""

function import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")
	output = api_pusher("import", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							file=file, returnFormat=returnFormat)
	return output
end