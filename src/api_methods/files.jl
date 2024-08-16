export delete_file, export_file, import_file

function delete_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,returnFormat="xml")
	REDCap.request(;
		content="file",
		action=:delete,
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=returnFormat,
	)
end

function export_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,returnFormat="xml")
	REDCap.request(;
		content="file",
		action=:export,
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		returnFormat=returnFormat,
	)
end

function import_file(;record=nothing,field=nothing,event=nothing,repeat_instance=nothing,file=nothing,returnFormat="xml")
	REDCap.request(;
		content="file",
		action=:import,
		record=record,
		field=field,
		event=event,
		repeat_instance=repeat_instance,
		file=file,
		returnFormat=returnFormat,
	)
end
