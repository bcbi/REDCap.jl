""" importRecords(config::Config, record::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false)

This method allows you to import a set of records for a project """
###############NOT IMPLEMENTED/BROKEN###############
function importRecords(config::Config, record::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false)
	#Verify SSL before doing a thing
	#how? 
 	data=[]
	#check we didnt get json data-make it json
	print(typeof(record)) #record is a string coming in- need json obj
	#turn to json data
	data = JSON.json(record)
	print("JSONed"); println(data); println(typeof(data))
	#push!(data, record)
	#print(data)
	#=
	push!(data, record)
	Any["{\"sex\":\"1\",\"age\":\"39\",\"address\":\"123 Fake St. Providence RI 02895\",
	\"height\":\"172.96\",\"dob\":\"1978-07-08\",\"record_id\":\"1\",\"bmi\":\"26.7\",
	\"comments\":\"\",\"email\":\"JohnSmith78@gmail.com\",\"first_name\":\"John\",
	\"demographics_complete\":\"2\",\"telephone\":\"(401) 888-9956\",\"weight\":\"80\",
	\"last_name\":\"Smith\",\"ethnicity\":\"2\",\"race\":\"4\"}"]
	=#
	#= record as is:
	{"sex":"1","age":"39","address":"123 Fake St. Providence RI 02895","height":"172.96",
	"dob":"1978-07-08","record_id":"1","bmi":"26.7","comments":"","email":"JohnSmith78@gmail.com",
	"first_name":"John","demographics_complete":"2","telephone":"(401) 888-9956","weight":"80",
	"last_name":"Smith","ethnicity":"2","race":"4"}
	=#

	#=
	data=[""]; data[1] = record
	String["{\"sex\":\"1\",\"age\":\"39\",\"address\":\"123 Fake St. Providence RI 02895\",
	\"height\":\"172.96\",\"dob\":\"1978-07-08\",\"record_id\":\"1\",\"bmi\":\"26.7\",
	\"comments\":\"\",\"email\":\"JohnSmith78@gmail.com\",\"first_name\":\"John\",
	\"demographics_complete\":\"2\",\"telephone\":\"(401) 888-9956\",\"weight\":\"80\",
	\"last_name\":\"Smith\",\"ethnicity\":\"2\",\"race\":\"4\"}"]
	=#
	
	fields=Dict("token" => config.key,
				"content" => "record",
				"format" => format,
				"type" => dtype,
				"data" => data,
				"overwriteBehavior" => overwriteBehavior,
				"forceAutoNumber" => forceNumber)
	#=-what its getting -an array of json data
	[
		{"sex":"1","age":"39","address":"123 Fake St. Providence RI 02895",
			"height":"172.96","dob":"1978-07-08","record_id":3,
			"bmi":"26.7","comments":"","email":"JohnSmith78@gmail.com",
			"first_name":"colby","demographics_complete":"2","telephone":"(401) 888-9956",
			"weight":"80","last_name":"Smith","ethnicity":"2","race":"4"},
		{"sex":"1","age":"25","address":"335 Harrington Ave. Warwick RI 02888",
			"height":"187.96","dob":"1992-12-14","record_id":4,"bmi":"28",
			"comments":"self","email":"Cory_Cothrum@brown.edu","first_name":"mark",
			"demographics_complete":"1","telephone":"(401) 338-8369",
			"weight":"99","last_name":"Cothrum","ethnicity":"1","race":"4"}
	]
	=#

	#posting to actual site via api url and key
	#try/catch struct? how to record # succesful records..
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
