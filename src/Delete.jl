include("Utils.jl")

""" 
	delete_arms(config::Config, arms=[]) 

delete Arms from project.

NOTE: This only works for longitudinal projects. 

Parameters:
config::Config - struct containing url and api-key
arms - array of arm names to delete

Returns:
number of succesfully deleted arms
"""

function delete_arms(config::Config, arms=[])
	output = api_pusher("delete", "arm", config, arms=arms)
	return output
end


""" 
	delete_events(config::Config, events=[]) 

delete Events from project.

NOTE: This only works for longitudinal projects. 

Parameters:
config::Config - struct containing url and api-key
events - array of event names to delete

Returns:
number of successfully deleted events
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

Parameters:
config::Config - struct containing url and api-key
record::String - name of record containing file
field::String - name of field containing file
event::String - name of event containing file
repeat_instance::Int - number of repeated instances (long project)
returnFormat::String - error message format

Returns:
nothing/error
"""

function delete_file(config::Config, record::String, field::String, event::String, repeat_instance::Int; 
					returnFormat::String="json")
	output = api_pusher("delete", "arm", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							returnFormat=returnFormat)
	return output
end



"""
	delete_records(config::Config, records; arm::Int=0)

delete one or more records from project.

Parameters:
config::Config - struct containing the url and api-key
records - array of record names to delete
arm::Int - number of arm containing records

Returns:
number of records successfully deleted
"""

function delete_records(config::Config, records=[]; arm::Int=0)
	if arm != 0
		return output = api_pusher("delete", "arm", config, records=records, arm=arm)
	else	
		return output = api_pusher("delete", "arm", config, records=records)
	end
end