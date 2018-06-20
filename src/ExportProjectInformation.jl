""" exportProjectInformation(config::Config; format::String="json", returnFormat::String="json") 

This method allows you to export some of the basic attributes of 
a given REDCap project, such as the project's title, if it is longitudinal, 
if surveys are enabled, the time the project was created and moved to production, etc."""

function exportProjectInformation(config::Config; format::String="json", returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "project",
				  "format" => format,
				  "returnFormat" => returnFormat) #take opt fields

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
