"""
    export_users(project) -> REDCapTable
    export_users(project, io::IO; format) -> nothing

Export the project's users and their privileges. Per-instrument rights (`forms`,
`forms_export`) are `Dict` cells.

$IO_METHOD_DOC
"""
export_users(project::REDCapProject) = api_call(:export_users, project)

export_users(project::REDCapProject, io::IO; format) = api_call_io(:export_users, project, io; format)

"""
    import_users(project; data, format) -> Int

Add users to the project, or update their privileges. Privileges not in `data` are left
unchanged for existing users. Per-instrument rights can be given as `Dict` values, e.g.
`forms = Dict("demographics" => 1)`.

Returns the number of users added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_users(project::REDCapProject; data, format = nothing) = api_call(:import_users, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Removes users' access to the project.

```julia
delete_users(project; users) -> Int
```

Remove users from the project. Returns the number of users removed, as reported by REDCap.

# Keyword arguments
- `users` (required): usernames (scalar or vector)
"""
delete_users(project::REDCapProject; users) = api_call(:delete_users, project; users)

"""
    export_user_roles(project) -> REDCapTable
    export_user_roles(project, io::IO; format) -> nothing

Export the project's user roles and their privileges.

$IO_METHOD_DOC
"""
export_user_roles(project::REDCapProject) = api_call(:export_user_roles, project)

export_user_roles(project::REDCapProject, io::IO; format) = api_call_io(:export_user_roles, project, io; format)

"""
    import_user_roles(project; data, format) -> Int

Add user roles, or update existing ones (identified by `unique_role_name`). To create a
role, leave `unique_role_name` blank: REDCap generates it.

Returns the number of roles added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_user_roles(project::REDCapProject; data, format = nothing) =
    api_call(:import_user_roles, project; data, format)

"""
$DESTRUCTIVE_WARNING
    Deletes user roles. Users in a deleted role lose the role's privileges.

```julia
delete_user_roles(project; roles) -> Int
```

Delete user roles. Returns the number of roles deleted, as reported by REDCap.

# Keyword arguments
- `roles` (required): unique role names (scalar or vector)
"""
delete_user_roles(project::REDCapProject; roles) = api_call(:delete_user_roles, project; roles)

"""
    export_user_role_assignments(project) -> REDCapTable
    export_user_role_assignments(project, io::IO; format) -> nothing

Export the users' role assignments (columns `username`, `unique_role_name` and
`data_access_group`).

$IO_METHOD_DOC
"""
export_user_role_assignments(project::REDCapProject) = api_call(:export_user_role_assignments, project)

export_user_role_assignments(project::REDCapProject, io::IO; format) =
    api_call_io(:export_user_role_assignments, project, io; format)

"""
    import_user_role_assignments(project; data, format) -> Int

Assign users to roles (columns `username` and `unique_role_name`; a blank role removes
the user from their role).

Returns the number of assignments added or updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_user_role_assignments(project::REDCapProject; data, format = nothing) =
    api_call(:import_user_role_assignments, project; data, format)
