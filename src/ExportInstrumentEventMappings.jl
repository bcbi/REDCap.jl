""" exportInstrumentEventMappings(config::Config, arms; format::String="json", returnFormat::String="json") 

This method allows you to export the instrument-event mappings for a project 
(i.e., how the data collection instruments are designated for certain events 
in a longitudinal project).

NOTE: This only works for longitudinal projects."""

function exportInstrumentEventMappings(config::Config, arms; format::String="json", returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "formEventMapping", 
				  "format" => format,
				  "arms" => arms,
				  "returnFormat"=> returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
