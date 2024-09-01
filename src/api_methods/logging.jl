#TODO: why does the returnFormat parameter not work?
#TODO: What permissible values for logtype?
function export_logging(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	logtype=nothing,
	user=nothing,
	record=nothing,
	dag=nothing,
	beginTime=nothing,
	endTime=nothing,
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
