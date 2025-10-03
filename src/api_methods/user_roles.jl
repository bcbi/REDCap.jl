#TODO: 3.0 consider removing user from user role in function names
##TODO: OTOH, that would be yet another "R" name
"""
	function delete_user_roles(; url=get_url(), token=get_token(), roles,)

Delete roles from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `roles`: unique role names (can be scalar or vector)

"""
function delete_user_roles(; url=get_url(), token=get_token(), roles,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:userRole, action=:delete, roles,),
	)
end

"""
	function export_user_role_assignments(; url=get_url(), token=get_token(), format=nothing, )

Export role assignments from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_user_role_assignments(; url=get_url(), token=get_token(), format=nothing, )
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:userRoleMapping, format=REDCap_format(format), ),
	)
end

"""
	function export_user_roles(; url=get_url(), token=get_token(), format=nothing,)

Export roles from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_user_roles(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:userRole, format=REDCap_format(format),),
	)
end

"""
	function import_user_role_assignments(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)

Import role assignments to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict. Available attributes are `user_name`, `unique_role_name`, and `data_access_group`.
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_user_role_assignments(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)
	REDCap.request(
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="items"),
		kwargs = (; token=REDCap_token(token), content=:userRoleMapping, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

#TODO: for both import functions (?), You have to clear the unique_role_name column to import the roles you've exported from another project
"""
	function import_user_roles(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,

Import roles to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict. Available attributes are `unique_role_name`, `role_label`, `design`, `alerts`, `user_rights`, `data_access_groups`, `reports`, `stats_and_charts`, `manage_survey_participants`, `calendar`, `data_import_tool`, `data_comparison_tool`, `logging`, `email_logging`, `file_repository`, `data_quality_create`, `data_quality_execute`, `api_export`, `api_import`, `api_modules`, `mobile_app`, `mobile_app_download_data`, `record_create`, `record_rename`, `record_delete`, `lock_records_customization`, `lock_records`, `lock_records_all_forms`, `forms`, and `forms_export`.
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_user_roles(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,
	)
	REDCap.request(
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="users"),
		kwargs = (; token=REDCap_token(token), content=:userRole, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

