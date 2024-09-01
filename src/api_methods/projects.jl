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
		       content=:project,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		data=REDCap_data(data,REDCap_format(format)),#xml_tag="items")
		url=REDCap_url(url),
		token=REDCap_super_token(token),
		odm=odm,
	)
	#TODO: should format be inferred?
	#create_project(data;token=token,url=url,format=format,returnFormat=returnFormat,odm=odm)
end	
#=

function create_project(data::Dict;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	odm=nothing,)

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
		       content=:project,
		format=REDCap_format(:json),
		returnFormat=REDCap_format(returnFormat),
		data="[$(JSON.json(data))]",
		url=REDCap_url(url),
		token=REDCap_super_token(token),
		odm=odm,
	)
end

function create_project(data::String;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	odm=nothing,)

	REDCap.request(;
		       content=:project,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		data=read(data, String),
		url=REDCap_url(url),
		token=REDCap_super_token(token),
		odm=odm,
	)
end
=#

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
		       content=:project,
		url=REDCap_url(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		#returnFormat=REDCap_format(returnFormat),
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
		token=REDCap_token(token),
		content=:project_xml,
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
		token=REDCap_token(token),
		content=:project_settings,
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format), xml_tag="items") #TODO
	# without this xml tag, the XML is misformatted, but even with it, it isn't parse correctly... only csv works here....
		#project_title, project_language, purpose, purpose_other, project_notes, custom_record_label, secondary_unique_field, is_longitudinal, surveys_enabled, scheduling_enabled, record_autonumbering_enabled, randomization_enabled, project_irb_number, project_grant_number, project_pi_firstname, project_pi_lastname, display_today_now_button, bypass_branching_erase_field_prompt
	)
end

#=
function import_project_info(data::Dict;
		format=nothing,
	url=get_url(),
	token=get_token(),	)
	@assert Symbol.(keys(data)) ⊆ [:project_title, :project_language, :purpose, :purpose_other, :project_notes, :custom_record_label, :secondary_unique_field, :is_longitudinal, :surveys_enabled, :scheduling_enabled, :record_autonumbering_enabled, :randomization_enabled, :project_irb_number, :project_grant_number, :project_pi_firstname, :project_pi_lastname, :display_today_now_button, :bypass_branching_erase_field_prompt]

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:project_settings,
		format=REDCap_format(:json),
	data="[$(JSON.json(data))]"
	)
end

#TODO: only the CSV version works here?
function import_project_info(data::String;
		format=nothing,
	url=get_url(),
	token=get_token(),	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:project_settings,
		format=REDCap_format(format),
		data=read(data,String)
	)
end

=#
