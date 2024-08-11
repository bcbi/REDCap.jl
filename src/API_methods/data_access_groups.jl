export delete_DAGs,
	export_DAGs,
	export_user_DAG_assignment,
	import_DAGs,
	import_user_DAG_assignment,
	switch_DAG

delete_DAGs(dags; kwargs...) = redcap_api(; action="delete", content="dag", dags=dags, kwargs...)
export_DAGs(; kwargs...) = redcap_api(; content="dag", kwargs...)
export_user_DAG_assignment(; kwargs...) = redcap_api(; content="userDagMapping", kwargs...)
import_DAGs(; kwargs...) = redcap_api(; action="import", content="dag", kwargs...)
import_user_DAG_assignment(data; kwargs...) = redcap_api(; action="import", content="userDagMapping", data=data, kwargs...)
switch_DAG(dag; kwargs...) = redcap_api(; action="switch", content="dag", dag=dag, kwargs...)
