"""
    export_arms(project; arms) -> REDCapTable
    export_arms(project, io::IO; format, arms) -> nothing

Export the study arms of a longitudinal project (columns `arm_num` and `name`).

$IO_METHOD_DOC

# Keyword arguments
- `arms`: only export these arm numbers (scalar or vector)
"""
export_arms(project::REDCapProject; arms = nothing) = api_call(:export_arms, project; arms)

export_arms(project::REDCapProject, io::IO; format, arms = nothing) =
    api_call_io(:export_arms, project, io; format, arms)

"""
    import_arms(project; data, format) -> Int

Add study arms, or rename existing ones (rows with columns `arm_num` and `name`). Existing
arms that are not in `data` are kept; to replace all arms, see [`replace_arms`](@ref).

Returns the number of arms added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_arms(project::REDCapProject; data, format = nothing) = api_call(:import_arms, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deletes **all** existing arms first, together with their events and the records'
    data in them, then imports `data`.

```julia
replace_arms(project; data, format) -> Int
```

Replace all study arms with the arms in `data` (REDCap's `override=1`).

Returns the number of arms imported, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
replace_arms(project::REDCapProject; data, format = nothing) = api_call(:replace_arms, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deleting an arm also deletes its events and all data collected in them.

```julia
delete_arms(project; arms) -> Int
```

Delete study arms. Returns the number of arms deleted, as reported by REDCap.

# Keyword arguments
- `arms` (required): arm numbers (scalar or vector)
"""
delete_arms(project::REDCapProject; arms) = api_call(:delete_arms, project; arms)
