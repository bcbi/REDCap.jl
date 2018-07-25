include("Utils.jl")

"""
	export_field_names(config::Config; format::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `file_loc` - location to export to

##Returns:
Formatted dict of export/import-specific version of field names 
for all fields (or for one field, if desired) in project: 
'original_field_name', 'choice_value', and 'export_field_name'
"""
function export_field_names(config::Config; format::String="json", file_loc::String="")
	output = api_pusher("export", "exportFieldNames", config, format=format, file_loc=file_loc)
	return output
end


"""
	export_instruments(config::Config; format::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `file_loc` - location to export to

##Returns:
Formatted dict for data collection instruments of project.
"""
function export_instruments(config::Config; format::String="json", file_loc::String="")
	output = api_pusher("export", "instrument", config, format=format, file_loc=file_loc)
	return output
end


"""
	export_metadata(config::Config; format::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `file_loc` - location to export to

##Returns:
Formatted dict of the metadata for project.
"""
function export_metadata(config::Config; format::String="json", file_loc::String="")
	output = api_pusher("export", "metadata", config, format=format, file_loc=file_loc)
	return output
end


"""
	export_project_information(config::Config; format::String="json", returnFormat::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Formatted dict of the basic attributes of given REDCap project.
"""
function export_project_information(config::Config; format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "project", config, format=format, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


"""
	export_user(config::Config; format::String="json", returnFormat::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Array of formatted dicts of users for project.
"""
function export_users(config::Config; format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "user", config, format=format, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


"""
	export_version(config::Config; returnFormat::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
The version number (eg 1.0.0) as a string
"""
function export_version(config::Config; returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "version", config, format="json", returnFormat=returnFormat)
	return output
end


"""
	export_arms(config::Config; arms, format::String="json", returnFormat::String="json", file_loc::String="") 

#NOTE: This only works for longitudinal projects.

##Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to export
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Formatted dict of Arms for project.
"""
function export_arms(config::Config; arms::Array=[], format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "arm", config, format=format, returnFormat=returnFormat, arms=arms, file_loc=file_loc)
	return output
end


"""
	export_events(config::Config; arms=[], format::String="json", returnFormat::String="json", file_loc::String="") 

#NOTE: This only works for longitudinal projects.

##Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to export
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Formatted dict of events for project.
"""
function export_events(config::Config; arms::Array=[], format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "event", config, format=format, returnFormat=returnFormat, arms=arms, file_loc=file_loc)
	return output
end


"""
	export_pdf(config::Config; record::String="", event::String="", instrument::String="", allRecords::Bool=false) 

##Parameters:
* `config` - struct containing url and api-key
* `record` - record ID to populate PDF
* `event` - event name to populate PDF
* `instrument` - name of instrument to populate PDF
* `allRecord` - flag to take all records or not
* `file_loc` - location to export to

##Returns:
PDF file for: 
* 1) single data collection instrument (blank),
* 2) all instruments (blank), 
* 3) single instrument (with data from a single record),
* 4) all instruments (with data from a single record), 
* 5) all instruments (with data from ALL records)
"""
function export_pdf(config::Config, file_loc::String; record::String="", event::String="", instrument::String="", allRecords::Bool=false)
	if allRecords==true
		output = api_pusher("export", "pdf", config, allRecords=allRecords)
	else
		output = api_pusher("export", "pdf", config, record=record, event=event, instrument=instrument)
	end
	#save right to file? how to unpack a PDF...
	try
		write(file_loc, output)
	catch
		error("File could not be read:\n$file_loc")
	end
end


"""
	export_project(config::Config; returnMetadata::Bool, records, fields, events, 
					returnFormat::String="json", exportSurveyFields::Bool, exportDataAccessGroups::Bool, 
					filterLogic::String, exportFiles::Bool, file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `returnMetadata` - flag to return metedata or not
* `records` - array of record names to include
* `fields` - array of field names to include
* `events` - array of event names to include
* `returnFormat` - error message format
* `exportSurveyFields` - flag to return survey fields or not
* `exportDataAccessGroups` - flag to return DAGroups or not
* `filterLogic` - allows collection of records that fulfill a criteria eg. "[age] > 65"
* `exportFiles` - flag to include files or not
* `file_loc` - location to export to

##Returns:
Entire project as XML file.
"""
function export_project(config::Config; returnMetadata::Bool=false, records::Array=[], fields::Array=[], events::Array=[], 
						returnFormat::String="json", exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, 
						filterLogic::String="", exportFiles::Bool=false, file_loc::String="")
	output = api_pusher("export", "project_xml", config, returnMetadata=returnMetadata, records=records, fields=fields,
							events=events, returnFormat=returnFormat, exportSurveyFields=exportSurveyFields, 
							exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic, exportFiles=exportFiles)
	return output
end


"""
	export_records(config::Config; format::String="json", dtype::String="flat", 
					records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String, file_loc::String="")

##Parameters:
* `config` - struct containing url and api-key
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `dtype` - output mode: "flat" (output one record per row) or "eav" (one data point per row)
* `records` - array of record names to include
* `fields` - array of field names to include
* `forms` - array of form names to include
* `events` - array of event names to include
* `rawOrLabel` - "raw" or "label" - export raw coded values or labels for multiple choice fields
* `rawOrLabelHeaders` - same as above, for headers
* `exportCheckboxLabel` - checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/<blank>"
* `returnFormat` - error message format
* `exportSurveyField` - flag to return survey fields or not
* `exportDataAccessGroups` - flag to return DAGroups or not
* `filterLogic` - allows collection of records that fulfill a criteria eg. "[age] > 65"
* `file_loc` - location to export to

##Returns:
Array of formatted dicts of set of records for a project.
"""
function export_records(config::Config; format::String="json", dtype::String="flat", 
					records::Array=[], fields::Array=[], forms::Array=[], events::Array=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String="", file_loc::String="")
	output = api_pusher("export", "record", config, format=format, dtype=dtype, records=records, fields=fields, forms=forms,
							events=events, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, exportCheckboxLabel=exportCheckboxLabel,
							exportSurveyField=exportSurveyField, exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic,
							returnFormat=returnFormat, file_loc=file_loc)
	return output
end



"""
	export_survey_queue_link(config::Config, record::String; returnFormat::String="json") 

##Parameters:
* `config` - struct containing url and api-key
* `record` - record id for link
* `returnFormat` - error message format

##Returns:
Unique Survey Queue link.
"""
function export_survey_queue_link(config::Config, record::String; returnFormat::String="json")
	output = api_pusher("export", "surveyQueueLink", config, record=record, returnFormat=returnFormat)
	return output
end


"""
	export_survey_return_code(config::Config, record::String, instrument::String, event::String, 
								repeat_instance::Integer; returnFormat::String="json") 

##Parameters:
* `config` - struct containing url and api-key
* `record` - record id for link
* `instrument` = name of instrument to export code for
* `event` - event name conatining instrument
* `repeat_instance` - number of repeated instances (long project)
* `returnFormat` - error message format

##Returns:
Unique Return Code in plain text format.
"""
function export_survey_return_code(config::Config, record::String, instrument::String, event::String, 
									repeat_instance::Integer; returnFormat::String="json")
	output = api_pusher("export", "surveyReturnCode", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end


"""
	export_instrument_event_mappings(config::Config, arms=[]; format::String="json", returnFormat::String="json", 
										file_loc::String="") 

#NOTE: This only works for longitudinal projects.

##Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to export
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Formatted dict of instrument-event mappings for project.
"""
###BROKEN###
function export_instrument_event_mappings(config::Config, arms::Array=[]; format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "formEventMapping", config, arms=arms, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


"""
	export_survey_participant_list(config::Config, instrument::String, event::String; format::String="json", 
									returnFormat::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `instrument` = name of instrument to export list of participants
* `event` - event name conatining instrument
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
Formatted dict of all participants for specific survey instrument.
"""
function export_survey_participant_list(config::Config, instrument::String, event::String; format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "participantList", config, event=event, instrument=instrument, format=format, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


"""
	export_file(config::Config, record::String, field::String, event::String, repeat_instance::Integer; 
				format::String="json", returnFormat::String="json", file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `record` - record id containing file
* `field` - field containing file
* `event` - event containing file
* `repeat_instance` - number of repeated instances (long project)
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `file_loc` - location to export to

##Returns:
File attached to individual record.
"""
function export_file(config::Config, record::String, field::String, event::String, repeat_instance::Integer; 
					format::String="json", returnFormat::String="json", file_loc::String="")
	output = api_pusher("export", "file", config, event=event, record=record, field=field, repeat_instance=repeat_instance, format=format, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


"""
	export_reports(config::Config, report_id::Integer; format::String="json", returnFormat::String="json",  
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, 
						file_loc::String="") 

##Parameters:
* `config` - struct containing url and api-key
* `report_id` - id of report to export
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `returnFormat` - error message format
* `rawOrLabel` - "raw" or "label" - export raw coded values or labels for multiple choice fields
* `rawOrLabelHeaders` - same as above, for headers
* `exportCheckboxLabel` - checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/<blank>"
* `file_loc` - location to export to

##Returns:
Formatted dict of report.
"""
function export_reports(config::Config, report_id::String; format::String="json", returnFormat::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, 
						file_loc::String="")
	output = api_pusher("export", "report", config, report_id=report_id, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, 
							exportCheckboxLabel=exportCheckboxLabel, format=format, returnFormat=returnFormat, file_loc=file_loc)
	return output
end


""" 
	export_survey_link(config::Config, record::Int, instrument::String, event::String, repeat_instance::Int; 
						returnFormat::String="json") 

##Parameters:
* `config` - struct containing url and api-key
* `record` - record id
* `instrument` = name of instrument linking to
* `event` - event name conatining instrument
* `repeat_instance` - number of repeated instances (long project)
* `returnFormat` - error message format

##Returns:
Unique survey link.
"""
function export_survey_link(config::Config, record::Int, instrument::String, event::String, repeat_instance::Int; returnFormat::String="json")
	output = api_pusher("export", "surveyLink", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end