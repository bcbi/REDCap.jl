"""
    create_file_repository_folder(project; name, folder_id, dag_id, role_id) -> Int

Create a folder in the File Repository. Returns the new folder's `folder_id`.

TODO(verify): the response format (`[{"folder_id": n}]`).

# Keyword arguments
- `name` (required): the folder name (at most 150 characters)
- `folder_id`: the parent folder (default: the top level)
- `dag_id`: restrict access to this Data Access Group ID
- `role_id`: restrict access to this user role ID
"""
function create_file_repository_folder(
        project::REDCapProject; name, folder_id = nothing, dag_id = nothing, role_id = nothing,
    )
    return api_call(:create_file_repository_folder, project; name, folder_id, dag_id, role_id)
end

"""
    export_file_repository_list(project; folder_id) -> REDCapTable
    export_file_repository_list(project, io::IO; format, folder_id) -> nothing

List the files and folders in one File Repository folder (not its subfolders), with
columns such as `folder_id`, `doc_id` and `name`.

$IO_METHOD_DOC

# Keyword arguments
- `folder_id`: the folder to list (default: the top level)
"""
export_file_repository_list(project::REDCapProject; folder_id = nothing) =
    api_call(:export_file_repository_list, project; folder_id)

export_file_repository_list(project::REDCapProject, io::IO; format, folder_id = nothing) =
    api_call_io(:export_file_repository_list, project, io; format, folder_id)

"""
    export_file_from_file_repository(project; doc_id) -> REDCapDownload
    export_file_from_file_repository(project, io::IO; doc_id) -> nothing

Export a file from the File Repository.

$DOWNLOAD_DOC

# Keyword arguments
- `doc_id` (required): the file's `doc_id` (see [`export_file_repository_list`](@ref))
"""
export_file_from_file_repository(project::REDCapProject; doc_id) =
    api_call(:export_file_from_file_repository, project; doc_id)

export_file_from_file_repository(project::REDCapProject, io::IO; doc_id) =
    api_call_io(:export_file_from_file_repository, project, io; doc_id)

"""
    import_file_into_file_repository(project; file, filename, folder_id) -> nothing

Upload a file into the File Repository.

# Keyword arguments
$UPLOAD_DOC
- `folder_id`: the folder to upload into (default: the top level)
"""
import_file_into_file_repository(project::REDCapProject; file, filename = nothing, folder_id = nothing) =
    api_call(:import_file_into_file_repository, project; file, filename, folder_id)

"""
$DESTRUCTIVE_WARNING
    Deletes a file from the File Repository. REDCap keeps it in its Recycle Bin folder
    for up to 30 days.

```julia
delete_file_from_file_repository(project; doc_id) -> nothing
```

Delete a file from the File Repository.

# Keyword arguments
- `doc_id` (required): the file's `doc_id`
"""
delete_file_from_file_repository(project::REDCapProject; doc_id) =
    api_call(:delete_file_from_file_repository, project; doc_id)
