""" exportInstruments(config::Config; format::String="json") 

This method allows you to export a list of the data collection 
instruments for a project. This includes their unique instrument 
name as seen in the second column of the Data Dictionary, as well 
as each instrument's corresponding instrument label, which is 
seen on a project's left-hand menu when entering data. The instruments 
will be ordered according to their order in the project."""

function exportInstruments(config::Config; format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "instrument", 
				  "format" => format)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
