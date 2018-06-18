""" exportRecord(config::Config; content::String="record", format::String="json")

Handles exporting + checking records. """

function exportRecord(config::Config; content::String="record", format::String="json")#, type::String="flat")#, records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportLabel::Bool=false, returnFormat::String="xml", exportSurveyField::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String)
	
	fields = Dict("token" => config.key, 
				  "content" => "record", 
				  "format" => "json", 
				  "type" => "flat",
				  "rawOrLabel" => "raw",
				  "rawOrLabelHeaders" => "raw",
				  "exportCheckboxLabel" => false,
				  "exportSurveyFields" => false,
				  "exportDataAccessGroups" => false,
				  "returnFormat" => "json");
	
	#output based on format passed

	#= -what it wants
	token: ADC4B222E6AC5116953F53F04960C712
	content: record
	format: json
	type: flat
	rawOrLabel: raw
	rawOrLabelHeaders: raw
	exportCheckboxLabel: false
	exportSurveyFields: false
	exportDataAccessGroups: false
	returnFormat: json
	=#
	#try/catch struct? how to record # succesful records..

	#-works, but depreciated
	print("POSTing")
	request = post(config.url; data=fields)
	#println(JSON.json(request))
	println(request)
	println(request.headers)
	println(String(request.data))
	

	#d = HTTP.request("POST", config.url; data=HTTP.escapeuri(fields))
	#println(String(d.body))
	#println()
	#println(String(d.data))
	
	#e = HTTP.request("POST", config.url, []; token=>"ADC4B222E6AC5116953F53F04960C712", content => "record", format=>"json", type=>"flat")
	#println(String(e.body))
	#println()
	#println(String(e.data))
	
	print("POSTd")
	#close(f)
	
end