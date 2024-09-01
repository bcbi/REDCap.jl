export export_repeating_instruments_and_events,
import_repeating_instruments_and_events

function export_repeating_instruments_and_events(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:repeatingFormsEvents),
		format=REDCap_format(format),
	)
end

function import_repeating_instruments_and_events(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	data,
	)

	REDCap.request(
		content=REDCap_content(:repeatingFormsEvents),
		url=REDCap_url(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

