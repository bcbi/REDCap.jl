""" 
	delete_arms(arms::Array) 

Delete Arms from project. Removing all arms reverts the project into a non-longitudinal project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `arms` - Array of arm names to delete

#### Returns:
Number of succesfully deleted arms
"""
function delete_arms(arms::Array)
	return api_pusher("delete", "arm", arms=arms)
end


""" 
	delete_events(events::Array) 

Delete Events from project. Removing all but one event reverts the project into a non-longitudinal project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `events` - Array of event names to delete

#### Returns:
Number of successfully deleted events
"""
function delete_events(events::Array)
	return api_pusher("delete", "event", config, events=events)
end


"""
	delete_file(record::String, field::String, event::String; repeat_instance::Integer=1, returnFormat::String="json") 

Delete document attached to record.

#### Parameters:
* `record` - Name of record containing file
* `field` - Name of field containing file
* `event` - Name of event containing file
* `repeat_instance` - Number of repeated instances (long project)
* `returnFormat` - Error message format

#### Returns:
Nothing/error
"""
function delete_file(record::String, field::String, event::String; repeat_instance::Integer=1, returnFormat::String="json")
	return api_pusher("delete", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, returnFormat=returnFormat)
end


"""
	delete_records(records::Array; arm::Integer=0)

Delete one or more records from project.

#### Parameters:
* `records` - Array of record names to delete
* `arm` - Number of arm containing records

#### Returns:
Number of records successfully deleted
"""
function delete_records(records::Array; arm::Integer=-1)
	if arm != -1	#REDCap treats the request differently if arm is sent as a field
		return api_pusher("delete", "record", records=records, arm=arm)
	else
		return api_pusher("delete", "record", records=records)
	end
end
