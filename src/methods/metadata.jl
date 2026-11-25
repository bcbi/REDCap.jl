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

REDCap reads each row of a data dictionary by column position, not by column name, even
in JSON. Table data is therefore sent with the columns in REDCap's order (`field_name`,
`form_name`, `section_header`, `field_type`, …, `field_annotation`, as `export_metadata`
returns them), whatever their order in `data`; missing columns are sent empty, and a column
REDCap doesn't define throws an `ArgumentError`. Pre-formatted `IO` or `REDCapFile` data is
sent unchanged, so its columns must already be in REDCap's order.

# Keyword arguments
$IMPORT_DATA_DOC: `:csv`, `:json` or `:xml`
"""
import_metadata(project::REDCapProject; data, format = nothing) =
    api_call(:import_metadata, project; data, format)
