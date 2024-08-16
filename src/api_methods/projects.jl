export create_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_project(;
	data,
	url=get_valid_url(),
	token=get_valid_token(),	
	format=nothing,
	returnFormat=nothing,
	odm=nothing,)

	if isa(data,Dict)
		@assert keys(data) ⊆ [:project_title, :purpose, :purpose_other, :project_notes, :is_longitudinal, :surveys_enabled, :record_autonumbering_enabled,]
		data="[$(JSON.json(data))]"
		format=:json
	end

	REDCap.request(;
		content="project",
		format=format,
		returnFormat=returnFormat,
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
		returnFormat=returnFormat,
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
		returnFormat=returnFormat,
	)
end

function import_project_info(;name=nothing,format=nothing,data,
	url=get_valid_url(),
	token=get_valid_token(),	)

	if isa(data,Dict)
		@assert keys(data) ⊆ [:project_title, :project_language, :purpose, :purpose_other, :project_notes, :custom_record_label, :secondary_unique_field, :is_longitudinal, :surveys_enabled, :scheduling_enabled, :record_autonumbering_enabled, :randomization_enabled, :project_irb_number, :project_grant_number, :project_pi_firstname, :project_pi_lastname, :display_today_now_button, :bypass_branching_erase_field_prompt]
		data="[$(JSON.json(data))]"
		format=:json
	end

	REDCap.request(;
		url=url,
		token=token,
		content="project_settings",
		format=format,
		data=data,
	)
end

