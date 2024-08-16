export delete_records,
	export_records,
	generate_next_record_name,
	import_records,
	rename_record


function delete_records(;format="xml",records=nothing,arm=nothing,instrument=nothing,event=nothing,repeat_instance=nothing)
	REDCap.request(
		content="record",
		action=:delete,
		records=records,
		arm=arm,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		)
end

function export_records(;format="xml",type="flat",records=nothing,fields=nothing,forms=nothing,events=nothing,rawOrLabel="raw",rawOrLabelHeaders="raw",exportCheckboxLabel=false,returnFormat=nothing,exportSurveyFields=false,exportDataAccessGroups=false,filterLogic=nothing,dateRangeBegin=nothing,dateRangeEnd=nothing,csvDelimiter=",",decimalCharacter=".",exportBlankForGrayFormStatus=false)
	REDCap.request(
		content="record",
		format=format, #allows odm, unlike most other format args
		type=type,
		records=records,
		forms=forms,
		events=events,
		rawOrLabel=rawOrLabel,
		rawOrLabelHeaders=rawOrLabelHeaders,
		exportCheckboxLabel=exportCheckboxLabel,
		returnFormat=returnFormat,
		exportSurveyFields=exportSurveyFields,
		exportDataAccessGroups=exportDataAccessGroups,
		filterLogic=filterLogic,
		dateRangeBegin=dateRangeBegin,
		dateRangeEnd=dateRangeEnd,
		csvDelimiter=csvDelimiter,
		decimalCharacter=decimalCharacter,
		exportBlankForGrayFormStatus=exportBlankForGrayFormStatus,
		)
end

#if data == nothing, this is an export request
function generate_next_record_name()
	REDCap.request(
		content="generateNextRecordName",
		)
end

#if data == nothing, this is an export request
function import_records(;format="xml",type="flat",overwriteBehavior="normal",forceAutoNumber=false,data=nothing,dateFormat=nothing,csvDelimiter=",",returnContent="count",returnFormat=nothing)
	REDCap.request(
		content="record",
		format=format, #allows odm, unlike most other format args
		type=type,
		overwriteBehavior=overwriteBehavior,
		forceAutoNumber=forceAutoNumber,
		data=data,
		dateFormat=dateFormat,
		csvDelimiter=csvDelimiter,
		returnContent=returnContent,
		returnFormat=returnFormat,
		)
end

function rename_record(;record=nothing,new_record_name=nothing,arm=nothing)
	REDCap.request(
		content="record",
		action=:rename,
		record=record,
		new_record_name=new_record_name,
		arm=arm,
		)
end

