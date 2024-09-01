function delete_events(; url=get_url(), token=get_token(), events=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:event, action=:import, events,),
	)
end

function export_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, arms=nothing,)

	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), content=:event, arms,),
	)
end

#TODO: data parameter required?
function import_events(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data=nothing, override=0,)

	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="events"),
		kwargs = (; token=REDCap_token(token), format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), content=:event, action=:import, override,),
	)
end

