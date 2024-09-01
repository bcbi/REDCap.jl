function create_folder(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
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
