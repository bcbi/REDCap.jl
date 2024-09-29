"""
	function delete_DAGs(; url=get_url(), token=get_token(), dags)

Delete Data Access Groups (DAGs) from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `dags`: group names (can be scalar or vector)

"""
function delete_DAGs(; url=get_url(), token=get_token(), dags)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:delete, dags,),
	)
end

"""
	function export_DAGs(; url=get_url(), token=get_token(), format=nothing,)

Export Data Access Groups (DAGs) from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_DAGs(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, format=REDCap_format(format),),
	)
end

"""
	function export_user_DAG_assignment(; url=get_url(), token=get_token(), format=nothing,)

Export users' assignments to Data Access Groups (DAGs) for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_user_DAG_assignment(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:userDagMapping, format=REDCap_format(format),),
	)
end

"""
	function import_DAGs(; url=get_url(), token=get_token(), data, format=nothing, returnFormat=nothing,)

Export users' assignments to Data Access Groups (DAGs) for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_DAGs(; url=get_url(), token=get_token(), data=nothing, format=nothing, returnFormat=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="dags"),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:import, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function import_user_DAG_assignment(; url=get_url(), token=get_token(), data, format=nothing, returnFormat=nothing,)

Export users' assignments to Data Access Groups (DAGs) for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_user_DAG_assignment(; url=get_url(), token=get_token(), data, format=nothing, returnFormat=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		kwargs = (; token=REDCap_token(token), content=:userDagMapping, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end


"""
	function import_user_DAG_assignment(; url=get_url(), token=get_token(), data, format=nothing, returnFormat=nothing,)

Switch the REDCap API user's current Data Access Group (DAG)

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `dag`: unique group name for the intended DAG

"""
function switch_DAG(; data, url=get_url(), dag)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:dag, action=:switch, dag,),
	)
end


