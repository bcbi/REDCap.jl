function delete_DAGs(; url=get_url(), token=get_token(), dags=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:delete, dags,),
	)
end

#TODO: only accepts format, not returnFormat
function export_DAGs(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, format=REDCap_format(format),),
	)
end

function export_user_DAG_assignment(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:userDagMapping, format=REDCap_format(format),),
	)
end

#TODO: data require here?
function import_DAGs(; url=get_url(), token=get_token(), data=nothing, format=nothing, returnFormat=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="dags"),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:import, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

#TODO: data require here?
function import_user_DAG_assignment(; url=get_url(), token=get_token(), data=nothing, format=nothing, returnFormat=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		kwargs = (; token=REDCap_token(token), content=:userDagMapping, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

function switch_DAG(; data, url=get_url(), dag=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:switch, dag,),
	)
end


