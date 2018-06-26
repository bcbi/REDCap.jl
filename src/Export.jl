include("Utils.jl")

"""
	export_field_names(config::Config; format::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data

Returns:
formatted dict of export/import-specific version of field names 
for all fields (or for one field, if desired) in project: 
'original_field_name', 'choice_value', and 'export_field_name'
"""

function export_field_names(config::Config; format::String="json")
	output = api_pusher("export", "exportFieldNames", config, format=format)
	return output
end


"""
	export_instruments(config::Config; format::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data

Returns:
formatted dict for data collection instruments of project.
"""

function export_instruments(config::Config; format::String="json")
	output = api_pusher("export", "instrument", config, format=format)
	return output
end


"""
	export_metadata(config::Config; format::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data

Returns:
formatted dict of the metadata for project.
"""

function export_metadata(config::Config; format::String="json")
	output = api_pusher("export", "metadata", config, format=format)
	return output
end


"""
	export_project_information(config::Config; format::String="json", returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of the basic attributes of given REDCap project.
"""

function export_project_information(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "project", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_user(config::Config; format::String="json", returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of users for project.
"""

function export_user(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "user", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_version(config::Config; format::String="json", returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
The version number (eg 1.0.0)
"""

function export_version(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "version", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_arms(config::Config; arms, format::String="json", returnFormat::String="json") 

NOTE: This only works for longitudinal projects.

Parameters:
config::Config - struct containing url and api-key
arms - array of arm names to export
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of Arms for project.
"""

function export_arms(config::Config; arms=[], format::String="json", returnFormat::String="json")
	output = api_pusher("export", "arm", config, format=format, returnFormat=returnFormat, arms=arms)
	return output
end


"""
	export_events(config::Config; arms=[], format::String="json", returnFormat::String="json") 

NOTE: This only works for longitudinal projects.

Parameters:
config::Config - struct containing url and api-key
arms - array of arm names to export
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of events for project.
"""

function export_events(config::Config; arms=[], format::String="json", returnFormat::String="json")
	output = api_pusher("export", "event", config, format=format, returnFormat=returnFormat, arms=arms)
	return output
end


"""
	export_pdf(config::Config; record::Int=1, event::String="", instrument::String="", allRecords::Bool=false) 

Parameters:
config::Config - struct containing url and api-key
record::Int - record ID to populate PDF
event::String - event name to populate PDF
instrument::String = name of instrument to populate PDF
allRecord::Bool - flag to take all records or not

Returns:
PDF file for: 
1) single data collection instrument (blank), 			2) all instruments (blank), 
3) single instrument (with data from a single record), 	4) all instruments (with data from a single record), 
5) all instruments (with data from ALL records)
"""

function export_pdf(config::Config; record::Int=1, event::String="", instrument::String="", allRecords::Bool=false)
	allRecords = true
	if allRecords==true
		output = api_pusher("export", "pdf", config, allRecords=allRecords)
	else
		output = api_pusher("export", "pdf", config, record=record, event=event, instrument=instrument)
	end
	#save right to file? how to unpack a PDF...
	return output
end


"""
	export_project(config::Config; returnMetadata::Bool, records, fields, events, 
					returnFormat::String="json", exportSurveyFields::Bool, exportDataAccessGroups::Bool, 
					filterLogic::String, exportFiles::Bool) 

Parameters:
config::Config - struct containing url and api-key
returnMetadata::Bool - flag to return metedata or not
records - array of record names to include
fields - array of field names to include
events - array of event names to include
returnFormat::String - error message format
exportSurveyFields::Bool - flag to return survey fields or not
exportDataAccessGroups::Bool - flag to return DAGroups or not
filterLogic::String - allows collection of records that fulfill a criteria eg. "[age] > 65"
exportFiles::Bool - flag to include files or not

Returns:
entire project as XML file.
"""

function export_project(config::Config; returnMetadata::Bool=false, records=[], fields=[], events=[], 
						returnFormat::String="json", exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, 
						filterLogic::String="", exportFiles::Bool=false)
	output = api_pusher("export", "project_xml", config, returnMetadata=returnMetadata, records=records, fields=fields,
							events=events, returnFormat=returnFormat, exportSurveyFields=exportSurveyFields, 
							exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic, exportFiles=exportFiles)
	return output
end


"""
	export_records(config::Config; format::String="json", dtype::String="flat", 
					records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String)

Parameters:
config::Config - struct containing url and api-key
format::String - "json", "xml", "csv", or "odm". decides format of returned data
dtype::String - output mode: "flat" (output one record per row) or "eav" (one data point per row)
records - array of record names to include
fields - array of field names to include
forms - array of form names to include
events - array of event names to include
rawOrLabel::String - "raw" or "label" - export raw coded values or labels for multiple choice fields
rawOrLabelHeaders::String - same as above, for headers
exportCheckboxLabel::Bool - checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/<blank>"
returnFormat::String - error message format
exportSurveyField::Bool - flag to return survey fields or not
exportDataAccessGroups::Bool - flag to return DAGroups or not
filterLogic::String - allows collection of records that fulfill a criteria eg. "[age] > 65"

Returns:
formatted dict of set of records for a project.
"""

function export_records(config::Config; format::String="json", dtype::String="flat", 
					records=[], fields=[], forms=[], events=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String="")
	output = api_pusher("export", "record", config, format=format, dtype=dtype, records=records, fields=fields, forms=forms,
							events=events, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, exportCheckboxLabel=exportCheckboxLabel,
							exportSurveyField=exportSurveyField, exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic,
							returnFormat=returnFormat)
	return output
end



"""
	export_survey_queue_link(config::Config, record; returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
record - record id for link
returnFormat::String - error message format

Returns:
unique Survey Queue link.
"""

function export_survey_queue_link(config::Config, record; returnFormat::String="json")
	output = api_pusher("export", "surveyQueueLink", config, record=record, returnFormat=returnFormat)
	return output
end


"""
	export_survey_return_code(config::Config, record; returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
record - record id for link
returnFormat::String - error message format

Returns:
unique Return Code in plain text format.
"""

function export_survey_return_code(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json")
	output = api_pusher("export", "surveyReturnCode", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end


"""
	export_instrument_event_mappings(config::Config, arms=[]; format::String="json", returnFormat::String="json") 

NOTE: This only works for longitudinal projects.

Parameters:
config::Config - struct containing url and api-key
arms - array of arm names to export
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of instrument-event mappings for project.
"""

function export_instrument_event_mappings(config::Config, arms=[]; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "surveyReturnCode", config, record=record, returnFormat=returnFormat)
	return output
end


"""
	export_survey_participant_list(config::Config, instrument, event; format::String="json", returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
instrument::String = name of instrument to export list of participants
event::String - event name conatining instrument
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
formatted dict of all participants for specific survey instrument.
"""

function export_survey_participant_list(config::Config, instrument, event; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "participantList", config, event=event, instrument=instrument, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
				format::String="json", returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
record::Int - record id containing file
field::String - field containing file
event::String - event containing file
repeat_instance::Int - number of repeated instances (long project)
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format

Returns:
document attached to individual record.
"""


function export_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					format::String="json", returnFormat::String="json")
	output = api_pusher("export", "file", config, event=event, record=record, field=field, repeat_instance=repeat_instance, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_reports(config::Config, report_id::Int; format::String="json", returnFormat::String="json",  
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false) 

Parameters:
config::Config - struct containing url and api-key
report_id::Int - id of report to export
format::String - "json", "xml", "csv", or "odm". decides format of returned data
returnFormat::String - error message format
rawOrLabel::String - "raw" or "label" - export raw coded values or labels for multiple choice fields
rawOrLabelHeaders::String - same as above, for headers
exportCheckboxLabel::Bool - checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/<blank>"

Returns:
formatted dict of report.
"""

function export_reports(config::Config, report_id::Int; format::String="json", returnFormat::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false)
	output = api_pusher("export", "report", config, report_id=report_id, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, 
							exportCheckboxLabel=exportCheckboxLabel, format=format, returnFormat=returnFormat)
	return output
end


""" 
	export_survey_link(config::Config, record::Int, instrument::String, event::String, repeat_instance::Int; returnFormat::String="json") 

Parameters:
config::Config - struct containing url and api-key
record::Int - record id
instrument::String = name of instrument linking to
event::String - event name conatining instrument
repeat_instance::Int - number of repeated instances (long project)
returnFormat::String - error message format

Returns:
unique survey link.
"""

function export_survey_link(config::Config, record::Int, instrument::String, event::String, repeat_instance::Int; returnFormat::String="json")
	output = api_pusher("export", "surveyLink", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end