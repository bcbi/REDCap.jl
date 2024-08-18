export delete_events,
	import_events,
	export_events

function delete_events(;events=nothing)
	REDCap.request(;
		content=:event,
		action=:import,
		events=events,
	)
end

function export_events(;format=:xml,arms=nothing,returnFormat=nothing)
	REDCap.request(;
		content=:event,
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_events(;format=:xml,data=nothing,override=0,returnFormat=nothing)
	REDCap.request(;
		content=:event,
		action=:import,
		override=override,
		format=REDCap_format(format),
		data=data,
		returnFormat=REDCap_format(returnFormat),
	)
end

