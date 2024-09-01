#TODO: this format can include odm
function export_reports(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, fields=nothing, report_id=nothing, rawOrLabel=nothing, rawOrLabelHeaders=nothing, exportCheckboxLabel=nothing, csvDelimiter=nothing, decimalCharacter=nothing,)
	REDCap.request(
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:report, report_id, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat), rawOrLabel, rawOrLabelHeaders, exportCheckboxLabel, csvDelimiter, decimalCharacter,),
	)
end
