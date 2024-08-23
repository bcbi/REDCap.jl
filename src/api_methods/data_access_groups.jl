export delete_DAGs,
	export_DAGs,
	export_user_DAG_assignment,
	import_DAGs,
	import_user_DAG_assignment,
	switch_DAG

function delete_DAGs(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	dags=nothing)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:dag),
		action=REDCap_action(:delete),
		dags=dags,
	)
end

function export_DAGs(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	#TODO: This is one of those ones that only take a format parameter
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_user_DAG_assignment(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
	)
end

function import_DAGs(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	data::redcap_data_parameter=nothing, #TODO: It would be great to support a Dict here
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		       action=REDCap_action(:import),
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_DAG_assignment(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	data::redcap_data_parameter=nothing,
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

function switch_DAG(;
	data::redcap_data_parameter=nothing,
	url::redcap_url_parameter=get_url(),
		dag=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		       action=REDCap_action(:switch),
		dag=dag,
	)
end


