""" importProjectInformation(config::Config, infoData; format::String="json") 

This method allows you to update some of the basic attributes of a given REDCap 
project, such as the project's title, if it is longitudinal, if surveys are 
enabled, etc. Its data format corresponds to the format in the API method 
Export Project Information."""
###############NOT IMPLEMENTED/BROKEN###############
function importProjectInformation(config::Config, infoData; format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "project_settings",
				  "format" => format,
				  "data" => data) #take opt fields

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end
