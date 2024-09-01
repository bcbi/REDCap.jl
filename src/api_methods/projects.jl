function create_project(;
	data,
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	odm=nothing,
	)

	#TODO: it might make sense to check these, but no check is done for formatted strings and file contents
	#@assert keys(data) ⊆ Set(:project_title, :purpose, :purpose_other, :project_notes, :is_longitudinal, :surveys_enabled, :record_autonumbering_enabled)

	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format)),#xml_tag="items")
		odm,
	kwargs = (;content=:project,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		token=REDCap_super_token(token),)
	)
	#TODO: should format be inferred?
	#create_project(data;token=token,url=url,format=format,returnFormat=returnFormat,odm)
end	

function export_project_info(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)

	if !isnothing(returnFormat)
		throw(ArgumentError("returnFormat is ignored, so use format instead (possibly this is an issue with REDCap's API"))
	end

	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		       content=:project,
		token=REDCap_token(token),
		format=REDCap_format(format),
		#returnFormat=REDCap_format(returnFormat),
		),
	)
end

#TODO: should this write to a file?
function export_project_XML(;
	url=get_url(),
	token=get_token(),	
	returnFormat=nothing,

	returnMetadataOnly=nothing,
	records=nothing,
	fields=nothing,
	events=nothing,
	exportSurveyFields=nothing,
	exportDataAccessGroups=nothing,
	filterLogic=nothing,
	exportFiles=nothing,
	)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:project_xml,
		returnMetadataOnly,
		records,
		fields,
		events,
		exportSurveyFields,
		exportDataAccessGroups,
		filterLogic,
		exportFiles,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

function import_project_info(;
		format=nothing,
		data,
	url=get_url(),
	token=get_token(),
	)

#TODO: not working, and there's no official API example... are we supposed to just pass this data in create_project?
	if REDCap_format(format) != REDCap_format(:csv)
		throw(ArgumentError("Only format=:csv is supported (possibly this is an issue with REDCap's API"))
	end

	#import_project_info(data; token=token, url=url, format=format)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format), xml_tag="items"), #TODO
	# without this xml tag, the XML is misformatted, but even with it, it isn't parse correctly... only csv works here....
		#project_title, project_language, purpose, purpose_other, project_notes, custom_record_label, secondary_unique_field, is_longitudinal, surveys_enabled, scheduling_enabled, record_autonumbering_enabled, randomization_enabled, project_irb_number, project_grant_number, project_pi_firstname, project_pi_lastname, display_today_now_button, bypass_branching_erase_field_prompt
		kwargs = (;
		token=REDCap_token(token),
		content=:project_settings,
		format=REDCap_format(format),
		),
	)
end

