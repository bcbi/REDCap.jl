export export_survey_link,
export_survey_participants,
export_survey_queue_link,
export_survey_return_code

function export_survey_link(;record=nothing,instrument=nothing,event=nothing,repeat_instance=nothing,returnFormat=:xml)
	REDCap.request(
		       content=REDCap_content(:surveyLink),
		record=record,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_participants(;instrument=nothing,event=nothing,repeat_instance=nothing,format=:xml,returnFormat=nothing)
	REDCap.request(
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
		       content=REDCap_content(:surveyQueueLink),
		record=record,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_survey_return_code(;record=nothing,instrument=nothing,event=nothing,repeat_instance=nothing,returnFormat=:xml)
	REDCap.request(
		       content=REDCap_content(:surveyLink),
		record=record,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=REDCap_format(returnFormat),
	)
end


