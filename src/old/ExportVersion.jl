""" exportVersion(config::Config; returnFormat::String="json", format::String="json") 

This method returns the current REDCap version number 
as plain text (e.g., 4.13.18, 5.12.2, 6.0.0)."""

function exportVersion(config::Config; returnFormat::String="json", format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "version", 
				  "format" => format,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end
