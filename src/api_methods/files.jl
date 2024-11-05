"""
	function delete_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)

Delete a file from a record in a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: record ID
- `field`: name of field that contains file
- `event`: unique event name (longitudinal projects)
- `repeat_instance`: instance number of repeating event or instrument (where applicable, default is 1)
"""
function delete_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:delete, record, field, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)

Export a file from a record in a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: record ID
- `field`: name of field that contains file
- `event`: unique event name (longitudinal projects)
- `repeat_instance`: instance number of repeating event or instrument (where applicable, default is 1)
"""
function export_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:export, record, field, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function import_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing, file=nothing,)

Export a file from a record in a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: record ID
- `field`: name of field that contains file
- `event`: unique event name (longitudinal projects)
- `repeat_instance`: instance number of repeating event or instrument (where applicable, default is 1)
- `file`: file contents to be uploaded
"""
function import_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing, file=nothing,)
	#TODO: should file be a required field?
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:import, record, field, event, repeat_instance, file, returnFormat=REDCap_format(returnFormat),),
	)
end
