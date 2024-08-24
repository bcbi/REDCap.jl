export create_folder,
	delete_file_from_file_repository,
	export_file_from_file_repository,
	export_list_of_folders,
	import_file_from_file_repository

function create_folder(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
		name=nothing,
folder_id=nothing,
dag_id=nothing,
role_id=nothing,
)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:fileRepository),
		       action=REDCap_action(:createFolder),
		name=name,
		format=REDCap_format(format),
		folder_id=folder_id,
		dag_id=dag_id,
		role_id=role_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function delete_file_from_file_repository(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
		name=nothing,
doc_id=nothing,
)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:fileRepository),
		       action=REDCap_action(:delete),
		doc_id=doc_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_file_from_file_repository(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
		name=nothing,
doc_id=nothing,
)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:fileRepository),
		       action=REDCap_action(:export),
		doc_id=doc_id,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_list_of_folders(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
		name=nothing,
folder_id=nothing,
)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:fileRepository),
		       action=REDCap_action(:list),
		name=name,
		format=REDCap_format(format),
		folder_id=folder_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_file_from_file_repository(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
		name=nothing,
file=nothing,
folder_id=nothing,
)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
		       content=REDCap_content(:fileRepository),
		       action=REDCap_action(:import),
		file=file,
		folder_id=folder_id,
		returnFormat=REDCap_format(returnFormat),
	)
end
