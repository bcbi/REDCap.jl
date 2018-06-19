""" importMetadata(config::Config, metaData; format::String="json", returnFormat::String="json") 

 This method allows you to import metadata (i.e., Data Dictionary) into a project. 
 Notice: Because of this method's destructive nature, it is only available for 
 use for projects in Development status."""
###############NOT IMPLEMENTED/BROKEN###############
function importMetadata(config::Config, metaData; format::String="json", returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "metadata", 
				  "data" => data,
				  "format" => format)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end