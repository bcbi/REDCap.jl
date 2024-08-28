export delete_records,
	export_records,
	generate_next_record_name,
	import_records,
	rename_record


function delete_records(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	records::redcap_array_input, #TODO: required?
	arm::redcap_generic_input=nothing,
	instrument::redcap_generic_input=nothing,
	event::redcap_generic_input=nothing,
	repeat_instance::redcap_generic_input=nothing,
	)

	REDCap.request(
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:record),
		action=REDCap_action(:delete),
		records=records,
		arm=arm,
		instrument=instrument,
		event=event,
		repeat_instance=repeat_instance,
		)
end

#TODO: Note, an export function with a data parameter
function export_records(;
	data::redcap_data_input,
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	type::redcap_generic_input=nothing,
	records::redcap_array_input=nothing,
	fields::redcap_array_input=nothing,
	forms::redcap_array_input=nothing,
	events::redcap_array_input=nothing,
	rawOrLabel::redcap_generic_input=nothing,
	rawOrLabelHeaders::redcap_generic_input=nothing,
	exportCheckboxLabel::redcap_bool_input=false,
	returnFormat::redcap_generic_input=nothing,
	exportSurveyFields::redcap_bool_input=false,
	exportDataAccessGroups::redcap_bool_input=false,
	filterLogic::redcap_filterLogic_input=nothing,
	dateRangeBegin::redcap_timestamp_input=nothing,
	dateRangeEnd::redcap_timestamp_input=nothing,
	csvDelimiter::redcap_generic_input=nothing,
	decimalCharacter::redcap_generic_input=nothing,
	exportBlankForGrayFormStatus::redcap_bool_input=nothing
	)
	REDCap.request(
		data=REDCap_data(data,REDCap_format(format),xml_tag="records"),
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:record),
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

#TODO: this was that functino that took a data parameter with no value in data, right?
# did that change in REDCap 14?
#if data == nothing, this is an export request
function generate_next_record_name(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	)

	REDCap.request(
		#data=REDCap_data(data,REDCap_format(format),xml_tag="I have no clue"),
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:generateNextRecordName),
		)
end

#if data == nothing, this is an export request
function import_records(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
	type::redcap_generic_input=nothing,
	overwriteBehavior::redcap_bool_input=nothing,
	forceAutoNumber=nothing,
	data::redcap_data_input=nothing,
	dateFormat::redcap_generic_input=nothing,
	csvDelimiter::redcap_generic_input=nothing,
	returnContent=nothing,
)

	REDCap.request(
		data=REDCap_data(data,REDCap_format(format),xml_tag="records"),
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:record),
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

#TODO: syntax may have changed between REDCap versions
function rename_record(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	record::redcap_generic_input,
	new_record_name::redcap_generic_input,
	arm::redcap_generic_input=nothing,
	)

	REDCap.request(
		#data=REDCap_data(data,REDCap_format(format),xml_tag="deprecated?"),
		url=REDCap_url(url),
		token=REDCap_token(token),
		content=REDCap_content(:record),
		action=REDCap_action(:rename),
		record=record,
		new_record_name=new_record_name,
		arm=arm,
		)
end

