export export_reports

function export_reports(;report_id=nothing,format="xml",returnFormat=nothing,rawOrLabel="raw",rawOrLabelHeaders="raw",exportCheckboxLabel=false,csvDelimiter=',',decimalCharacter=".")
	REDCap.request(
		url=get_valid_url(),
		token=get_valid_token(),
		content="report",
		report_id=report_id,
		format=format, # format can include odm
		returnFormat=assert_valid_format(format),
		rawOrLabel=rawOrLabel,
		rawOrLabelHeaders=rawOrLabelHeaders,
		exportCheckboxLabel=exportCheckboxLabel,
		csvDelimiter=csvDelimiter,
		decimalCharacter=decimalCharacter,
	)
end
