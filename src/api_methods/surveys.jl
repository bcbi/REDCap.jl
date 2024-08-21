export export_survey_link,
export_survey_participants,
export_survey_queue_link,
export_survey_return_code

function export_survey_link(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	record=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		       content=REDCap_content(:surveyLink),
		record=record,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_participants(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		       content=REDCap_content(:participantList),
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_queue_link(;record=nothing,returnFormat=:xml)
	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
	       content=REDCap_content(:surveyQueueLink),
		record=record,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_return_code(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	returnFormat::redcap_returnFormat_parameter=nothing,
	record=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
)
	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		       content=REDCap_content(:surveyLink),
		record=record,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end


