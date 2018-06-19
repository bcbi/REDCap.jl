""" exportSurveyLink(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json") 

This method returns a unique survey link (i.e., a URL) 
in plain text format for a specified record and data 
collection instrument (and event, if longitudinal) in 
a project. If the user does not have 'Manage Survey 
Participants' privileges, they will not be able to use 
this method, and an error will be returned. If the 
specified data collection instrument has not been enabled 
as a survey in the project, an error will be returned."""

function exportSurveyLink(config::Config, record, instrument, event, repeat_instance; returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "surveyLink", 
				  "record" => record,
				  "instrument" => instrument,
				  "event" => event,
				  "repeat_instance" => repeat_instance,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end