export export_metadata,	import_metadata

function export_metadata(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	fields::redcap_array=nothing,
	forms::redcap_array=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(
	       url=url,
	       token=token,
		content=:metadata,
		format=format,
		fields=fields,
		forms=forms,
		returnFormat=returnFormat,
	)
end

function import_metadata(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter,
	data::redcap_data_parameter=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(;
	       url=url,
	       token=token,
		content=:metadata,
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end

