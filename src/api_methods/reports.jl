#TODO: this format can include odm
"""
	function export_reports(; url=get_url(), token=get_token(), report_id, format=nothing, returnFormat=nothing, fields=nothing, rawOrLabel=nothing, rawOrLabelHeaders=nothing, exportCheckboxLabel=nothing, csvDelimiter=nothing, decimalCharacter=nothing,)

Export a report's data set for a REDCap project

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)
- `report_id`: the report ID number
- `format`: the desired output format: `:csv`, `:json`, `:xml` (default), or `:odm`
- `rawOrLabel`: `:raw` (default, export raw coded values) or `:label` (export labels)
- `rawOrLabelHeaders`: (for `:flat` type, `:csv` format only) raw or label CSV headers
- `exportCheckboxLabel`: toggle format of checkbox field values (false by default)
- `csvDelimiter`: ',' (default), 'tab', ';', '|', or '^'
- `decimalCharacter`: enforce ',' or '.'  format (empty by default)

"""
function export_reports(; url=get_url(), token=get_token(), report_id, format=nothing, returnFormat=nothing, fields=nothing, rawOrLabel=nothing, rawOrLabelHeaders=nothing, exportCheckboxLabel=nothing, csvDelimiter=nothing, decimalCharacter=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:report, report_id, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), rawOrLabel, rawOrLabelHeaders, exportCheckboxLabel, csvDelimiter, decimalCharacter,),
	)
end
