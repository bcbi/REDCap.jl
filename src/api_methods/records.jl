function delete_records(;
	url=get_url(),
	token=get_token(),	
	records, #TODO: required?
	arm=nothing,
	instrument=nothing,
	event=nothing,
	repeat_instance=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:record,
		action=:delete,
		records,
		arm,
		instrument,
		event,
		repeat_instance,
		),
		)
end

function export_records(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	type=nothing,
	records=nothing,
	fields=nothing,
	forms=nothing,
	events=nothing,
	rawOrLabel=nothing,
	rawOrLabelHeaders=nothing,
	exportCheckboxLabel=false,
	returnFormat=nothing,
	exportSurveyFields=false,
	exportDataAccessGroups=false,
	filterLogic=nothing,
	dateRangeBegin=nothing,
	dateRangeEnd=nothing,
	csvDelimiter=nothing,
	decimalCharacter=nothing,
	exportBlankForGrayFormStatus=nothing
	)
	REDCap.request(
		data=REDCap_data(data,REDCap_format(format),xml_tag="records"),
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:record,
		format=REDCap_format(format), #allows odm, unlike most other format args
		type,
		records,
		forms,
		events,
		rawOrLabel,
		rawOrLabelHeaders,
		exportCheckboxLabel,
		returnFormat=REDCap_format(returnFormat),
		exportSurveyFields,
		exportDataAccessGroups,
		filterLogic,
		dateRangeBegin,
		dateRangeEnd,
		csvDelimiter,
		decimalCharacter,
		exportBlankForGrayFormStatus,
		),
		)
end

function generate_next_record_name(;
	url=get_url(),
	token=get_token(),	
	)

	REDCap.request(
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:generateNextRecordName,
		),
		)
end

#if data == nothing, this is an export request
function import_records(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	type=nothing,
	overwriteBehavior=nothing,
	forceAutoNumber=nothing,
	backgroundProcess=nothing,
	data,
	dateFormat=nothing,
	csvDelimiter=nothing,
	returnContent=nothing,
)

	REDCap.request(
		data=REDCap_data(data,REDCap_format(format),xml_tag="records"),
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:record,
		format=REDCap_format(format), #allows odm, unlike most other format args
		type,
		overwriteBehavior,
		forceAutoNumber,
		dateFormat,
		csvDelimiter,
		returnContent,
		returnFormat=REDCap_format(returnFormat),
		),
		)
end

function rename_record(;
	url=get_url(),
	token=get_token(),	
	record,
	new_record_name,
	arm=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
		content=:record,
		action=:rename,
		record,
		new_record_name,
		arm,
		),
		)
end

