""" 
	delete_arms(config::REDCap.Config, arms::Array) 

Delete Arms from project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `config` - struct containing url and api-key
* `arms` - array of arm names to delete

#### Returns:
number of succesfully deleted arms
"""
function delete_arms(config::REDCap.Config, arms::Array)
	return api_pusher("delete", "arm", config, arms=arms)
end


""" 
	delete_events(config::REDCap.Config, events::Array) 

Delete Events from project. Removing all but one event reverts the project into a longitudinal project.

#### NOTE: This only works for longitudinal projects. 

#### Parameters:
* `config` - struct containing url and api-key
* `events` - array of event names to delete

#### Returns:
number of successfully deleted events
"""
function delete_events(config::REDCap.Config, events::Array)
	return api_pusher("delete", "event", config, events=events)
end


"""
	delete_file(config::REDCap.Config, record::String, field::String, event::String; 
						repeat_instance::Integer=1, returnFormat::String="json") 

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
function delete_file(config::REDCap.Config, record::String, field::String, event::String; 
						repeat_instance::Integer=1, returnFormat::String="json")
	return api_pusher("delete", "file", config, record=record, field=field, event=event, 
							repeat_instance=repeat_instance, returnFormat=returnFormat)
end



"""
	delete_records(config::REDCap.Config, records::Array; arm::Integer=0)

Delete one or more records from project.

#### Parameters:
* `config` - struct containing the url and api-key
* `records` - array of record names to delete
* `arm` - number of arm containing records

#### Returns:
number of records successfully deleted
"""
function delete_records(config::REDCap.Config, records::Array; arm::Integer=0)
	if arm != 0
		#REDCap treats the request differently if arm is sent as a field- dont send if you dont have to
		return api_pusher("delete", "record", config, records=records, arm=arm)
	else
		return api_pusher("delete", "record", config, records=records)
	end
end