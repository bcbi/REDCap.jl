#TODO: For most export functions, returnFormat seems to have no effect
function export_metadata(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	fields=nothing,
	forms=nothing,
	returnFormat=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
	kwargs = (;
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		fields,
		forms,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

#TODO: there is no guidance on what the metadata should look like... is itbasically like the odm parameter in create_project?
function import_metadata(;
	data,
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)

	#import_metadata(data; url=url, token=token, returnFormat=returnFormat)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format)),
	kwargs = (;
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

