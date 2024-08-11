export delete_DAGs,
	export_DAGs,
	export_user_DAG_assignment,
	import_DAGs,
	import_user_DAG_assignment,
	switch_DAG

function delete_DAGs(;dags=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="dag",
		action="delete",
		dags=dags,
	)
end

function export_DAGs(;format="xml",returnFormat=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="dag",
		format=get_valid_format(format),
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function export_user_DAG_assignment(;format="xml")
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="userDagMapping",
		format=get_valid_format(format),
	)
end

function import_DAGs(;format="xml",data=nothing,returnFormat=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="dag",
		action="import",
		format=get_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_user_DAG_assignment(;format="xml",data=nothing,returnFormat=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="userDagMapping",
		format=get_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function switch_DAG(;dag=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="dag",
		action="switch",
		dag=dag,
	)
end


