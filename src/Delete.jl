include("Utils.jl")

""" 
	delete_arms(config::Config, arms=[]) 

delete Arms from project.

NOTE: This only works for longitudinal projects. 
"""

function delete_arms(config::Config, arms=[])
	output = api_pusher("delete", "arm", config, arms=arms)
	return output
end


""" 
	delete_events(config::Config, events=[]) 

delete Events from project.

NOTE: This only works for longitudinal projects. 
"""

function delete_events(config::Config, events=[])
	output = api_pusher("delete", "arm", config, events=events)
	return output
end


"""
	delete_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
				returnFormat::String="json") 

delete document attached to record.

individual record for a File Upload field.
"""

function delete_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
					returnFormat::String="json")
	output = api_pusher("delete", "arm", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							returnFormat=returnFormat)
	return output
end



"""
	delete_records(config::Config, records; arm::Int=0)

delete one or more records from project.
"""

function delete_records(config::Config, records; arm::Int=0)
	if arm != 0
		return output = api_pusher("delete", "arm", config, records=records, arm=arm)
	else	
		return output = api_pusher("delete", "arm", config, records=records)
	end
end