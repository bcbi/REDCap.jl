export create_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_project(;
	url=get_valid_url(),
	token=get_valid_token(),	
	data=nothing,
	format="xml",
	returnFormat=nothing,
	odm=nothing,
	project_title=nothing,
	purpose=nothing,
	purpose_other=nothing,
	project_notes=nothing,
	is_longitudinal=nothing,
	surveys_enabled=nothing,
	record_autonumbering_enabled=nothing,)

	if isnothing(returnFormat)
		returnFormat=isnothing(format) ? "xml" : format
	end

	if isnothing(data)
		data=assemble_data_parameter(;
			project_title=project_title,
			purpose=purpose,
			purpose_other=purpose_other,
			project_notes=project_notes,
			is_longitudinal= isnothing(is_longitudinal) ? false : is_longitudinal,
			surveys_enabled=surveys_enabled,
			record_autonumbering_enabled=record_autonumbering_enabled,
			)
		format = "json"
	end

	if isempty(data)
		#TODO: Without data or attributes, this would act as export project info
		# However, notice we always populate data with something, if needed.
		throw(ArgumentError)
	end

	REDCap.request(;
		content="project",
		format=assert_valid_format(format),
		returnFormat=assert_valid_format(returnFormat),
		data=data,
		url=url,
		token=token,
		odm=odm,
	)
end

function export_project_info(;
	url=get_valid_url(),
	token=get_valid_token(),	
		returnFormat="xml")

	REDCap.request(;
		content="project",
		url=url,
		token=token,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function export_project_XML(;
	url=get_valid_url(),
	token=get_valid_token(),	
		returnMetadataOnly=false,records=nothing,fields=nothing,events=nothing,returnFormat="xml",exportSurveyFields=false,exportDataAccessGroups=false,filterLogic=nothing,exportFiles=false)
	REDCap.request(;
		url=url,
		token=token,
		content="project_xml",
		returnMetadataOnly=returnMetadataOnly,
		records=records,
		fields=fields,
		events=events,
		exportSurveyFields=exportSurveyFields,
		exportDataAccessGroups=exportDataAccessGroups,
		filterLogic=filterLogic,
		exportFiles=exportFiles,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function import_project_info(;name=nothing,format="xml",data=nothing,
	url=get_valid_url(),
	token=get_valid_token(),	
		project_title=nothing, project_language=nothing, purpose=nothing, purpose_other=nothing, project_notes=nothing, custom_record_label=nothing, secondary_unique_field=nothing, is_longitudinal=nothing, surveys_enabled=nothing, scheduling_enabled=nothing, record_autonumbering_enabled=nothing, randomization_enabled=nothing, project_irb_number=nothing, project_grant_number=nothing, project_pi_firstname=nothing, project_pi_lastname=nothing, display_today_now_button=nothing, bypass_branching_erase_field_prompt=nothing)

	if isnothing(data)
		data=assemble_data_parameter(;
project_language=project_language,
purpose=purpose,
purpose_other=purpose_other,
project_notes=project_notes,
custom_record_label=custom_record_label,
secondary_unique_field=secondary_unique_field,
is_longitudinal=is_longitudinal,
surveys_enabled=surveys_enabled,
scheduling_enabled=scheduling_enabled,
record_autonumbering_enabled=record_autonumbering_enabled,
randomization_enabled=randomization_enabled,
project_irb_number=project_irb_number,
project_grant_number=project_grant_number,
project_pi_firstname=project_pi_firstname,
project_pi_lastname=project_pi_lastname,
display_today_now_button=display_today_now_button,
bypass_branching_erase_field_prompt=bypass_branching_erase_field_prompt,
			)
		format = "json"
	end

	REDCap.request(;
		url=url,
		token=token,
		content="project_settings",
		format=format,
		data=data,
	)
end

