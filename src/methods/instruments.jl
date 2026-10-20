"""
    export_field_names(project; field) -> REDCapTable
    export_field_names(project, io::IO; format, field) -> nothing

Export the field names used in record exports (columns `original_field_name`,
`choice_value` and `export_field_name`). Checkbox fields have one export field per choice.

$IO_METHOD_DOC

# Keyword arguments
- `field`: only export this field's names
"""
export_field_names(project::REDCapProject; field = nothing) = api_call(:export_field_names, project; field)

export_field_names(project::REDCapProject, io::IO; format, field = nothing) =
    api_call_io(:export_field_names, project, io; format, field)

"""
    export_instruments(project) -> REDCapTable
    export_instruments(project, io::IO; format) -> nothing

Export the project's instruments (columns `instrument_name` and `instrument_label`).

$IO_METHOD_DOC
"""
export_instruments(project::REDCapProject) = api_call(:export_instruments, project)

export_instruments(project::REDCapProject, io::IO; format) = api_call_io(:export_instruments, project, io; format)

"""
    export_PDF(project; record, event, instrument, repeat_instance, compactDisplay) -> REDCapDownload
    export_PDF(project, io::IO; ...) -> nothing

Export instruments as a PDF: blank, or filled with one record's data when `record` is
given. To export all records, see [`export_PDF_all_records`](@ref).

$DOWNLOAD_DOC

# Keyword arguments
- `record`: the record whose data fills the PDF (default: blank instruments)
- `event`: only this unique event name (longitudinal projects)
- `instrument`: only this instrument
- `repeat_instance`: the repeat instance (default 1)
- `compactDisplay`: leave out empty fields and unselected choices (`Bool`)
"""
function export_PDF(
        project::REDCapProject;
        record = nothing, event = nothing, instrument = nothing, repeat_instance = nothing,
        compactDisplay = nothing,
    )
    return api_call(:export_PDF, project; record, event, instrument, repeat_instance, compactDisplay)
end

function export_PDF(
        project::REDCapProject, io::IO;
        record = nothing, event = nothing, instrument = nothing, repeat_instance = nothing,
        compactDisplay = nothing,
    )
    return api_call_io(:export_PDF, project, io; record, event, instrument, repeat_instance, compactDisplay)
end

"""
    export_PDF_all_records(project; compactDisplay) -> REDCapDownload
    export_PDF_all_records(project, io::IO; compactDisplay) -> nothing

Export all instruments (and events) with the data of all records as one PDF.

$DOWNLOAD_DOC

# Keyword arguments
- `compactDisplay`: leave out empty fields and unselected choices (`Bool`)
"""
export_PDF_all_records(project::REDCapProject; compactDisplay = nothing) =
    api_call(:export_PDF_all_records, project; compactDisplay)

export_PDF_all_records(project::REDCapProject, io::IO; compactDisplay = nothing) =
    api_call_io(:export_PDF_all_records, project, io; compactDisplay)

"""
    export_instrument_event_mappings(project; arms) -> REDCapTable
    export_instrument_event_mappings(project, io::IO; format, arms) -> nothing

Export which instruments are used in which events of a longitudinal project (columns
`arm_num`, `unique_event_name` and `form`).

$IO_METHOD_DOC

# Keyword arguments
- `arms`: only export the mappings of these arm numbers (scalar or vector)
"""
export_instrument_event_mappings(project::REDCapProject; arms = nothing) =
    api_call(:export_instrument_event_mappings, project; arms)

export_instrument_event_mappings(project::REDCapProject, io::IO; format, arms = nothing) =
    api_call_io(:export_instrument_event_mappings, project, io; format, arms)

"""
$DESTRUCTIVE_WARNING
    May replace the existing instrument-event mappings; data in instruments that are no
    longer mapped to an event becomes inaccessible. TODO(verify) the exact behavior.

```julia
import_instrument_event_mappings(project; data, format) -> Int
```

Import which instruments are used in which events (columns `arm_num`,
`unique_event_name` and `form`).

Returns the number of mappings imported, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_instrument_event_mappings(project::REDCapProject; data, format = nothing) =
    api_call(:import_instrument_event_mappings, project; data, format)
