export export_list_of_export_field_names

function export_list_of_export_field_names(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	field=nothing
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:exportFieldNames),
		format=REDCap_format(format),
		field=field, #TODO: This could be a single entry or an array
		returnFormat=REDCap_format(returnFormat),
	)
end
