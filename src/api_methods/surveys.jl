"""
	function export_survey_link(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)

Export a participant's survey link for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: the record name
- `instrument`: the instrument's name (must be enabled as a survey)
- `event`: the unique event name (longitudinal projects only)
- `repeat_instance`: the repeat instance of the event or instrument (default is 1)

"""
function export_survey_link(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:surveyLink, record, instrument, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_survey_participants(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)

Export a list of survey participants

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `instrument`: the instrument's name (must be enabled as a survey)
- `event`: the unique event name (longitudinal projects only)

"""
function export_survey_participants(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:participantList, instrument, event, repeat_instance, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_survey_queue_link(;record=nothing,returnFormat=nothing)

Export a participant's survey queue link

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: the record name

"""
function export_survey_queue_link(;record=nothing,returnFormat=nothing)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:surveyQueueLink, record, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function export_survey_link(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)

Export a participant's survey return code

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `record`: the record name
- `instrument`: the instrument's name (must be enabled as a survey)
- `event`: the unique event name (longitudinal projects only)
- `repeat_instance`: the repeat instance of the event or instrument (default is 1)

"""
function export_survey_return_code(; url=get_url(), token=get_token(), returnFormat=nothing, record=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:surveyLink, record, instrument, event, repeat_instance, returnFormat=REDCap_format(returnFormat),),
	)
end


