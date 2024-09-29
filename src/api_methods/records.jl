#TODO: add functino to delete all records

#TODO: is records required
"""
	function delete_records(; url=get_url(), token=get_token(), records, arm=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)

Delete records from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `records`: record names (can be scalar or vector)
- `arm`: optionlly limit deletions to this arm number
- `instrument`: optionlly limit deletions to this unique instrument name
- `event`: optionlly limit deletions to this unique event name (required for longitudinal projects, otherwise unavailable)
- `repeat_instance`: optionlly limit deletions to this repeating instrument or event
- `delete_logging`: if true, delete logging activity for deleted record (default is false)

"""
function delete_records(; url=get_url(), token=get_token(), records, arm=nothing, instrument=nothing, event=nothing, repeat_instance=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:record, action=:delete, records, arm, instrument, event, repeat_instance,),
		)
end

#TODO: There's some sort of field that just holds text, or ther fields, or something like that
#TODO: if you try to pull it, there will be no error, but it wn't exist in the output
#TODO: this format parameter allows odm, unlike most other format args
# The REDCap_listlike turns an input like [:a, :b, :c] into "a, b, c"
# TODO: what other parameters need this sort of treatment?
"""
	function export_records(; url=get_url(), token=get_token(), format=nothing, type=nothing, records=nothing, fields=nothing, forms=nothing, events=nothing, rawOrLabel=nothing, rawOrLabelHeaders=nothing, exportCheckboxLabel=nothing, returnFormat=nothing, exportSurveyFields=nothing, exportDataAccessGroups=nothing, filterLogic=nothing, dateRangeBegin=nothing, dateRangeEnd=nothing, csvDelimiter=nothing, decimalCharacter=nothing, exportBlankForGrayFormStatus=nothing)

Export records from a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, `:xml` (default), or `:odm`
- `type`: `:flat` (default) or `:eav`
- `records`: optionally limit exports to specific records (can be scalar or vector)
- `fields`: optionally limit exports to specific field names (can be scalar or vector)
- `forms`: optionally limit exports to specific form names (can be scalar or vector)
- `events`: (longitudinal projects only) optionally limit exports to specific unique event names (can be scalar or vector)
- `rawOrLabel`: `:raw` (default, export raw coded values) or `:label` (export labels)
- `rawOrLabelHeaders`: (for `:flat` type, `:csv` format only) raw or label CSV headers
- `exportCheckboxLabel`: toggle format of checkbox field values (false by default)
- `exportSurveyFields`: optionally export survey identifier and timestamp fields (false by default)
- `exportDataAccessGroups`: optionally export the "redcap_data_access_group" field (false by default)
- `filterLogic` : optionally filter records based on a logic string
- `dateRangeBegin`: optionally limit output to records created or modified after a given datetime
- `dateRangeEnd`: optionally limit output to records created or modified before a given datetime
- `csvDelimiter`: ',' (default), 'tab', ';', '|', or '^'
- `decimalCharacter`: enforce ',' or '.'  format (empty by default)
- `exportBlankForGrayFormStatus`: optionally export blank values for instrument complete status fields with a gray status icon

"""
function export_records(; url=get_url(), token=get_token(), format=nothing, type=nothing, records=nothing, fields=nothing, forms=nothing, events=nothing, rawOrLabel=nothing, rawOrLabelHeaders=nothing, exportCheckboxLabel=nothing, returnFormat=nothing, exportSurveyFields=nothing, exportDataAccessGroups=nothing, filterLogic=nothing, dateRangeBegin=nothing, dateRangeEnd=nothing, csvDelimiter=nothing, decimalCharacter=nothing, exportBlankForGrayFormStatus=nothing)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:record, format=REDCap_format(format), type, records, fields, forms, events, rawOrLabel, rawOrLabelHeaders, exportCheckboxLabel, returnFormat=REDCap_format(returnFormat), exportSurveyFields, exportDataAccessGroups, filterLogic, dateRangeBegin, dateRangeEnd, csvDelimiter, decimalCharacter, exportBlankForGrayFormStatus,),
		)
end

"""
	function generate_next_record_name(; url=get_url(), token=get_token(),)

Generate the next record name

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)

"""
function generate_next_record_name(; url=get_url(), token=get_token(),)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:generateNextRecordName,),
		)
end

"""
	function import_records(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, type=nothing, overwriteBehavior=nothing, forceAutoNumber=nothing, backgroundProcess=nothing, data, dateFormat=nothing, csvDelimiter=nothing, returnContent=nothing,)

Import records to a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, `:xml` (default), or `:odm`
- `type`: `:flat` (default) or `:eav`
- `overwriteBehavior`: overwrite data with blank values (by default, these are ignored)
- `forceAutoNumber`: optionally determine record numbers automatically (these must be provided by default)
- `backgroundProcess`: set to true for large uploads
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `dateFormat`: `:MDY`, `:DMY`, or `:YMD` (default)
- `csvDelimiter`: ',' (default), 'tab', ';', '|', or '^'
- `returnContent`: sets the return value (`:count` (default, `:lds`, or `:auto_lds`)

"""
#TODO: this format parameter allows odm, unlike most other format args
function import_records(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, type=nothing, overwriteBehavior=nothing, forceAutoNumber=nothing, backgroundProcess=nothing, data, dateFormat=nothing, csvDelimiter=nothing, returnContent=nothing,)
	REDCap.request(
		data=REDCap_data(data,REDCap_format(format),xml_tag="records"),
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:record, format=REDCap_format(format), type, overwriteBehavior, forceAutoNumber, dateFormat, csvDelimiter, returnContent, returnFormat=REDCap_format(returnFormat),),
		)
end

"""
	function rename_record(; url=get_url(), token=get_token(), record, new_record_name, arm=nothing,)

Rename a record

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `record`: current record name
- `new_record_name`: new record name
- `arm`: optionally limit renaming to this arm number

"""
function rename_record(; url=get_url(), token=get_token(), record, new_record_name, arm=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:record, action=:rename, record, new_record_name, arm,),
		)
end

