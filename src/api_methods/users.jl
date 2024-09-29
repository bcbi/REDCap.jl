"""
	function delete_users(; url=get_url(), token=get_token(), users)

Delete users from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `users`: user names (can be scalar or vector)

"""
function delete_users(; url=get_url(), token=get_token(), users)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:user, action=:delete, users,),
	)
end

"""
	function export_users(; url=get_url(), token=get_token(), format=nothing,)

Export users and user privileges for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_users(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:user, format=REDCap_format(format), ),
	)
end

"""
	function import_users(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)

Import users and user privileges to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict. Available attributes are username, expiration, data_access_group, design, alerts, user_rights, data_access_groups, data_export, reports, stats_and_charts, manage_survey_participants, calendar, data_import_tool, data_comparison_tool, logging, email_logging, file_repository, data_quality_create, data_quality_execute, api_export, api_import, api_modules, mobile_app, mobile_app_download_data, record_create, record_rename, record_delete, lock_records_customization, lock_records, lock_records_all_forms, forms, and forms_export.
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_users(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)
	REDCap.request(
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="users"),
		kwargs = (; token=REDCap_token(token), content=:user, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

