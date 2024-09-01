export delete_DAGs,
	export_DAGs,
	export_user_DAG_assignment,
	import_DAGs,
	import_user_DAG_assignment,
	switch_DAG

function delete_DAGs(;
	url=get_url(),
	token=get_token(),	
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	#TODO: This is one of those ones that only take a format parameter
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		format=REDCap_format(format),
		#returnFormat=REDCap_format(returnFormat),
	)
end

function export_user_DAG_assignment(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
	)
end

function import_DAGs(;
	url=get_url(),
	token=get_token(),	
	data=nothing, # TODO: required?
	format=nothing,
	returnFormat=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		       action=REDCap_action(:import),
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="dags"),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_DAG_assignment(;
	url=get_url(),
	token=get_token(),	
	data=nothing, # TODO: required?
	format=nothing,
	returnFormat=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		returnFormat=REDCap_format(returnFormat),
	)
end

function switch_DAG(;
	data,
	url=get_url(),
		dag=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:dag),
		       action=REDCap_action(:switch),
		dag=dag,
	)
end


