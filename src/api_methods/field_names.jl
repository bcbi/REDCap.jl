export export_list_of_export_field_names

function export_list_of_export_field_names(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
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
