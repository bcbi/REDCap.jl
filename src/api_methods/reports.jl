export export_reports

function export_reports(;
	report_id=nothing,
	format=nothing,
	returnFormat=nothing,
	rawOrLabel=nothing,
	rawOrLabelHeaders=nothing,
	exportCheckboxLabel=nothing,
	csvDelimiter=nothing,
	decimalCharacter=nothing,
	)

	REDCap.request(
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
