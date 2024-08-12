export export_metadata,	import_metadata

function export_metadata(;format="xml",fields=nothing,forms=nothing)
	request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="metadata",
		format=assert_valid_format(format),
		fields=fields,
		forms=forms,
		returnFormat=assert_valid_format(format),
	)
end

function import_metadata(;format="xml",data=nothing,returnFormat=nothing)
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="metadata",
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

