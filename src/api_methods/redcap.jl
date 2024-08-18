export export_version

function export_version(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	)
	REDCap.request(;
		url=URI(url),
		token=assert_valid(:token,token),
		content=:version,
	)
end
