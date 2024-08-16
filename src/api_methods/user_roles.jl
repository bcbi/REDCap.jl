export export_user_roles,
	import_user_roles,
	delete_user_roles,
	export_user_role_assignments,
	import_user_role_assignments

function delete_user_roles(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	users::redcap_array=nothing,
	)

	REDCap.request(
		url=url,
		token=token,
		content=:userRole,
		action=:delete,
		roles=roles,
	)
end


function export_user_roles(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(
		url=url,
		token=token,
		content=:userRole,
		format=format,
		returnFormat=returnFormat,
	)
end

function import_user_roles(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	data::redcap_data_parameter,

	)
	REDCap.request(
		url=url,
		token=token,
		content=:userRole,
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end


function export_user_role_assignments(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(
		url=url,
		token=token,
		content=:userRoleMapping,
		format=format,
		returnFormat=returnFormat,
	)
end

function import_user_role_assignments(;
	url::redcap_url_parameter=get_valid_url(),
	token::redcap_token_parameter=get_valid_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	data::redcap_data_parameter,
	)

	REDCap.request(
		url=url,
		token=token,
		content=:userRoleMapping,
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end
