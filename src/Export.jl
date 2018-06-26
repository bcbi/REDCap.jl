include("Utils.jl")

"""
	export_field_names(config::Config; format::String="json") 

returns dict of export/import-specific version of field names 
for all fields (or for one field, if desired) in project: 
	'original_field_name', 'choice_value', and 'export_field_name'
"""

function export_field_names(config::Config; format::String="json")
	output = api_pusher("export", "exportFieldNames", config, format=format)
	return output
end


"""
	export_instruments(config::Config; format::String="json") 

returns dict for data collection instruments for project.
"""

function export_instruments(config::Config; format::String="json")
	output = api_pusher("export", "instrument", config, format=format)
	return output
end


"""
	export_metadata(config::Config; format::String="json") 

returns a dict the metadata for project.
"""

function export_metadata(config::Config; format::String="json")
	output = api_pusher("export", "metadata", config, format=format)
	return output
end


"""
	export_project_information(config::Config; format::String="json", returnFormat::String="json") 

returns dict of the basic attributes of given REDCap project.
"""

function export_project_information(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "project", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_user(config::Config; format::String="json", returnFormat::String="json") 

returns dict of users for project.
"""

function export_user(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "user", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_version(config::Config; format::String="json", returnFormat::String="json") 

returns the current REDCap version number as plain text.
"""

function export_version(config::Config; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "version", config, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_arms(config::Config; format::String="json", arms, returnFormat::String="json") 

returns dict(?) of Arms for project.

NOTE: This only works for longitudinal projects.
"""

function export_arms(config::Config; format::String="json", arms=[], returnFormat::String="json")
	output = api_pusher("export", "arm", config, format=format, returnFormat=returnFormat, arms=arms)
	return output
end


"""
	export_events(config::Config; format::String="json", arms=[], returnFormat::String="json") 

returns dict of events for project.

NOTE: This only works for longitudinal projects.
"""

function export_events(config::Config; format::String="json", arms=[], returnFormat::String="json")
	output = api_pusher("export", "event", config, format=format, returnFormat=returnFormat, arms=arms)
	return output
end


"""
	export_pdf(config::Config; record::Int=1, event::Int=1, instrument::Int=1, allRecords::Bool=false) 

returns a PDF file for: 
1) single data collection instrument (blank), 			2) all instruments (blank), 
3) single instrument (with data from a single record), 	4) all instruments (with data from a single record), 
5) all instruments (with data from ALL records)
"""

function export_pdf(config::Config; record::Int=1, event::Int=1, instrument::Int=1, allRecords::Bool=false)
	allRecords = true
	if allRecords==true
		output = api_pusher("export", "pdf", config, allRecords=allRecords)
	else
		output = api_pusher("export", "pdf", config, record=record, event=event, instrument=instrument)
	end
	return output
end


"""
	export_project(config::Config; returnMetadata::Bool, records, fields, events, 
					returnFormat::String="json", exportSurveyFields::Bool, exportDataAccessGroups::Bool, 
					filterLogic::String, exportFile::Bool) 

returns entire project as XML file.
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

returns dict of set of records for a project.
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

returns unique Survey Queue link.
"""

function export_survey_queue_link(config::Config, record; returnFormat::String="json")
	output = api_pusher("export", "surveyQueueLink", config, record=record, returnFormat=returnFormat)
	return output
end


"""
	export_survey_return_code(config::Config, record; returnFormat::String="json") 

returns unique Return Code in plain text format.
"""

function export_survey_return_code(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json")
	output = api_pusher("export", "surveyReturnCode", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end


"""
	export_instrument_event_mappings(config::Config, arms=[]; format::String="json", returnFormat::String="json") 

returns dict of instrument-event mappings for project.

NOTE: This only works for longitudinal projects.
"""

function export_instrument_event_mappings(config::Config, arms=[]; format::String="json", returnFormat::String="json")
	output = api_pusher("export", "surveyReturnCode", config, record=record, returnFormat=returnFormat)
	return output
end


"""
	export_survey_participant_list(config::Config, instrument, event; returnFormat::String="json", format::String="json") 

returns dict of all participants for specific survey instrument.
"""

function export_survey_participant_list(config::Config, instrument, event; returnFormat::String="json", format::String="json")
	output = api_pusher("export", "participantList", config, event=event, instrument=instrument, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
				format::String="json", returnFormat::String="json") 

returns document attached to individual record.
"""


function export_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					format::String="json", returnFormat::String="json")
	output = api_pusher("export", "file", config, event=event, record=record, field=field, repeat_instance=repeat_instance, format=format, returnFormat=returnFormat)
	return output
end


"""
	export_reports(config::Config, report_id::Int; returnFormat::String="json", format::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false) 

returns data set of a report.
"""

function export_reports(config::Config, report_id::Int; returnFormat::String="json", format::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false)
	output = api_pusher("export", "report", config, report_id=report_id, rawOrLabel=rawOrLabel, rawOrLabelHeaders=rawOrLabelHeaders, 
							exportCheckboxLabel=exportCheckboxLabel, format=format, returnFormat=returnFormat)
	return output
end


""" 
	export_survey_link(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json") 

returns unique survey link.
"""

function export_survey_link(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json")
	output = api_pusher("export", "surveyLink", config, record=record, instrument=instrument, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end