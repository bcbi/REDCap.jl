export export_users,
import_users,
delete_users

function delete_users(;users=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="user",
		action="delete",
		users=users,
	)
end

function export_users(;format="xml",returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="user",
		format=assert_valid_format(format),
		returnFormat=assert_valid_format(returnFormat),
	)
end

#TODO: Without data, this becomes an export statement
function import_users(;format="xml",data=nothing,returnFormat=nothing)
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="user",
		format=assert_valid_format(format),
		data=data,
		returnFormat=assert_valid_format(returnFormat),
	)
end

