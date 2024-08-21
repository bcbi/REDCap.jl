export export_users,
	import_users,
	delete_users

function delete_users(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	users::redcap_array=nothing,
	)
	REDCap.request(
	url=URI(url),
	token=REDCap_token(token),
	content=REDCap_content(:user),
		action=:delete,
		users=users,
	)
end

function export_users(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		content=REDCap_content(:user),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_users(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	data::redcap_data_parameter,
	)

	if isa(data,Dict)
		@assert Symbol.(keys(data)) ⊆ [:username, :expiration, :data_access_group, :design, :alerts, :user_rights, :data_access_groups, :data_export, :reports, :stats_and_charts, :manage_survey_participants, :calendar, :data_import_tool, :data_comparison_tool, :logging, :file_repository, :data_quality_create, :data_quality_execute, :api_export, :api_import, :mobile_app, :mobile_app_download_data, :record_create, :record_rename, :record_delete, :lock_records_customization, :lock_records, :lock_records_all_forms, :forms, :forms_export]
		data="[$(JSON.json(data))]"
		format=:json
	end

	REDCap.request(
	url=URI(url),
	token=REDCap_token(token),
	content=REDCap_content(:user),
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

