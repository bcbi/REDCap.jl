export export_version

function export_version(;
		url::redcap_url_parameter=get_valid_url(),
		token::redcap_token_parameter=get_valid_token(),	
	)
	REDCap.request(;
		       url=url,
		       token=token,
		content=:version,
	)
end
