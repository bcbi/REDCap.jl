""" importRecords(config::Config, record::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false)

This method allows you to import a set of records for a project """
###############NOT IMPLEMENTED/BROKEN###############
function importRecords(config::Config, record::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false)
	#Verify SSL before doing a thing
	#how? 
	data=IOBuffer
	println(format)
	if format=="json"
		println("Record is: ")
		print(typeof(record)) #record is a string coming in- need json obj
		#turn to json data
		data = JSON.json(record)
		print("JSONed"); println(data); println(typeof(data))
	elseif format=="csv"
		#csv output- still to json though?
		CSV.write(data, record)
	elseif format=="odm"
		#odm stuff =LOW PRI=
	elseif format=="xml"
	else
		print("Invalid format passed: must be json, csv, xml, or odm format")
	end

	
		
	fields=Dict("token" => config.key,
				"content" => "record",
				"format" => format,
				"type" => dtype,
				"data" => data,
				"overwriteBehavior" => overwriteBehavior,
				"forceAutoNumber" => forceNumber)
	
	print("POSTing")
	request = HTTP.post(config.url; body=fields) #sent as tuple of k=>v's
	print("POSTd")
	print(String(request.body))
	
	#return the count of pushed data. feed back to user "you pushed x/n records)
	return String(request.body)
end

#=
ERROR: HTTP.ExceptionRequest.StatusError(400, HTTP.Messages.Response:
"""
HTTP/1.1 400 Bad Request
Date: Tue, 19 Jun 2018 19:39:30 GMT
Server: Apache/2.4.6 (Red Hat Enterprise Linux)
X-Powered-By: PHP/5.4.16
Expires: 0
cache-control: no-store, no-cache, must-revalidate
Pragma: no-cache
Access-Control-Allow-Origin: *
REDCap-Random-Text: s6pjw8PKSaDRWwyvgBxjFECdc5yRPjYMaMMMZjTQjkXxDE8FesMz9aKuiRo
Content-Length: 153
Connection: close
Content-Type: application/json; charset=utf-8

{"error":"The data being imported is not formatted correctly. PHP error from JSON decoder: Syntax error. 
The JSON must be in an array, as in [{ ... }]."}""")
=#