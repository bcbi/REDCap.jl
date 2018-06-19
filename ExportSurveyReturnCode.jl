""" exportSurveyReturnCode(config::Config, record; returnFormat::String="json") 

This method returns a unique Return Code in plain text format 
for a specified record and data collection instrument 
(and event, if longitudinal) in a project. If the user 
does not have 'Manage Survey Participants' privileges, 
they will not be able to use this method, and an error 
will be returned. If the specified data collection instrument 
has not been enabled as a survey in the project or does not have 
the 'Save & Return Later' feature enabled, an error will be returned."""

function exportSurveyReturnCode(config::Config, record; returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "surveyReturnCode",
				  "record" => record,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end