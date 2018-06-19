""" importInstrumentEventMappings(config::Config, arms, instData; format::String="json", 
									returnFormat::String="json") 

This method allows you to import Instrument-Event Mappings into a project (this corresponds to the 'Designate Instruments for My Events' page in the project).

NOTE: This only works for longitudinal projects."""
###############NOT IMPLEMENTED/BROKEN###############
function importInstrumentEventMappings(config::Config, arms, instData; format::String="json", 
										returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "formEventMapping", 
				  "format" => format,
				  "data" => data,
				  "arms" => arms,
				  "returnFormat"=> returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end