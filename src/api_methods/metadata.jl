export export_metadata,	import_metadata

function export_metadata(;
	url=get_valid_url(),
	token=get_valid_token(),	
		format="xml",fields=nothing,forms=nothing,returnFormat=nothing)
	REDCap.request(
		       url=url,
		       token=token,
		content="metadata",
		format=format,
		fields=fields,
		forms=forms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_metadata(;
	url=get_valid_url(),
	token=get_valid_token(),	
		format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(;
		       url=url,
		       token=token,
		content="metadata",
		format=format,
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

