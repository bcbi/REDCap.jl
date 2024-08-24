export export_instrument_event_mappings,
	export_instruments,
	export_PDF,
	import_instrument_event_mappings

function export_instrument_event_mappings(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:formEventMapping),
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_instruments(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:instrument),
		format=REDCap_format(format),
	)
end

function export_PDF(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	returnFormat::redcap_returnFormat_input=nothing,
		record=nothing,
	event=nothing,
	instrument=nothing,
	repeat_instance=nothing,
	allRecords=nothing,
	compactDisplay=nothing,
)
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:pdf),
		record=record,
		event=event,
		instrument=instrument,
		repeat_instance=repeat_instance,
		allRecords=allRecords, #passed vs. value #TODO
		compactDisplay=compactDisplay,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_instrument_event_mappings(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	data=nothing,
	)

	#TODO: Here and throughout, enforce that this function cannot 
	#behave like an export, since the API calls are similar
	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:formEventMapping),
		format=REDCap_format(format),
		data=REDCap_data(data),
		returnFormat=REDCap_format(returnFormat),
	)
end
