""" importRecord(config::Config, record::Any)

Handles importing of records: 
takes the config file for api, record as a dict/array of record entering (field,val), and the content/format/type stuff after. """

function importRecord(config::Config, record::Any)
	#Verify SSL before doing a thing
	#how? 
 
	#check we didnt get json data
	
	#turn to json data
	data = JSON.json(record)
	print("JSONed")
	fields=Dict("token" => config.key,
			"content" => "record",
			"format" => "xml",
			"type" => "flat",
			"data" => data,
			"overwriteBehavior" => "normal",
			"forceAutoNumber" => false)
	
	#posting to actual site via api url and key
	#try/catch struct? how to record # succesful records..
	print("POSTing")
	println(HTTP.request("POST", config.url, collect(fields))) #sent as tuple of k=>v's
	print("POSTed")
	
	#return the count of pushed data. feed back to user "you pushed x/n records)
	fileStore="dump.txt"
	f=open(fileStore, "w")
	e=open("dumpData.txt", "w")
	#try/catch struct? how to record # succesful records..
	print("POSTing")
	d = HTTP.request("POST", config.url, collect(fields))
	print(f, d.body)
	#print(e, d.data)

	print("POSTd")
	close(f)
end
