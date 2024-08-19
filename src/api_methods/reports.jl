export export_reports

function export_reports(;report_id=nothing,format=:xml,returnFormat=nothing,rawOrLabel="raw",rawOrLabelHeaders="raw",exportCheckboxLabel=false,csvDelimiter=',',decimalCharacter=".")
	REDCap.request(
		content=:report,
		report_id=report_id,
		format=REDCap_format(format), # format can include odm
		returnFormat=REDCap_format(returnFormat),
		rawOrLabel=rawOrLabel,
		rawOrLabelHeaders=rawOrLabelHeaders,
		exportCheckboxLabel=exportCheckboxLabel,
		csvDelimiter=csvDelimiter,
		decimalCharacter=decimalCharacter,
	)
end
