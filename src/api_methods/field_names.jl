#TODO: retire this old function name?
##TODO: what about export_fields?
function export_list_of_export_field_names(; url=get_url(), token=get_token(), format=nothing, field=nothing)
#TODO: field could be a single entry or an array
##TODO: returnFormat has no effect, which I think is generally the case for export functions
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:exportFieldNames, format=REDCap_format(format), field, ),
	)
end
export_field_names = export_list_of_export_field_names
