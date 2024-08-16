export export_users,
import_users,
delete_users

function delete_users(;users=nothing)
	REDCap.request(
		content="user",
		action="delete",
		users=users,
	)
end

function export_users(;format="xml",returnFormat=nothing)
	REDCap.request(
		content="user",
		format=format,
		returnFormat=returnFormat,
	)
end

#TODO: Without data, this becomes an export statement
function import_users(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		content="user",
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end

