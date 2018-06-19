""" deleteEvents(config::Config, events=[]) 

This method allows you to delete Events from a project. Notice: Because of this 
method's destructive nature, it is only available for use for projects in 
Development status. Additionally, please be aware that deleting an event 
will automatically delete any records/data that have been collected under 
that event (this is non-reversible data loss).

NOTE: This only works for longitudinal projects. """
###############NOT IMPLEMENTED/BROKEN###############
function deleteEvents(config::Config, events=[])
	
	fields = Dict("token" => config.key, 
				  "content" => "event", 
				  "action" => "delete",
				  "events" => events)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end