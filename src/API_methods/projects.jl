export create_new_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_new_project(;name=nothing,format="xml",data=nothing,returnFormat="xml",odm=nothing)
	request(;
		url=get_valid_url(), 
		token=get_valid_token(), #TODO: check for super token
		content="project",
		format=assert_valid_format(format),
		data=data,
		returnFormat=assert_valid_format(returnFormat),
		odm=odm,
	)
end

function export_project_info(;name=nothing,format="xml",returnFormat="xml")
	request(;
		url=get_valid_url(), 
		token=get_valid_token(),
		content="project",
		format=format,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function export_project_XML(;returnMetadataOnly=false,records=nothing,fields=nothing,events=nothing,returnFormat="xml",exportSurveyFields=false,exportDataAccessGroups=false,filterLogic=nothing,exportFiles=false)
	request(;
		url=get_valid_url(), 
		token=get_valid_token(),
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

function import_project_info(;name=nothing,format="xml",data=nothing,)
	request(;
		url=get_valid_url(), 
		token=get_valid_token(),
		content="project_settings",
		format=format,
		data=data,
	)
end

