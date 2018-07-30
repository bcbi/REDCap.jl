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
___
```julia
delete_records(config, ["1","2","25"])
```
The number of records deleted will be returned. If a record is specified that does not exist, REDCap will throw an error (It will <b>NOT</b> delete the valid ids).

## Files
___
```@docs
delete_file(config::REDCap.Config, record::String, field::String, event::String; repeat_instance::Integer=1, returnFormat::String="json") 
```
___
```julia
delete_file(config, "2", "file_upload", "")
```

## Arms
___
```@docs
delete_arms(config::REDCap.Config, arms::Array) 
```
___
```julia
delete_arms(config, ["<arm>", "<arm-2>"])
```

## Events
___
```@docs
delete_events(config::REDCap.Config, events::Array)
```
___
```julia
delete_events(config, ["<event>", "<event-2>"])
```