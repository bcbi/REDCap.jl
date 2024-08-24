export export_version

#TODO: should this return a VersionInfo?
function export_version(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:version),
	)
end
