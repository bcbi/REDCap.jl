export export_logging

#TODO: why does the returnFormat parameter not work?
#TODO: What permissible values for logtype?
function export_logging(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	logtype=nothing,
	user=nothing,
	record=nothing,
	dag=nothing,
	beginTime::redcap_timestamp_input=nothing,
	endTime::redcap_timestamp_input=nothing,
	)
	REDCap.request(;
	url=REDCap_url(url),
	token=REDCap_token(token),
	content=REDCap_content(:log),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		logtype=logtype,
		user=user,
		record=record,
		dag=dag,
		beginTime=REDCap_datetime(beginTime),
		endTime=REDCap_datetime(endTime),
	)
end
