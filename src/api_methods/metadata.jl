export export_metadata,	import_metadata

#TODO: For most export functions, returnFormat seems to have no effect
function export_metadata(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	fields::redcap_array_input=nothing,
	forms::redcap_array_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(format),
		fields=fields,
		forms=forms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_metadata(;
	data::redcap_data_input,
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	)

	#import_metadata(data; url=url, token=token, returnFormat=returnFormat)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(format),
		data=REDCap_data(data),
		returnFormat=REDCap_format(returnFormat),
	)
end

#=
function import_metadata(data::Dict;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(:json),
		data="[$(JSON.json(data))]",
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_metadata(data::String;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:metadata),
		format=REDCap_format(format),
		data=read(data, String),
		returnFormat=REDCap_format(returnFormat),
	)
end

=#
