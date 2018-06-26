""" exportFile(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
				format::String="json", returnFormat::String="json") 

This method allows you to download a document that has been attached 
to an individual record for a File Upload field. Please note that 
this method may also be used for Signature fields (i.e. File Upload 
fields with 'signature' validation type).

Note about export rights: Please be aware that Data Export user 
rights will be applied to this API request. For example, if you 
have 'No Access' data export rights in the project, then the API 
file export will fail and return an error. And if you have 'De-Identified' 
or 'Remove all tagged Identifier fields' data export rights, then 
the API file export will fail and return an error *only if* the File Upload 
field has been tagged as an Identifier field. To make sure that your API 
request does not return an error, you should have 'Full Data Set' export 
rights in the project."""


function exportFile(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					format::String="json", returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "file", 
				  "format" => format,
				  "record" => record,
				  "field" => field,
				  "event" => event,
				  "repeat_instance" => repeat_instance,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
