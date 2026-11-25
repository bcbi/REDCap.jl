const FILE_FIELD_DOC = """
- `record` (required): the record name
- `field` (required): the name of the File Upload or Signature field
- `event`: the unique event name (longitudinal projects)
- `repeat_instance`: the repeat instance (default 1)"""

"""
    export_file(project; record, field, event, repeat_instance) -> REDCapDownload
    export_file(project, io::IO; record, field, event, repeat_instance) -> nothing

Export the file stored in a record's File Upload or Signature field.

$DOWNLOAD_DOC

# Keyword arguments
$FILE_FIELD_DOC
"""
export_file(project::REDCapProject; record, field, event = nothing, repeat_instance = nothing) =
    api_call(:export_file, project; record, field, event, repeat_instance)

export_file(project::REDCapProject, io::IO; record, field, event = nothing, repeat_instance = nothing) =
    api_call_io(:export_file, project, io; record, field, event, repeat_instance)

"""
$DESTRUCTIVE_WARNING
    Replaces any file already stored in the field.

```julia
import_file(project; record, field, file, filename, event, repeat_instance) -> nothing
```

Upload a file into a record's File Upload field.

# Keyword arguments
$FILE_FIELD_DOC
$UPLOAD_DOC
"""
function import_file(
        project::REDCapProject;
        record, field, file, filename = nothing, event = nothing, repeat_instance = nothing,
    )
    return api_call(:import_file, project; file, filename, record, field, event, repeat_instance)
end

"""
$DESTRUCTIVE_WARNING
    Deletes the file stored in the field.

```julia
delete_file(project; record, field, event, repeat_instance) -> nothing
```

Delete the file stored in a record's File Upload or Signature field.

# Keyword arguments
$FILE_FIELD_DOC
"""
delete_file(project::REDCapProject; record, field, event = nothing, repeat_instance = nothing) =
    api_call(:delete_file, project; record, field, event, repeat_instance)
