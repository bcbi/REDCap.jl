export delete_file, export_file, import_file

function delete_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,returnFormat="xml")
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="file",
		action="delete",
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function export_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,returnFormat="xml")
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="file",
		action="export",
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=assert_valid_format(returnFormat),
	)
end

function import_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,file=nothing,returnFormat="xml")
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="file",
		action="import",
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		file=file,
		returnFormat=assert_valid_format(returnFormat),
	)
end
