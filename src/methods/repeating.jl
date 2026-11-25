"""
    export_repeating_instruments_and_events(project) -> REDCapTable
    export_repeating_instruments_and_events(project, io::IO; format) -> nothing

Export the project's repeating instruments and events (columns `event_name`, `form_name`
and `custom_form_label`).

$IO_METHOD_DOC
"""
export_repeating_instruments_and_events(project::REDCapProject) =
    api_call(:export_repeating_instruments_and_events, project)

export_repeating_instruments_and_events(project::REDCapProject, io::IO; format) =
    api_call_io(:export_repeating_instruments_and_events, project, io; format)

"""
$DESTRUCTIVE_WARNING
    Replaces the project's **whole** repeating setup: instruments and events not in
    `data` stop repeating. To change part of the setup, export it, edit it, and import the
    full set.

```julia
import_repeating_instruments_and_events(project; data, format) -> Int
```

Import repeating instruments and events (columns `event_name`, `form_name` and
`custom_form_label`).

Returns the number of repeating instruments and events imported, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_repeating_instruments_and_events(project::REDCapProject; data, format = nothing) =
    api_call(:import_repeating_instruments_and_events, project; data, format)
