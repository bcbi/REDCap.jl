export export_metadata,	import_metadata

function export_metadata(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	fields::redcap_array=nothing,
	forms::redcap_array=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(format),
		fields=fields,
		forms=forms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_metadata(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	data::redcap_data_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

