"""
	function create_project(; data, url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, odm=nothing,)

Create a new REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict. Availabel attributes are project_title, purpose, purpose_other, project_notes, is_longitudinal, surveys_enabled, and record_autonumbering_enabled.
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function create_project(; data, url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, odm=nothing,)
	#TODO: it might make sense to check these, but no check is done for formatted strings and file contents
	#@assert keys(data) ⊆ Set(:project_title, :purpose, :purpose_other, :project_notes, :is_longitudinal, :surveys_enabled, :record_autonumbering_enabled)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format)),#xml_tag="items")
		odm,
		kwargs = (;content=:project, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), token=REDCap_super_token(token),)
	)
end

"""
	function export_project_info(; url=get_url(), token=get_token(), format=nothing,)

Export basic attributes of a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)

"""
function export_project_info(; url=get_url(), token=get_token(), format=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; content=:project, token=REDCap_token(token), format=REDCap_format(format),),
	)
end

#TODO: should this write to a file?
"""
	function export_project_XML(; url=get_url(), token=get_token(), returnFormat=nothing, returnMetadataOnly=nothing, records=nothing, fields=nothing, events=nothing, exportSurveyFields=nothing, exportDataAccessGroups=nothing, filterLogic=nothing, exportFiles=nothing,)

Export an entire REDCap project as an XML project file, which can be used to create a new project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `returnFormat`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `records`: optionally limit output to these record names (can be scalar or vector)
- `fields`: optionally limit output to these field names (can be scalar or vector)
- `events`: optionally limit output to these unique event names (can be scalar or vector)
- `returnMetadataOnly`: optionally return metadata with no data (default is false)
- `exportSurveyFields`: optionally export survey identifier and timestamp fields (default is false)
- `exportDataAccessGroups`: optionally export `redcap_data_access_group` field (default is false)
- `exportFiles`: optionally include contents of File Upload and Signature fields (default is false)
- `filterLogic`: logic string for filtering records

"""
function export_project_XML(; url=get_url(), token=get_token(), returnFormat=nothing, returnMetadataOnly=nothing, records=nothing, fields=nothing, events=nothing, exportSurveyFields=nothing, exportDataAccessGroups=nothing, filterLogic=nothing, exportFiles=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:project_xml, returnMetadataOnly, records, fields, events, exportSurveyFields, exportDataAccessGroups, filterLogic, exportFiles, returnFormat=REDCap_format(returnFormat),),
	)
end

"""
	function import_project_info(; format=nothing, data, url=get_url(), token=get_token(),)

Import basic attributes of a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `data`: May be a String, a file name, or a data type such as NamedTuple or Dict. Availabel attributes are project_title, project_language, purpose, purpose_other, project_notes, custom_record_label, secondary_unique_field, is_longitudinal, surveys_enabled, scheduling_enabled, record_autonumbering_enabled, randomization_enabled, project_irb_number, project_grant_number, project_pi_firstname, project_pi_lastname, display_today_now_button, iand bypass_branching_erase_field_prompt.
- `format`: the format of the `data` input parameter: `:csv`, `:json`, or `:xml` (default). If `data` is a String or a file name, this value must indicate the correct format. If `data` is a NamedTuple, Dict, or similar type, this value will determine what format will be used internally to pass on the data.

"""
function import_project_info(; format=nothing, data, url=get_url(), token=get_token(),)
#TODO: not working, and there's no official API example... are we supposed to just pass this data in create_project?
	if REDCap_format(format) != REDCap_format(:csv); throw(ArgumentError("Only format=:csv is supported (possibly this is an issue with REDCap's API")) end
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format), xml_tag="items"), #TODO
	# without this xml tag, the XML is misformatted, but even with it, it isn't parse correctly... only csv works here....
		kwargs = (; token=REDCap_token(token), content=:project_settings, format=REDCap_format(format),),
	)
end

