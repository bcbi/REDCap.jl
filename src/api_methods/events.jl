export delete_events,
	import_events,
	export_events

function delete_events(;events=nothing)
	REDCap.request(;
		content="event",
		action="import",
		events=events,
	)
end

function export_events(;format="xml",arms=nothing,returnFormat=nothing)
	REDCap.request(;
		content="event",
		format=format,
		arms=arms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_events(;format="xml",data=nothing,override=0,returnFormat=nothing)
	REDCap.request(;
		content="event",
		action="import",
		override=override,
		format=format,
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

