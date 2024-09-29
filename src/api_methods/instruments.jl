"""
	function export_instrument_event_mappings(; url=get_url(), token=get_token(), format=nothing, , arms=nothing,)

Export mappings of data collection instruments onto designated Events for a longitudinal REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `arms`: study arms from which to pull events (all are inclued by default)

"""
function export_instrument_event_mappings(; url=get_url(), token=get_token(), format=nothing, , arms=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:formEventMapping, format=REDCap_format(format), arms, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_instruments(; url=get_url(), token=get_token(), format=nothing,)

Export Instruments (Data Entry Forms)

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_instruments(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:instrument, format=REDCap_format(format),),
	)
end

"""
	function export_PDF(; url=get_url(), token=get_token(), format=nothing, record=nothing, event=nothing, instrument=nothing, repeat_instance=nothing, allRecords=nothing, compactDisplay=nothing,)

Export PDF of Data Collection Instruments

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record: record ID (default is a PDF with no data)
- `event`: unique event name for a longitudinal project
- `instrument`: unique instrument name
- `repeat_instance`: repeat instance number for projects with repeating instruments/events
- `allRecords`: if passed with any value, all records are exported
- `compactDisplay`: if true, excludes empty fields and unselected options (default is false)

"""
function export_PDF(; url=get_url(), token=get_token(), format=nothing, record=nothing, event=nothing, instrument=nothing, repeat_instance=nothing, allRecords=nothing, compactDisplay=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:pdf, record, event, instrument, repeat_instance, allRecords, compactDisplay, format=REDCap_format(format),),
	)
end

"""
	function import_instrument_event_mappings(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)

Import mappings of data collection instruments onto designated Events for a longitudinal REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function import_instrument_event_mappings(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, data,)
	#TODO: Here and throughout, enforce that this function cannot 
	#behave like an export, since the API calls are similar
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:formEventMapping, format=REDCap_format(format), data=REDCap_data(data,REDCap_format(format),xml_tag="items"), returnFormat=REDCap_format(returnFormat),),
	)
end
