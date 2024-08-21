export create_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_project(;
	data::redcap_data_parameter=nothing,
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	odm::redcap_odm_parameter=nothing,)

	if isa(data,Dict)
		@assert Symbol.(keys(data)) ⊆ [:project_title, :purpose, :purpose_other, :project_notes, :is_longitudinal, :surveys_enabled, :record_autonumbering_enabled,]
		data="[$(JSON.json(data))]" #TODO: best way to avoid type change? 
		# maybe function to map (Dict,String) to (String,String)
		format=:json
	end

	REDCap.request(;
		       content=REDCap_content(:project),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		data=data,
		url=URI(url),
		token=REDCap_super_token(token),
		odm=odm,
	)
end

function export_project_info(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(;
		       content=REDCap_content(:project),
		url=URI(url),
		token=REDCap_token(token),
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_project_XML(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,

	returnMetadataOnly::redcap_bool=nothing,
	records::redcap_array=nothing,
	fields::redcap_array=nothing,
	events::redcap_array=nothing,
	exportSurveyFields::redcap_bool=nothing,
	exportDataAccessGroups::redcap_bool=nothing,
	filterLogic::redcap_filterLogic_parameter=nothing,
	exportFiles::redcap_bool=nothing,
	)
	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
		content=REDCap_content(:project_xml),
		returnMetadataOnly=returnMetadataOnly,
		records=records,
		fields=fields,
		events=events,
		exportSurveyFields=exportSurveyFields,
		exportDataAccessGroups=exportDataAccessGroups,
		filterLogic=filterLogic,
		exportFiles=exportFiles,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_project_info(;name=nothing,format=nothing,data,
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	)

	if isa(data,Dict)
		@assert Symbol.(keys(data)) ⊆ [:project_title, :project_language, :purpose, :purpose_other, :project_notes, :custom_record_label, :secondary_unique_field, :is_longitudinal, :surveys_enabled, :scheduling_enabled, :record_autonumbering_enabled, :randomization_enabled, :project_irb_number, :project_grant_number, :project_pi_firstname, :project_pi_lastname, :display_today_now_button, :bypass_branching_erase_field_prompt]
		data="[$(JSON.json(data))]"
		format=:json
	end

	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
		content=REDCap_content(:project_settings),
		format=REDCap_format(format),
		data=data,
	)
end

