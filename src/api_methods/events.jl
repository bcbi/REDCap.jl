export delete_events,
	import_events,
	export_events

function delete_events(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
		events=nothing,
		)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:event),
		       action=REDCap_action(:import),
		events=events,
	)
end

function export_events(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
		arms=nothing,
		)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		       content=REDCap_content(:event),
		arms=arms,
	)
end

function import_events(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
		data=nothing,
		override=0,
		)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		       content=REDCap_content(:event),
		       action=REDCap_action(:import),
		override=override,
		data=REDCap_data(data,REDCap_format(format),xml_tag="events"),
	)
end

