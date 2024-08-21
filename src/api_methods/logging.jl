export export_logging

function export_logging(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	logtype=nothing,
	user=nothing,
	record=nothing,
	dag=nothing,
	beginTime::redcap_timestamp=nothing,
	endTime::redcap_timestamp=nothing,
	)
	REDCap.request(;
	url=URI(url),
	token=REDCap_token(token),
	content=REDCap_content(:log),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		logtype=logtype,
		user=user,
		record=record,
		dag=dag,
		beginTime=beginTime,
		endTime=endTime,
	)
end
