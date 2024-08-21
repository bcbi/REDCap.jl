export export_repeating_instruments_and_events,
import_repeating_instruments_and_events

function export_repeating_instruments_and_events(;format=:xml)
	REDCap.request(
		       content=REDCap_content(:repeatingFormsEvents),
		format=REDCap_format(format),
	)
end

function import_repeating_instruments_and_events(;format=:xml,data=nothing,returnFormat=nothing)
	REDCap.request(
		       content=REDCap_content(:repeatingFormsEvents),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

