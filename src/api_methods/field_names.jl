export export_list_of_export_field_names

function export_list_of_export_field_names(;format=:xml,field=nothing,returnFormat=nothing)
	REDCap.request(;
		content=:exportFieldNames,
		format=REDCap_format(format),
		field=field, #TODO: This could be a single entry or an array
		returnFormat=REDCap_format(returnFormat),
	)
end
