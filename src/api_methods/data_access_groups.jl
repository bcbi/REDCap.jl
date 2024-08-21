export delete_DAGs,
	export_DAGs,
	export_user_DAG_assignment,
	import_DAGs,
	import_user_DAG_assignment,
	switch_DAG

function delete_DAGs(;dags=nothing)
	REDCap.request(;
		content=REDCap_content(:dag),
		action=:delete,
		dags=dags,
	)
end

function export_DAGs(;format=:xml,returnFormat=nothing)
	REDCap.request(;
		       content=REDCap_content(:dag),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_user_DAG_assignment(;format=:xml)
	REDCap.request(;
		       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
	)
end

function import_DAGs(;format=:xml,data=nothing,returnFormat=nothing)
	REDCap.request(;
		       content=REDCap_content(:dag),
		action=:import,
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_DAG_assignment(;format=:xml,data=nothing,returnFormat=nothing)
	REDCap.request(;
		       content=REDCap_content(:userDagMapping),
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

function switch_DAG(;dag=nothing)
	REDCap.request(;
		       content=REDCap_content(:dag),
		action=:switch,
		dag=dag,
	)
end


