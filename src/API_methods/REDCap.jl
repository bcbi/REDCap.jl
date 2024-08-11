export export_version

export_version(format="xml") = redcap_api(;
	REDCap.@content("version"),
	REDCap.@format(format)
