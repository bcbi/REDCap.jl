""" deleteRecords(config::Config, records; arm::Int=0)

This method allows you to delete one or more records from a project in a single API request."""
###############NOT IMPLEMENTED/BROKEN###############
function deleteRecords(config::Config, records; arm::Int=0)
	if arm != 0
		fields = Dict("token" => config.key, 
					  "content" => "record", 
					  "records" => records,
					  "action" => "delete",
					  "arm" => arm);
	else	
		fields = Dict("token" => config.key, 
					  "content" => "record", 
					  "records" => records,
					  "action" => "delete");
	end
	
	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end
