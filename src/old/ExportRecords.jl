""" exportRecords(config::Config; format::String="json", dtype::String="flat", 
					records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String)

This method allows you to export a set of records for a project.

Note about export rights: Please be aware that Data Export 
user rights will be applied to this API request. For example, 
if you have 'No Access' data export rights in the project, then 
the API data export will fail and return an error. And if 
you have 'De-Identified' or 'Remove all tagged Identifier 
fields' data export rights, then some data fields *might* 
be removed and filtered out of the data set returned from 
the API. To make sure that no data is unnecessarily filtered 
out of your API request, you should have 'Full Data Set' 
export rights in the project."""

function exportRecords(config::Config; format::String="json", dtype::String="flat", 
					records=[], fields=[], forms=[], events=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
					exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
					exportDataAccessGroups::Bool=false, filterLogic::String="")
	
	fields = Dict("token" => config.key, 
				  "content" => "record", 
				  "format" => format, 
				  "type" => dtype,
				  "records" => records,
				  "fields" => fields,
				  "forms" => forms,
				  "events" => events,
				  "rawOrLabel" => rawOrLabel,
				  "rawOrLabelHeaders" => rawOrLabelHeaders,
				  "exportCheckboxLabel" => exportCheckboxLabel,
				  "exportSurveyFields" => exportSurveyField,
				  "exportDataAccessGroups" => exportDataAccessGroups,
				  "returnFormat" => returnFormat,
				  "filterLogic" => filterLogic);
	
	#output based on format passed

	#try/catch struct? how to record # succesful records..
	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	println(format)
	if format=="json"
		return JSON.parse(String(output.body); dicttype=DataStructures.OrderedDict)
	elseif format=="csv"
		return CSV.read(IOBuffer(String(output.body)))
		#return String(output.body)
	elseif format=="odm"
		#odm stuff =LOW PRI=
	elseif format=="xml"
		return parse_string(String(output.body))
	else
		print("Invalid format passed: must be json, csv, xml, or odm format")
	end
end
