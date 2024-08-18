export export_metadata,	import_metadata

function export_metadata(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	format::redcap_formatter=nothing,
	fields::redcap_array=nothing,
	forms::redcap_array=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(
	url=URI(url),
	token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		fields=fields,
		forms=forms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_metadata(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	format::redcap_formatter,
	data::redcap_data_parameter=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(;
	url=URI(url),
	token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

