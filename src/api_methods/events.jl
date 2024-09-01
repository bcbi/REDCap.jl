function delete_events(;
	url=get_url(),
	token=get_token(),	
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
		data=nothing, #TODO: required?
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

