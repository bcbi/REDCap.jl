export export_metadata,	import_metadata

function export_metadata(;format="xml",fields=nothing,forms=nothing)
	redcap_api(
		url=get_valid_url(),
		token=get_valid_token(),
		content="metadata",
		format=get_valid_format(format),
		fields=fields,
		forms=forms,
		returnFormat=get_valid_format(format),
	)
end

function import_metadata(;format="xml",data=nothing)
	redcap_api(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="metadata",
		format=get_valid_format(format),
		data=data,
		returnFormat=get_valid_format(format),
	)
end

