export export_logging

function export_logging(;
	url=get_valid_url(),
	token=get_valid_token(),	
		format="xml",returnFormat=nothing,logtype=nothing,user=nothing,record=nothing,dag=nothing,beginTime=nothing,endTime=nothing)
	REDCap.request(;
		       url=url,
		       token=token,
		content="log",
		format=format,
		returnFormat=isnothing(returnFormat) ? format : "xml",
		logtype=logtype,
		user=user,
		record=record,
		dag=dag,
		beginTime=beginTime,
		endTime=endTime,
	)
end
