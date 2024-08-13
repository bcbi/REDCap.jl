export export_user_roles,
import_user_roles,
delete_user_roles,
export_user_role_assignment,
import_user_role_assignment

function delete_user_roles(;roles=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="userRole",
		action="delete",
		roles=roles,
	)
end


function export_user_roles(;format="xml",returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="userRole",
		format=assert_valid_format(format),
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

#TODO: Without data, this becomes an export statement
function import_user_roles(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="userRole",
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end


function export_user_role_assignment(;format="xml",returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="userRoleMapping",
		format=assert_valid_format(format),
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

#TODO: Without data, this becomes an export statement
function import_user_role_assignment(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="userRoleMapping",
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end
