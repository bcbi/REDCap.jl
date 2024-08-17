export export_users,
	import_users,
	delete_users

function delete_users(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	users::redcap_array=nothing,
	)
	REDCap.request(
	       url=URI(url),
	       token=assert_valid(:token,token),
		content=:user,
		action=:delete,
		users=users,
	)
end

function export_users(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=assert_valid(:token,token),
		content=:user,
		format=format,
		returnFormat=returnFormat,
	)
end

function import_users(;
	url::redcap_url_parameter=get_url(),
	token::REDCap_token=get_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	data::redcap_data_parameter,
	)

	if isa(data,Dict)
		@assert keys(data) ⊆ [:username, :expiration, :data_access_group, :design, :alerts, :user_rights, :data_access_groups, :data_export, :reports, :stats_and_charts, :manage_survey_participants, :calendar, :data_import_tool, :data_comparison_tool, :logging, :file_repository, :data_quality_create, :data_quality_execute, :api_export, :api_import, :mobile_app, :mobile_app_download_data, :record_create, :record_rename, :record_delete, :lock_records_customization, :lock_records, :lock_records_all_forms, :forms, :forms_export]
		data="[$(JSON.json(data))]"
		format=:json
	end

	REDCap.request(
	       url=URI(url),
	       token=assert_valid(:token,token),
		content=:user,
		format=format,
		data=data,
		returnFormat=returnFormat,
	)
end

