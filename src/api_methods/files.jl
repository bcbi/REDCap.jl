export delete_file, export_file, import_file

function delete_file(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	record=nothing,
	field=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
	       content=REDCap_content(:file),
	       action=REDCap_action(:delete),
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_file(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	record=nothing,
	field=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
	       content=REDCap_content(:file),
	       action=REDCap_action(:export),
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_file(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	record=nothing,
	field=nothing,
	event=nothing,
	repeat_instance=nothing,
	file=nothing,
	)

	REDCap.request(;
		url=URI(url),
		token=REDCap_token(token),
	       content=REDCap_content(:file),
	       action=REDCap_action(:import),
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		file=file,
		returnFormat=REDCap_format(returnFormat),
	)
end
