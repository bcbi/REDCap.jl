export create_project,
	export_project_info,
	export_project_XML,
	import_project_info

function create_project(;
	url=get_valid_url(),
	token=get_valid_token(),	
	project_title,
	purpose,
	purpose_other=nothing,
	project_notes=nothing,
	is_longitudinal=false,
	surveys_enabled=nothing,
	record_autonumbering_enabled=nothing,
	format="xml",
	#returnFormat=nothing,
	odm=nothing)

	REDCap.request(;
		content="project",
		format=assert_valid_format(format),
		#returnFormat=assert_valid_format(returnFormat),
		data="[" * JSON.json(Dict("project_title"=>"$project_title","purpose"=>"$purpose"))  * "]" ,#, #purpose_other, project_notes, is_longitudinal, surveys_enabled, record_autonumbering_enabled),
		url=url,
		token=token,
		odm=odm,
	)
end

function export_project_info(;name=nothing,format="xml",returnFormat="xml")
	REDCap.request(;
		content="project",
		format=format,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function export_project_XML(;returnMetadataOnly=false,records=nothing,fields=nothing,events=nothing,returnFormat="xml",exportSurveyFields=false,exportDataAccessGroups=false,filterLogic=nothing,exportFiles=false)
	REDCap.request(;
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
	REDCap.request(;
		content="project_settings",
		format=format,
		data=data,
	)
end

