"""
	function delete_events(; url=get_url(), token=get_token(), events=nothing,)

Delete Events from a longitudinal REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `events`: unique event names (can be scalar or vector)

"""
function delete_events(; url=get_url(), token=get_token(), events=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:event, action=:delete, events,),
	)
end

"""
	function export_events(; url=get_url(), token=get_token(), format=nothing, arms=nothing,)

Export Events from a longitudinal REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `arms`: study arms from which to pull events (all are inclued by default)

"""
function export_events(; url=get_url(), token=get_token(), format=nothing, arms=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), content=:event, arms,),
	)
end

"""
	function import_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data=nothing, override=nothing,)

Import new Events to a longitudinal REDCap project, or update the attributes of existing Events

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `override`: if true, all existing Events are erased; if false (default), existing Events can only be updated
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data=nothing, override=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="events"),
		kwargs = (; token=REDCap_token(token), format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), content=:event, action=:import, override,),
	)
end

