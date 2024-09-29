"""
	function export_metadata(; url=get_url(), token=get_token(), format=nothing, fields=nothing, forms=nothing,)

Export metadata (Data Dictionary) from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `fields`: field names (can be scalar or vector). By default, all fields are pulled.
- `fields`: unique form names for data collection instruments (can be scalar or vector). By default, all fields are pulled.

"""
function export_metadata(; url=get_url(), token=get_token(), format=nothing, fields=nothing, forms=nothing,)

	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:metadata, format=REDCap_format(format), fields, forms,),
	)
end

#TODO: there is no guidance on what the metadata should look like... is itbasically like the odm parameter in create_project?
"""
function import_metadata(; data, url=get_url(), token=get_token(), format=nothing, returnFormat=nothing,)

Import metadata (Data Dictionary) to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_metadata(; data, url=get_url(), token=get_token(), format=nothing, returnFormat=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format)),
		kwargs = (; token=REDCap_token(token), content=:metadata, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

