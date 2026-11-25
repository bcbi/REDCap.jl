"""
    export_events(project; arms) -> REDCapTable
    export_events(project, io::IO; format, arms) -> nothing

Export the events of a longitudinal project (columns such as `event_name`, `arm_num` and
`unique_event_name`).

$IO_METHOD_DOC

# Keyword arguments
- `arms`: only export the events of these arm numbers (scalar or vector)
"""
export_events(project::REDCapProject; arms = nothing) = api_call(:export_events, project; arms)

export_events(project::REDCapProject, io::IO; format, arms = nothing) =
    api_call_io(:export_events, project, io; format, arms)

"""
    import_events(project; data, format) -> Int

Add events, or update existing ones (identified by `unique_event_name`). Existing events
that are not in `data` are kept; to replace all events, see [`replace_events`](@ref).

Returns the number of events added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_events(project::REDCapProject; data, format = nothing) = api_call(:import_events, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deletes **all** existing events first, together with the data collected in them,
    then imports `data`.

```julia
replace_events(project; data, format) -> Int
```

Replace all events with the events in `data` (REDCap's `override=1`).

Returns the number of events imported, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
replace_events(project::REDCapProject; data, format = nothing) = api_call(:replace_events, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deleting an event also deletes all data collected in it.

```julia
delete_events(project; events) -> Int
```

Delete events. Returns the number of events deleted, as reported by REDCap.

# Keyword arguments
- `events` (required): unique event names (scalar or vector)
"""
delete_events(project::REDCapProject; events) = api_call(:delete_events, project; events)
