function delete_user_roles(;
	url=get_url(),
	token=get_token(),	
	users=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:userRole,
		action=REDCap_action(:delete),
		roles=roles,
	)
end


function export_user_roles(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:userRole,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_roles(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	data,

	)
	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:userRole,
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="users"),
		returnFormat=REDCap_format(returnFormat),
	)
end


function export_user_role_assignments(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:userRoleMapping,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_role_assignments(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	data,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=:userRoleMapping,
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		returnFormat=REDCap_format(returnFormat),
	)
end
