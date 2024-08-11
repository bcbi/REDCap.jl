export delete_events
	import_events,
	export_events,

delete_events(events::Array; kwargs...) = redcap_api(action="delete", content="event", config, events=events)
export_events(; kwargs...) = redcap_api(; content="event", kwargs...)
import_events(data; kwargs...) = redcap_api(action="import", content="event", data=data; kwargs...)
