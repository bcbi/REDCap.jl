export export_logging

function export_logging(;format="xml",returnFormat=nothing,logtype=nothing,user=nothing,record=nothing,dag=nothing,beginTime=nothing,endTime=nothing)
	REDCap.request(;
		content="log",
		format=assert_valid_format(format),
		returnFormat=isnothing(returnFormat) ? format : "xml",
		logtype=logtype,
		user=user,
		record=record,
		dag=dag,
		beginTime=beginTime,
		endTime=endTime,
	)
end
