export export_version

function export_version()
	REDCap.request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="version",
	)
end
