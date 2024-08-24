export create_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_project(;
	data::redcap_data_parameter,
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	odm::redcap_odm_parameter=nothing,
	)
	#TODO: should format be inferred?
	create_project(data;token=token,url=url,format=format,returnFormat=returnFormat,odm=odm)
end	

function create_project(data::Dict;
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	odm::redcap_odm_parameter=nothing,)

	#TODO: what is backgroundProcess=true

	#TODO: maybe this isn't a priority - REDCap's error checking is fine here
	# On the other hand, it's great to have this list visible...
	# I guess put these in the documentation
	@assert Symbol.(keys(data)) ⊆ [:project_title, :purpose, :purpose_other, :project_notes, :is_longitudinal, :surveys_enabled, :record_autonumbering_enabled,]
	#TODO: check when data isn't a Dict?
	if [:project_title, :purpose] ⊈ Symbol.(keys(data)); throw(ArgumentError("The data field must include a project title and purpose")) end
	data= #TODO: best way to avoid type change? 
	# maybe function to map (Dict,String) to (String,String)

	#TODO: better to use xml, since this is the default format for returns?
	REDCap.request(;
		       content=REDCap_content(:project),
		format=:json,
		returnFormat=REDCap_format(returnFormat),
		data="[$(JSON.json(data))]",
		url=REDCap_url(url),
		token=REDCap_super_token(token),
		odm=odm,
	)
end

function create_project(data::String;
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	odm::redcap_odm_parameter=nothing,)

	REDCap.request(;
		       content=REDCap_content(:project),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		data=read(data, String),
		url=REDCap_url(url),
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
		url=REDCap_url(url),
		token=REDCap_token(token),
		returnFormat=REDCap_format(returnFormat),
	)
end

#TODO: should this write to a file?
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
		url=REDCap_url(url),
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

function import_project_info(;
		format=nothing,data,
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),
	)

	import_project_info(data; token=token, url=url, format=format)
end

function import_project_info(data::Dict;
		format=nothing,
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	)
	@assert Symbol.(keys(data)) ⊆ [:project_title, :project_language, :purpose, :purpose_other, :project_notes, :custom_record_label, :secondary_unique_field, :is_longitudinal, :surveys_enabled, :scheduling_enabled, :record_autonumbering_enabled, :randomization_enabled, :project_irb_number, :project_grant_number, :project_pi_firstname, :project_pi_lastname, :display_today_now_button, :bypass_branching_erase_field_prompt]

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:project_settings),
		format=REDCap_format(:json),
	data="[$(JSON.json(data))]"
	)
end

#TODO: only the CSV version works here?
function import_project_info(data::String;
		format=nothing,
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:project_settings),
		format=REDCap_format(format),
		data=read(data,String)
	)
end

