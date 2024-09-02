function delete_users(; url=get_url(), token=get_token(), users=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:user, action=:delete, users,),
	)
end

function export_users(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:user, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

function import_users(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)
	REDCap.request(
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="users"),
		kwargs = (; token=REDCap_token(token), content=:user, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

