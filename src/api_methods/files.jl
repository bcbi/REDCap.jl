function delete_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:delete, record, field, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end

function export_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:export, record, field, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end

function import_file(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, field=nothing, event=nothing, repeat_instance=nothing, file=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:file, action=:import, record, field, event, repeat_instance, file, returnFormat=REDCap_format(returnFormat),),
	)
end
