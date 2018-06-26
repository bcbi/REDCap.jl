""" exportReports(config::Config, report_id::Int; returnFormat::String="json", format::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false) 

This method allows you to export the data set of a report created 
on a project's 'Data Exports, Reports, and Stats' page.

Note about export rights: Please be aware that Data Export user 
rights will be applied to this API request. For example, if you 
have 'No Access' data export rights in the project, then the API 
report export will fail and return an error. And if you have 'De-Identified' 
or 'Remove all tagged Identifier fields' data export rights, 
then some data fields *might* be removed and filtered out of the 
data set returned from the API. To make sure that no data is 
unnecessarily filtered out of your API request, you should have 
'Full Data Set' export rights in the project.

Also, please note the the 'Export Reports' method does *not* 
make use of the 'type' (flat/eav) parameter, which can be used in the 
'Export Records' method. All data for the 'Export Reports' method 
is thus exported in flat format. If the 'type' parameter is supplied 
in the API request, it will be ignored. """

function exportReports(config::Config, report_id::Int; returnFormat::String="json", format::String="json", 
						rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false)
	
	fields = Dict("token" => config.key, 
				  "content" => "report", 
				  "format" => format,
				  "report_id" => report_id,
				  "returnFormat" => returnFormat,
				  "rawOrLabel" => rawOrLabel, 
				  "rawOrLabelHeaders" => rawOrLabelHeaders, 
				  "exportCheckboxLabel" => exportCheckboxLabel)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
