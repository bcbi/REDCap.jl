export delete_records,
	export_records,
	generate_next_record_name,
	import_records,
	rename_record


function delete_records(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	records::redcap_array, #TODO: required?
	arm::redcap_generic_parameter=nothing,
	instrument::redcap_generic_parameter=nothing,
	event::redcap_generic_parameter=nothing,
	repeat_instance::redcap_generic_parameter=nothing,
	)

	REDCap.request(
		url=URI(url),
		token=REDCap_token(token),
		content=:record,
		action=:delete,
		records=records,
		arm=arm,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		)
end

function export_records(;
	data::redcap_data_parameter,
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_formatter=nothing,
	type::redcap_generic_parameter=nothing,
	records::redcap_array=nothing,
	fields::redcap_array=nothing,
	forms::redcap_array=nothing,
	events::redcap_array=nothing,
	rawOrLabel::redcap_generic_parameter=nothing,
	rawOrLabelHeaders::redcap_generic_parameter=nothing,
	exportCheckboxLabel::redcap_bool=false,
	returnFormat::redcap_generic_parameter=nothing,
	exportSurveyFields::redcap_bool=false,
	exportDataAccessGroups::redcap_bool=false,
	filterLogic::redcap_filterLogic_parameter=nothing,
	dateRangeBegin::redcap_timestamp=nothing,
	dateRangeEnd::redcap_timestamp=nothing,
	csvDelimiter::redcap_generic_parameter=nothing,
	decimalCharacter::redcap_generic_parameter=nothing,
	exportBlankForGrayFormStatus::redcap_bool=nothing
	)
	REDCap.request(
		data=data,
		url=URI(url),
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
		)
end

#if data == nothing, this is an export request
function generate_next_record_name(
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	)

	REDCap.request(
		data=data,
		url=URI(url),
		token=REDCap_token(token),
		content=:generateNextRecordName,
		)
end

#if data == nothing, this is an export request
function import_records(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_formatter=nothing,
	returnFormat::redcap_formatter=nothing,
	type::redcap_generic_parameter=nothing,
	overwriteBehavior::redcap_bool=nothing,
	forceAutoNumber=nothing,
	data::redcap_data_parameter=nothing,
	dateFormat::redcap_generic_parameter=nothing,
	csvDelimiter::redcap_generic_parameter=nothing,
	returnContent::redcap_formatter=nothing,
)

	REDCap.request(
		data=data,
		url=URI(url),
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
		)
end

function rename_record(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	record::redcap_generic_parameter,
	new_record_name::redcap_generic_parameter,
	arm::redcap_generic_parameter=nothing,
	)

	REDCap.request(
		data=data,
		url=URI(url),
		token=REDCap_token(token),
		content=:record,
		action=:rename,
		record=record,
		new_record_name=new_record_name,
		arm=arm,
		)
end

