include("Utils.jl")

""" 
	delete_arms(config::Config, arms=[]) 

Delete Arms from project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to delete

#### Returns:
number of succesfully deleted arms
"""
###BROKEN### - see HTTP's array handling in escapeuri()
function delete_arms(config::Config, arms::Array)
	output = api_pusher("delete", "arm", config, arms=array_to_string(arms))
	return output
end


""" 
	delete_events(config::Config, events=[]) 

Delete Events from project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `config` - struct containing url and api-key
* `events` - array of event names to delete

#### Returns:
number of successfully deleted events
"""
###BROKEN### - see HTTP's array handling in escapeuri()
function delete_events(config::Config, events::Array)
	output = api_pusher("delete", "event", config, events=array_to_string(events))
	return output
end


"""
	delete_file(config::Config, record::Int, field::String, event::String, 
					repeat_instance::Int; returnFormat::String="json") 

Delete document attached to record.

#### Parameters:
* `config` - struct containing url and api-key
* `record` - name of record containing file
* `field` - name of field containing file
* `event` - name of event containing file
* `repeat_instance` - number of repeated instances (long project)
* `returnFormat` - error message format

#### Returns:
nothing/error
"""
function delete_file(config::Config, record::String, field::String, event::String, 
						repeat_instance::Integer; returnFormat::String="json")
	output = api_pusher("delete", "file", config, record=record, field=field, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
	return output
end



"""
	delete_records(config::Config, records=[]; arm::Int=0)

Delete one or more records from project.

#### Parameters:
* `config` - struct containing the url and api-key
* `records` - array of record names to delete
* `arm` - number of arm containing records

#### Returns:
number of records successfully deleted
"""
function delete_records(config::Config, records::Array; arm::Integer=0)
	#work on this - broken
	if arm != 0
		return output = api_pusher("delete", "record", config, records=array_to_string(records), arm=arm)
	else
		#println("no ARM")
		return output = api_pusher("delete", "record", config, records=array_to_string(records))
	end
end