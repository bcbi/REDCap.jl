""" importFile(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					returnFormat::String="json") 

This method allows you to upload a document that will be attached to an 
individual record for a File Upload field. Please note that this method 
may NOT be used for Signature fields (i.e. File Upload fields with 
'signature' validation type) because a signature can only be captured 
and stored using the web interface."""
###############NOT IMPLEMENTED/BROKEN###############
function importFile(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "file",
				  "action" => "delete",
				  "record" => record,
				  "field" => field,
				  "event" => event,
				  "repeat_instance" => repeat_instance,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end
