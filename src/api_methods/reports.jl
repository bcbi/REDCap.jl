export export_reports

function export_reports(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	fields::redcap_array=nothing,
	report_id=nothing,
	rawOrLabel=nothing,
	rawOrLabelHeaders=nothing,
	exportCheckboxLabel=nothing,
	csvDelimiter=nothing,
	decimalCharacter=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:report),
		report_id=report_id,
		format=REDCap_format(format), #TODO: format can include odm
		returnFormat=REDCap_format(returnFormat),
		rawOrLabel=rawOrLabel,
		rawOrLabelHeaders=rawOrLabelHeaders,
		exportCheckboxLabel=exportCheckboxLabel,
		csvDelimiter=csvDelimiter,
		decimalCharacter=decimalCharacter,
	)
end
