""" exportSurveyParticipantList(config::Config, instrument, event; returnFormat::String="json", format::String="json") 

This method returns the list of all participants for a specific 
survey instrument (and for a specific event, if a longitudinal project). 
If the user does not have 'Manage Survey Participants' privileges, 
they will not be able to use this method, and an error will be returned. 
If the specified data collection instrument has not been enabled as a 
survey in the project, an error will be returned."""

function exportSurveyParticipantList(config::Config, instrument, event; returnFormat::String="json", format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "participantList", 
				  "format" => format,
				  "instrument" => instrument,
				  "event" => event,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.json(String(output.body))
end
