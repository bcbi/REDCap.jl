include("Utils.jl")

""" 
	delete_arms(config::Config, arms=[]) 

delete Arms from project.

#NOTE: This only works for longitudinal projects. 

##Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to delete

##Returns:
number of succesfully deleted arms
"""

function delete_arms(config::Config, arms=[])
	output = api_pusher("delete", "arm", config, arms=arms)
	return output
end


""" 
	delete_events(config::Config, events=[]) 

delete Events from project.

#NOTE: This only works for longitudinal projects. 

##Parameters:
* `config` - struct containing url and api-key
* `events` - array of event names to delete

##Returns:
number of successfully deleted events
"""

function delete_events(config::Config, events=[])
	output = api_pusher("delete", "event", config, events=events)
	return output
end


"""
	delete_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int; 
				returnFormat::String="json") 

delete document attached to record.

##Parameters:
* `config` - struct containing url and api-key
* `record` - name of record containing file
* `field` - name of field containing file
* `event` - name of event containing file
* `repeat_instance` - number of repeated instances (long project)
* `returnFormat` - error message format

##Returns:
nothing/error
"""

function delete_file(config::Config, record::String, field::String, event::String, repeat_instance::Integer; 
					returnFormat::String="json")
	output = api_pusher("delete", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							returnFormat=returnFormat)
	return output
end



"""
	delete_records(config::Config, records=[]; arm::Int=0)

delete one or more records from project.

##Parameters:
* `config` - struct containing the url and api-key
* `records` - array of record names to delete
* `arm` - number of arm containing records

##Returns:
number of records successfully deleted
"""

function delete_records(config::Config, records; arm::Integer=0)
	#work on this - broken
	if isa(records, Array)
		if arm != 0
			return output = api_pusher("delete", "record", config, records=records, arm=arm)
		else
			println("no ARM")
			return output = api_pusher("delete", "record", config, records=records)
			#=
				ERROR: BoundsError
			=#
		end
	else
		println("Records must be passed as an array!")
	end
end