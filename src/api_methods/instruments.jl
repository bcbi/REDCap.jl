function export_instrument_event_mappings(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		       content=:formEventMapping,
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

function export_instruments(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
		)

	#TODO: mention in docs that certain permissions are needed for various commands
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		       content=:instrument,
		format=REDCap_format(format),
		),
	)
end

function export_PDF(;
	url=get_url(),
	token=get_token(),	
	returnFormat=nothing,
		record=nothing,
	event=nothing,
	instrument=nothing,
	repeat_instance=nothing,
	allRecords=nothing,
	compactDisplay=nothing,
)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		       content=:pdf,
		record=record,
		event=event,
		instrument=instrument,
		repeat_instance=repeat_instance,
		allRecords=allRecords, #passed vs. value #TODO
		compactDisplay=compactDisplay,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

function import_instrument_event_mappings(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	data,
	)

	#TODO: Here and throughout, enforce that this function cannot 
	#behave like an export, since the API calls are similar
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		       content=:formEventMapping,
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		returnFormat=REDCap_format(returnFormat),
		),
	)
end
