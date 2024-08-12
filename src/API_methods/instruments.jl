export export_instrument_event_mappings,
       export_instruments,
       export_PDF_of_instruments,
       import_instrument_event_mappings

function export_instrument_event_mappings(;format="xml",arms=nothing,returnFormat=nothing)
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="formEventMapping",
		format=assert_valid_format(format),
		arms=arms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function export_instruments(;format="xml")
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="instrument",
		format=assert_valid_format(format),
	)
end

function export_PDF_of_instruments(;record=nothing,event=nothing,instrument=nothing,repeat_instance=1,allRecords=nothing,compactDisplay="FALSE",returnFormat="xml")
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="pdf",
		record=record,
		event=event,
		instrument=instrument,
		repeat_instance=repeat_instance,
		allRecords=allRecords, #passed vs. value #TODO
		compactDisplay=compactDisplay,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function import_instrument_event_mappings(;format="xml",data=nothing,returnFormat=nothing)
	#TODO: Here and throughout, enforce that this function cannot 
	#behave like an export, since the API calls are similar
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="formEventMapping",
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end
