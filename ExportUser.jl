""" exportUser(config::Config; returnFormat::String="json", format::String="json") 

This method allows you to export the list of users for a project, 
including their user privileges and also email address, first name, 
and last name. Note: If the user has been assigned to a user role, 
it will return the user with the role's defined privileges. """

function exportUser(config::Config; returnFormat::String="json", format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "user", 
				  "format" => format,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end