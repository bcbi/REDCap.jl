export export_repeating_instruments_and_events,
import_repeating_instruments_and_events

function export_repeating_instruments_and_events(;
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		content=REDCap_content(:repeatingFormsEvents),
		format=REDCap_format(format),
	)
end

function import_repeating_instruments_and_events(;
	url::redcap_url_parameter=get_url(),
	token::redcap_super_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	data::redcap_data_parameter, #TODO: the docs mention a super API token may be used here...?
	#TODO: data parameter is essential to distringuish from an export
	#TODO: does is make sense to define one method in terms of the other?
	)

	REDCap.request(
		content=REDCap_content(:repeatingFormsEvents),
		url=URI(url),
		token=REDCap_token(token),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

