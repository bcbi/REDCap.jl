#TODO: for 3.0, simplify a lot of these names
##TODO: check if these should have format and returnFormat, and make docstrings consistent
"""
	function delete_DAGs(; url=get_url(), token=get_token(), dags)

Create a New Folder in the File Repository

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `name`: name of the new folder (150 characters maximum)
- `folder_id`: folder_id of the intended parent directory (default is top-level directory in File Repository)
- `dag_id`: optionally restrict folder access to a Data Access Group
- `role_id`: optionally restrict folder access to a User Role

"""
function create_folder(; url=get_url(), token=get_token(), name, folder_id=nothing, dag_id=nothing, role_id=nothing, format=nothing, returnFormat=nothing, )
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:fileRepository, action=:createFolder, name, format=REDCap_format(format), folder_id, dag_id, role_id, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function delete_file_from_file_repository(; url=get_url(), token=get_token(), doc_id,)

Delete a File from the File Repository

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `doc_id`: the file's doc_id

"""
function delete_file_from_file_repository(; url=get_url(), token=get_token(), doc_id,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:fileRepository, action=:delete, doc_id, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_file_from_file_repository(; url=get_url(), token=get_token(), doc_id=nothing,

Export a File from the File Repository

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `doc_id`: the file's doc_id

"""
function export_file_from_file_repository(; url=get_url(), token=get_token(), doc_id=nothing,
)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:fileRepository, action=:export, doc_id, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_list_of_folders(; url=get_url(), token=get_token(), folder_id=nothing,)

Export a list of files for all subfolders

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `folder_id`: folder_id of intended folder (default is the top-level directory of the File Repository)

"""
function export_list_of_folders(; url=get_url(), token=get_token(), folder_id=nothing, format=nothing)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:fileRepository, action=:list, name, format=REDCap_format(format), folder_id, returnFormat=REDCap_format(returnFormat),),
	)
end
export_folders = export_list_of_folders

#TODO: this name is just incorrect...
"""
function import_file_from_file_repository(; url=get_url(), token=get_token(), format=nothing, file, folder_id=nothing,)

Export a list of files for all subfolders
function import_file_from_file_repository(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, name=nothing, file=nothing, folder_id=nothing,)

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `file`: contents of the new file
- `folder_id`: folder_id of intended folder (default is the top-level directory of the File Repository)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_file_from_file_repository(; url=get_url(), token=get_token(), format=nothing, file, folder_id=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:fileRepository, action=:import, file, folder_id, returnFormat=REDCap_format(returnFormat),),
	)
end
