export export_user_roles,
	import_user_roles,
	delete_user_roles,
	export_user_role_assignments,
	import_user_role_assignments

function delete_user_roles(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	users::redcap_array=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:userRole),
		action=REDCap_action(:delete),
		roles=roles,
	)
end


function export_user_roles(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:userRole),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_roles(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	data::redcap_data_parameter,

	)
	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:userRole),
		format=REDCap_format(format),
		data=REDCap_data(data),
		returnFormat=REDCap_format(returnFormat),
	)
end


function export_user_role_assignments(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:userRoleMapping),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_user_role_assignments(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	data::redcap_data_parameter,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:userRoleMapping),
		format=REDCap_format(format),
		data=REDCap_data(data),
		returnFormat=REDCap_format(returnFormat),
	)
end
