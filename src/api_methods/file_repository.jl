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
		kwargs = (;
		token=REDCap_token(token),
		       content=:fileRepository,
		       action=:createFolder,
		name,
		format=REDCap_format(format),
		folder_id,
		dag_id,
		role_id,
		returnFormat=REDCap_format(returnFormat),
		),
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
		kwargs = (;
		token=REDCap_token(token),
		       content=:fileRepository,
		       action=:delete,
		doc_id,
		returnFormat=REDCap_format(returnFormat),
		),
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
		kwargs = (;
		token=REDCap_token(token),
		       content=:fileRepository,
		       action=:export,
		doc_id,
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		),
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
		kwargs = (;
		token=REDCap_token(token),
		       content=:fileRepository,
		       action=:list,
		name,
		format=REDCap_format(format),
		folder_id,
		returnFormat=REDCap_format(returnFormat),
		),
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
		kwargs = (;
		token=REDCap_token(token),
		       content=:fileRepository,
		       action=:import,
		file,
		folder_id,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end
