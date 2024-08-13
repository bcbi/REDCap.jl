export export_version

function export_version()
	REDCap.request(;
		content="version",
	)
end
