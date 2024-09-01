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
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		fields=fields,
		forms=forms,
		returnFormat=REDCap_format(returnFormat),
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
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format)),
		returnFormat=REDCap_format(returnFormat),
	)
end

#=
function import_metadata(data::Dict;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(:json),
		data="[$(JSON.json(data))]",
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_metadata(data::String;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:metadata,
		format=REDCap_format(format),
		data=read(data, String),
		returnFormat=REDCap_format(returnFormat),
	)
end

=#
