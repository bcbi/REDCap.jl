export export_metadata,	import_metadata

function export_metadata(;format="xml",fields=nothing,forms=nothing,returnFormat=nothing)
	REDCap.request(
		content="metadata",
		format=assert_valid_format(format),
		fields=fields,
		forms=forms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_metadata(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(;
		content="metadata",
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

