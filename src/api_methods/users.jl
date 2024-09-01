export export_users,
	import_users,
	delete_users

function delete_users(;
	url=get_url(),
	token=get_token(),	
	users=nothing,
	)
	REDCap.request(
	url=REDCap_url(url),
	token=REDCap_token(token),
	content=REDCap_content(:user),
	action=REDCap_action(:delete),
		users=users,
	)
end

function export_users(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:user),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_users(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	data,
	)

#=
Data Export: 0=No Access, 2=De-Identified, 3=Remove Identifier Fields, 1=Full Data Set
Form Rights: 0=No Access, 2=Read Only, 1=View records/responses and edit records (survey responses are read-only), 3=Edit survey responses
Other attribute values: 0=No Access, 1=Access.
=#
	#=
	if isa(data,Dict)
		@assert Symbol.(keys(data)) ⊆ [:username, :expiration, :data_access_group, :design, :alerts, :user_rights, :data_access_groups, :data_export, :reports, :stats_and_charts, :manage_survey_participants, :calendar, :data_import_tool, :data_comparison_tool, :logging, :file_repository, :data_quality_create, :data_quality_execute, :api_export, :api_import, :mobile_app, :mobile_app_download_data, :record_create, :record_rename, :record_delete, :lock_records_customization, :lock_records, :lock_records_all_forms, :forms, :forms_export]
		data="[$(JSON.json(data))]"
		format=:json
	end
	=#

	REDCap.request(
	url=REDCap_url(url),
	token=REDCap_token(token),
	content=REDCap_content(:user),
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="users"),
		returnFormat=REDCap_format(returnFormat),
	)
end

