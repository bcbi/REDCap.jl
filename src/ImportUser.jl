""" importUser(config::Config, userData; returnFormat::String="json", format::String="json") 

This method allows you to import new users into a project while 
setting their user privileges, or update the privileges of existing 
users in the project. """
###############NOT IMPLEMENTED/BROKEN###############
function importUser(config::Config, userData; returnFormat::String="json", format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "user", 
				  "format" => format,
				  "data" => userData,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end
