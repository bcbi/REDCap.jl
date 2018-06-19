""" exportSurveyQueueLink(config::Config, record; returnFormat::String="json") 

This method returns a unique Survey Queue link (i.e., a URL) 
in plain text format for the specified record in a project 
that is utilizing the Survey Queue feature. If the user does 
not have 'Manage Survey Participants' privileges, they will 
not be able to use this method, and an error will be returned. 
If the Survey Queue feature has not been enabled in the project, 
an error will be returned."""

function exportSurveyQueueLink(config::Config, record; returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "surveyQueueLink",
				  "record" => record,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end