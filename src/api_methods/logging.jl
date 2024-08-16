export export_logging

function export_logging(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	logtype=nothing,
	user=nothing,
	record=nothing,
	dag=nothing,
	beginTime::redcap_timestamp=nothing,
	endTime::redcap_timestamp=nothing,
	)
	REDCap.request(;
	       url=url,
	       token=token,
		content=:log,
		format=format,
		returnFormat=returnFormat,
		logtype=logtype,
		user=user,
		record=record,
		dag=dag,
		beginTime=beginTime,
		endTime=endTime,
	)
end
