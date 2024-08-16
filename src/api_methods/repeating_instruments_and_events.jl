export export_repeating_instruments_and_events,
import_repeating_instruments_and_events

function export_repeating_instruments_and_events(;format=:xml)
	REDCap.request(
		content=:repeatingFormsEvents,
		format=format,
	)
end

function import_repeating_instruments_and_events(;format=:xml,data=nothing,returnFormat=nothing)
	REDCap.request(
		content=:repeatingFormsEvents,
		format=format,
		returnFormat=returnFormat,
	)
end

