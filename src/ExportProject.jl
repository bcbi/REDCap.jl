""" exportProject(config::Config; returnMetadata::Bool, records, fields, events, 
					returnFormat::String="json", exportSurveryFields::Bool, exportDataAccessGroups::Bool, 
					filterLogic::String, exportFile::Bool) 

 The entire project (all records, events, arms, instruments, fields, 
 and project attributes) can be downloaded as a single XML file, 
 which is in CDISC ODM format (ODM version 1.3.1). This XML file 
 can be used to create a clone of the project (including its data, 
 optionally) on this REDCap server or on another REDCap server 
 (it can be uploaded on the Create New Project page). Because it 
 is in CDISC ODM format, it can also be used to import the project 
 into another ODM-compatible system. NOTE: All the option paramters 
 listed below ONLY apply to data returned if the 'returnMetadataOnly' 
 parameter is set to FALSE (default). For this API method, ALL metadata 
 (all fields, forms, events, and arms) will always be exported. Only 
 the data returned can be filtered using the optional parameters.

Note about export rights: If the 'returnMetadataOnly' parameter is set 
to FALSE, then please be aware that Data Export user rights will be 
applied to any data returned from this API request. For example, if 
you have 'De-Identified' or 'Remove all tagged Identifier fields' data 
export rights, then some data fields *might* be removed and filtered 
out of the data set returned from the API. To make sure that no data is 
unnecessarily filtered out of your API request, you should have 
'Full Data Set' export rights in the project. """

function exportProject(config::Config; returnMetadata::Bool=false, records=[], fields=[], events=[], 
						returnFormat::String="json", exportSurveryFields::Bool=false, exportDataAccessGroups::Bool=false, 
						filterLogic::String="", exportFiles::Bool=false)
	
	fields = Dict("token" => config.key, 
				  "content" => "project_xml",
				  "returnMetadata" => returnMetadata,
				  "records" => records,
				  "fields" => fields,
				  "events" => events,
				  "returnFormat" => returnFormat,
				  "exportSurveryFields" => exportSurveryFields, 
				  "exportDataAccessGroups" => exportDataAccessGroups, 
				  "filterLogic" => filterLogic, 
				  "exportFile" => exportFiles) #take opt fields

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end
