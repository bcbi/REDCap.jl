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
	return redcap_api("delete", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, returnFormat=returnFormat)
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
		return redcap_api("delete", "record", records=records, arm=arm)
	else
		return redcap_api("delete", "record", records=records)
	end
end
