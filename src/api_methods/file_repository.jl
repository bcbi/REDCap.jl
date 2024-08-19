export create_folder,
	delete_file_from_file_repository,
	export_file_from_file_repository,
	export_list_of_folders,
	import_file_from_file_repository

function create_folder(;name=nothing,format=:xml,folder_id=nothing,dag_id=nothing,role_id=nothing,returnFormat=:xml)
	REDCap.request(;
		content=:fileRepository,
		action=:createFolder,
		name=name,
		format=REDCap_format(format),
		folder_id=folder_id,
		dag_id=dag_id,
		role_id=role_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function delete_file_from_file_repository(;name=nothing,format=:xml,doc_id=nothing,returnFormat=:xml)
	REDCap.request(;
		content=:fileRepository,
		action=:delete,
		doc_id=doc_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_file_from_file_repository(;name=nothing,format=:xml,doc_id=nothing,returnFormat=:xml)
	REDCap.request(;
		content=:fileRepository,
		action=:export,
		doc_id=doc_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function export_list_of_folders(;name=nothing,format=:xml,folder_id=nothing,returnFormat=:xml)
	REDCap.request(;
		content=:fileRepository,
		action=:list,
		name=name,
		format=REDCap_format(format),
		folder_id=folder_id,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_file_from_file_repository(;name=nothing,format=:xml,file=nothing,folder_id=nothing,returnFormat=:xml)
	REDCap.request(;
		content=:fileRepository,
		action=:import,
		file=file,
		folder_id=folder_id,
		returnFormat=REDCap_format(returnFormat),
	)
end
