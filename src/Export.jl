export_field_names(field) = redcap_api("export", "exportFieldNames", field)
export_instruments() = redcap_api("export", "instrument")
export_project_information() = redcap_api("export", "project")
export_users() = redcap_api("export", "user")
export_events() = redcap_api("export", "event")
export_repeating_forms_and_events() = redcap_api("export", "repeatingFormsEvents")


"""
	export_pdf(file_loc::String; record::String="", event::String="", instrument::String="", allRecords::Bool=false) 

Exports a PDF for a selected portion of the project.

#### Parameters:
* `record` - Record ID to populate PDF
* `event` - Event name to populate PDF
* `instrument` - Name of instrument to populate PDF
* `allRecords` - Flag to take all records or not - if passed, the other specifying fields will be ignored
* `file_loc` - Location to export to

#### Returns:
PDF file for: 
* 1) single data collection instrument (blank),
* 2) all instruments (blank), 
* 3) single instrument (with data from a single record),
* 4) all instruments (with data from a single record), 
* 5) all instruments (with data from ALL records)
"""
function export_pdf(file_loc::String; record::String="", event::String="", instrument::String="", allRecords::Bool=false)
	if allRecords==true 					#REDCap handles request differently based which fields passed
		output = redcap_api("export", "pdf", file_loc=file_loc, allRecords=allRecords)
	else
		output = redcap_api("export", "pdf", file_loc=file_loc, record=record, event=event, instrument=instrument)
	end
end


"""
	export_project(; returnMetadataOnly::Bool=false, records::Array=[], fields::Array=[], events::Array=[], format::String="xml", exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String="", exportFiles::Bool=false, file_loc::String="") 

#### Parameters:
* `returnMetadataOnly` - Flag to return metedata or not
* `records` - Array of record names to include
* `fields` - Array of field names to include
* `events` - Array of event names to include
* `exportSurveyFields` - Flag to return survey fields or not
* `exportDataAccessGroups` - Flag to return DAGroups or not
* `filterLogic` - Allows collection of records that fulfill a criteria eg. "[age] > 65"
* `exportFiles` - Flag to include files or not
* `file_loc` - Location to export to

#### Returns:
Entire project as XML.
"""
function export_project(; returnMetadataOnly::Bool=false, records::Array=[], fields::Array=[], events::Array=[], format::String="xml", exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String="", exportFiles::Bool=false, file_loc::String="")
	output = redcap_api("export", "project_xml", returnMetadataOnly=returnMetadataOnly, records=records, fields=fields, events=events, format=format, exportSurveyFields=exportSurveyFields, exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic, exportFiles=exportFiles, file_loc=file_loc)
	if length(file_loc)>0
		return "Success"
	else
		return xml_formatter(output, "export")
	end
end


"""
	export_records(; format::String="json", dtype::String="flat", records::Array=[], fields::Array=[], forms::Array=[], events::Array=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String="", file_loc::String="")

#### Parameters:
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `dtype` - Output mode: "flat" (output one record per row) or "eav" (one data point per row)
* `records` - Array of record names to include
* `fields` - Array of field names to include
* `forms` - Array of form names to include
* `events` - Array of event names to include
* `rawOrLabel` - "raw" or "label" - export raw coded values or labels for multiple choice fields
* `rawOrLabelHeaders` - Same as above, for headers
* `exportCheckboxLabel` - Checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/'blank'"
* `exportSurveyFields` - Flag to return survey fields or not
* `exportDataAccessGroups` - Flag to return DAGroups or not
* `filterLogic` - Allows collection of records that fulfill a criteria eg. "[age] > 65"
* `file_loc` - Location to export to

#### Returns:
An array of Dictionaries containing record information
"""
function export_records(; format::String="json", dtype::String="flat", records::Array=[], fields::Array=[], forms::Array=[], events::Array=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, exportSurveyFields::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String="", file_loc::String="")
	return redcap_api("export", "record", format=format, dtype=dtype, records=records, fields=fields, forms=forms, events=events, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, exportCheckboxLabel=exportCheckboxLabel, exportSurveyFields=exportSurveyFields, exportDataAccessGroups=exportDataAccessGroups, filterLogic=filterLogic, file_loc=file_loc)
end


export_survey_queue_link(record::String) = redcap_api("export", "surveyQueueLink", record=record)


"""
	export_survey_return_code(record::String, instrument::String, event::String; repeat_instance::Integer=1) 

#### Parameters:
* `record` - Record id for link
* `instrument` - Name of instrument to export code for
* `event` - event Name conatining instrument
* `repeat_instance` - Number of repeated instances (long project)

#### Returns:
Unique Return Code in plain text format.
"""
function export_survey_return_code(record::String, instrument::String, event::String; format::String="text", repeat_instance::Integer=1)
	return redcap_api("export", "surveyReturnCode", record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, format=format, )
end


export_instrument_event_mappings(arms::Array=[])= redcap_api("export", "formEventMapping", arms=arms)


"""
	export_survey_participant_list(instrument::String, event::String; format::String="json", file_loc::String="") 

#### Parameters:
* `instrument` - Name of instrument to export list of participants
* `event` - Event name conatining instrument
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `file_loc` - Location to export to

#### Returns:
Formatted dict of all participants for specific survey instrument.
"""
function export_survey_participant_list(instrument::String, event::String; format::String="json", file_loc::String="")
	return redcap_api("export", "participantList", event=event, instrument=instrument, format=format, file_loc=file_loc)
end


"""
	export_file(record::String, field::String, event::String; repeat_instance::Integer=1, file_loc::String="") 

#### Parameters:
* `record` - Record id containing file
* `field` - Field containing file
* `event` - Event containing file
* `repeat_instance` - Number of repeated instances (long. project)
* `file_loc` - Location to export to

#### Returns:
File attached to individual record.
"""
function export_file(record::String, field::String, event::String; repeat_instance::Integer=1, file_loc::String="")
	return redcap_api("export", "file", event=event, record=record, field=field, repeat_instance=repeat_instance, file_loc=file_loc)
end


"""
	export_report(report_id::Integer; format::String="json", rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, file_loc::String="") 

#### Parameters:
* `report_id` - Id of report to export
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `rawOrLabel` - "raw" or "label" - export raw coded values or labels for multiple choice fields
* `rawOrLabelHeaders` - Same as above, for headers
* `exportCheckboxLabel` - Checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/'blank'"
* `file_loc` - Location to export to

#### Returns:
Formatted dict of report.
"""
function export_report(report_id; format::String="json", rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, file_loc::String="")
	return redcap_api("export", "report", report_id=report_id, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, 
							exportCheckboxLabel=exportCheckboxLabel, format=format, file_loc=file_loc)
end


""" 
	export_survey_link(record::String, instrument::String, event::String; repeat_instance::Int=1) 

#### Parameters:
* `record` - Record id
* `instrument` - Name of instrument linking to
* `event` - Event name containing instrument
* `repeat_instance` - Number of repeated instances (long project)

#### Returns:
Unique survey link.
"""
function export_survey_link(record::String, instrument::String, event::String; format::String="text", repeat_instance::Int=1, )
	return redcap_api("export", "surveyLink", record=record, instrument=instrument, event=event, 
							format=format, repeat_instance=repeat_instance, )
end
