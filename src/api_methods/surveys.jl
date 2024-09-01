function export_survey_link(;
	url=get_url(),
	token=get_token(),	
	returnFormat=nothing,
	record=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
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
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:surveyQueueLink),
		record=record,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_return_code(;
	url=get_url(),
	token=get_token(),	
	returnFormat=nothing,
	record=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
)
	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:surveyLink),
		record=record,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end


