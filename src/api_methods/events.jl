export delete_events,
	import_events,
	export_events

function delete_events(;events=nothing)
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="event",
		action="import",
		events=events,
	)
end

function export_events(;format="xml",arms=nothing,returnFormat=nothing)
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="event",
		format=assert_valid_format(format),
		arms=arms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_events(;format="xml",data=nothing,override=0,returnFormat=nothing)
	request(;
		url=get_valid_url(),
		token=get_valid_token(),
		content="event",
		action="import",
		override=override,
		format=assert_valid_format(format),
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

