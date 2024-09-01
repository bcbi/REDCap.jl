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
		records=records,
		arm=arm,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
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
		type=type,
		records=records,
		forms=forms,
		events=events,
		rawOrLabel=rawOrLabel,
		rawOrLabelHeaders=rawOrLabelHeaders,
		exportCheckboxLabel=exportCheckboxLabel,
		returnFormat=REDCap_format(returnFormat),
		exportSurveyFields=exportSurveyFields,
		exportDataAccessGroups=exportDataAccessGroups,
		filterLogic=filterLogic,
		dateRangeBegin=dateRangeBegin,
		dateRangeEnd=dateRangeEnd,
		csvDelimiter=csvDelimiter,
		decimalCharacter=decimalCharacter,
		exportBlankForGrayFormStatus=exportBlankForGrayFormStatus,
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
		type=type,
		overwriteBehavior=overwriteBehavior,
		forceAutoNumber=forceAutoNumber,
		dateFormat=dateFormat,
		csvDelimiter=csvDelimiter,
		returnContent=returnContent,
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
		record=record,
		new_record_name=new_record_name,
		arm=arm,
		),
		)
end

