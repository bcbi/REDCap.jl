""" exportArms(config::Config; format::String="json", arms, returnFormat::String="json") 

This method allows you to export the Arms for a project

NOTE: This only works for longitudinal projects."""

function exportArms(config::Config; format::String="json", arms=[], returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "arm", 
				  "format" => format,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
