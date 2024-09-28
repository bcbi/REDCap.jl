#TODO: retire this old function name?
##TODO: what about export_fields?
"""
	function export_list_of_export_field_names(; url=get_url(), token=get_token(), format=nothing, field=nothing)

Export Events from a longitudinal REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `field`: field variable names (can be scalar or vector). By default, all fields are returned.

"""
function export_list_of_export_field_names(; url=get_url(), token=get_token(), format=nothing, field=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:exportFieldNames, format=REDCap_format(format), field, ),
	)
end
export_field_names = export_list_of_export_field_names
