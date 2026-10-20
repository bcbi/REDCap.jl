"""
    export_metadata(project; fields, forms) -> REDCapTable
    export_metadata(project, io::IO; format, fields, forms) -> nothing

Export the project's data dictionary, one row per field.

Returns a [`REDCapTable`](@ref) of strings. The `IO` method writes the raw response to
`io`, in `format` `:csv`, `:json` or `:xml`.

# Keyword arguments
- `fields`: only export these fields (scalar or vector)
- `forms`: only export the fields of these instruments (scalar or vector)
"""
export_metadata(project::REDCapProject; fields = nothing, forms = nothing) =
    api_call(:export_metadata, project; fields, forms)

export_metadata(project::REDCapProject, io::IO; format, fields = nothing, forms = nothing) =
    api_call_io(:export_metadata, project, io; format, fields, forms)

"""
$DESTRUCTIVE_WARNING
    Replaces the **entire** data dictionary. Fields missing from `data` are removed from
    the project, along with their data.

```julia
import_metadata(project; data, format) -> Int
```

Import a data dictionary. Returns the number of fields imported, as reported by REDCap.

# Keyword arguments
$IMPORT_DATA_DOC: `:csv`, `:json` or `:xml`
"""
import_metadata(project::REDCapProject; data, format = nothing) =
    api_call(:import_metadata, project; data, format)
