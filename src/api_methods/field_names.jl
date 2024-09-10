#TODO: retire this old function name?
##TODO: what about export_fields?
function export_list_of_export_field_names(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, field=nothing)
#TODO: field could be a single entry or an array
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:exportFieldNames, format=REDCap_format(format), field, returnFormat=REDCap_format(returnFormat),),
	)
end
export_field_names = export_list_of_export_field_names
