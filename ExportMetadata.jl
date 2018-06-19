""" exportMetadata(config::Config; format::String="json") 

This method allows you to export the metadata for a project"""

function exportMetadata(config::Config; format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "metadata", 
				  "format" => format)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end