export export_version

function export_version(;format="xml")
	redcap_api(;
		url=assert_valid_url(),
		token=assert_valid_token(),
		content="version",
		format=assert_valid_format(format),
	)
end
