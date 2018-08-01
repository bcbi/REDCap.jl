```@meta
CurrentModule = REDCap
```
# Deleting

Records, Files, Arms, and Events may be deleted from a project via API call.

## Records
___
```@docs
delete_records(config::REDCap.Config, records::Array; arm::Integer=0)
```

An array of `record_id` names is passed, and if they exist, they will be deleted.
___
```julia
#For non-longitudinal projects
delete_records(config, ["1","2","25"])

delete_records(config, ["1","2","25"], arm=)
```
The number of records deleted will be returned. If a record is specified that does not exist, REDCap will throw an error (It will <b>NOT</b> delete the valid ids).

## Files
___
```@docs
delete_file(config::REDCap.Config, record::String, field::String, event::String; repeat_instance::Integer=1, returnFormat::String="json") 
```

The location of the file must be specified by passing the record name, the field containing the file, and the event.
___
```julia
delete_file(config, "2", "file_upload", "")
```
The number of files deleted will be returned.

## Arms
___
```@docs
delete_arms(config::REDCap.Config, arms::Array) 
```
A list of arms to be deleted in passed.
___
```julia
delete_arms(config, ["<arm>", "<arm-2>"])
```
The number of arms deleted is returned.

## Events
___
```@docs
delete_events(config::REDCap.Config, events::Array)
```
___

A list of events to be deleted is passed.
```julia
delete_events(config, ["event_1_arm_1"])
```
The number of events deleted is returned.