""" deleteArms(config::Config, arms=[]) 

This method allows you to delete Arms from a project. Notice: Because of this 
method's destructive nature, it is only available for use for projects in 
Development status. Additionally, please be aware that deleting an arm also 
automatically deletes all events that belong to that arm, and will also 
automatically delete any records/data that have been collected under that 
arm (this is non-reversible data loss).

NOTE: This only works for longitudinal projects. """
###############NOT IMPLEMENTED/BROKEN###############
function deleteArms(config::Config, arms=[])
	
	fields = Dict("token" => config.key, 
				  "content" => "arm", 
				  "action" => "delete",
				  "arms" => arms)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return Int(String(output.body))
end
