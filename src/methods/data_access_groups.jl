"""
    export_DAGs(project) -> REDCapTable
    export_DAGs(project, io::IO; format) -> nothing

Export the project's Data Access Groups (columns such as `data_access_group_name` and
`unique_group_name`).

$IO_METHOD_DOC
"""
export_DAGs(project::REDCapProject) = api_call(:export_DAGs, project)

export_DAGs(project::REDCapProject, io::IO; format) = api_call_io(:export_DAGs, project, io; format)

"""
    import_DAGs(project; data, format) -> Int

Add Data Access Groups, or rename existing ones. A row with a blank `unique_group_name`
creates a new group; a row with an existing `unique_group_name` renames that group.

Returns the number of groups added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_DAGs(project::REDCapProject; data, format = nothing) = api_call(:import_DAGs, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deletes Data Access Groups. Records in them are kept but no longer belong to a group.

```julia
delete_DAGs(project; dags) -> Int
```

Delete Data Access Groups. Returns the number of groups deleted, as reported by REDCap.

# Keyword arguments
- `dags` (required): unique group names (scalar or vector)
"""
delete_DAGs(project::REDCapProject; dags) = api_call(:delete_DAGs, project; dags)

"""
    switch_DAG(project; dag) -> nothing

Switch the API user's current Data Access Group. The user must be allowed to switch
into `dag`.

# Keyword arguments
- `dag` (required): the unique group name
"""
switch_DAG(project::REDCapProject; dag) = api_call(:switch_DAG, project; dag)

"""
    export_user_DAG_assignment(project) -> REDCapTable
    export_user_DAG_assignment(project, io::IO; format) -> nothing

Export the users' Data Access Group assignments (columns `username` and
`redcap_data_access_group`).

$IO_METHOD_DOC
"""
export_user_DAG_assignment(project::REDCapProject) = api_call(:export_user_DAG_assignment, project)

export_user_DAG_assignment(project::REDCapProject, io::IO; format) =
    api_call_io(:export_user_DAG_assignment, project, io; format)

"""
    import_user_DAG_assignment(project; data, format) -> Int

Assign users to Data Access Groups (columns `username` and `redcap_data_access_group`;
a blank group removes the user's assignment).

Returns the number of assignments added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_user_DAG_assignment(project::REDCapProject; data, format = nothing) =
    api_call(:import_user_DAG_assignment, project; data, format)
