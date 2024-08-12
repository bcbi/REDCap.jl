export export_version

function export_version(;format="xml")
	REDCap.request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="version",
		format=assert_valid_format(format),
	)
end
