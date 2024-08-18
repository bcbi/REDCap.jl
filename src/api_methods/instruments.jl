export export_instrument_event_mappings,
	export_instruments,
	export_PDF,
	import_instrument_event_mappings

function export_instrument_event_mappings(;format=:xml,arms=nothing,returnFormat=nothing)
	REDCap.request(;
		content=:formEventMapping,
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_instruments(;format=:xml)
	REDCap.request(;
		content=:instrument,
		format=REDCap_format(format),
	)
end

function export_PDF(;record=nothing,event=nothing,instrument=nothing,repeat_instance=1,allRecords=nothing,compactDisplay="FALSE",returnFormat=:xml)
	REDCap.request(;
		content=:pdf,
		record=record,
		event=event,
		instrument=instrument,
		repeat_instance=repeat_instance,
		allRecords=allRecords, #passed vs. value #TODO
		compactDisplay=compactDisplay,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_instrument_event_mappings(;format=:xml,data=nothing,returnFormat=nothing)
	#TODO: Here and throughout, enforce that this function cannot 
	#behave like an export, since the API calls are similar
	REDCap.request(;
		content=:formEventMapping,
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end
