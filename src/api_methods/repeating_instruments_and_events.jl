"""
	function export_repeating_instruments_and_events(; url=get_url(), token=get_token(), format=nothing,)

Export a list of repeating instruments and events for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_repeating_instruments_and_events(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:repeatingFormsEvents, format=REDCap_format(format),),
	)
end

"""
	function import_repeating_instruments_and_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)

Import a list of repeating instruments and events to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_repeating_instruments_and_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; content=:repeatingFormsEvents, token=REDCap_token(token), format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

