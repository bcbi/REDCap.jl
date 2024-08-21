export export_list_of_export_field_names

function export_list_of_export_field_names(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	field=nothing
	)

	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
		content=:exportFieldNames,
		format=REDCap_format(format),
		field=field, #TODO: This could be a single entry or an array
		returnFormat=REDCap_format(returnFormat),
	)
end
