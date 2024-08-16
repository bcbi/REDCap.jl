export export_user_roles,
import_user_roles,
delete_user_roles,
export_user_role_assignment,
import_user_role_assignment

function delete_user_roles(;roles=nothing)
	REDCap.request(
		content="userRole",
		action="delete",
		roles=roles,
	)
end


function export_user_roles(;format="xml",returnFormat=nothing)
	REDCap.request(
		content="userRole",
		format=format,
		returnFormat=returnFormat,
	)
end

#TODO: Without data, this becomes an export statement
function import_user_roles(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		content="userRole",
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end


function export_user_role_assignment(;format="xml",returnFormat=nothing)
	REDCap.request(
		content="userRoleMapping",
		format=format,
		returnFormat=returnFormat,
	)
end

#TODO: Without data, this becomes an export statement
function import_user_role_assignment(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		content="userRoleMapping",
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end
