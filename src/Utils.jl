"""
	api_pusher(mode::String, content::String, config::Config; kwargs...)

Pass the type of api call, the config struct, and any needed kwargs for that api call 
API documentation found here:
https://<your-redcap-site.com>/redcap/api/help/?content=exp_field_names

Parameters:
mode::String - "import", "export", or "delete"
content::String - Passed by calling modules to indicate what data to access
config::Config - struct containing url and api-key
kwargs...: Any addtl. arguments passed by the calling module

Returns:
Formatted response body
"""

function api_pusher(mode::String, content::String, config::Config; kwargs...)
	#initialize dict with basic info and api calls
	fields = Dict()
	fields["token"] = config.key
	fields["action"] = mode
	fields["content"] = content

	#validation here? Everyone passes through here...
	#validate via kwarg? eg if match, check for value validation
	#import validation?
	#export validation?

	#fill dict with passed kwargs
	for arg in kwargs
		#type is reserved in julia, quick-fix
		if string(arg[1])=="dtype"
			fields["type"]=arg[2]
		else
			fields[string(arg[1])] = arg[2]
		end
	end
	
	#POST request and get response
	response = poster(config, fields)
	println("POSTd")
	output = String(response.body) 
	
	#check if user wanted to save the file here -

	#check for return format
	if mode=="export" && haskey(fields, "format")
		return formatter(output, fields["format"], mode)
	else
		#handle input/delete number returns
		return output
	end
	#horribly messy- make work gud
	return output
end


"""
	poster(config::Config, body)

Handles the POST duties for all modules.

Parameters:
config::Config - struct containing url and api-key
body - request body data

Returns:
Anything the server returns; data or error messages.
"""

function poster(config::Config, body)
	println("POSTing")
	response = HTTP.post(config.url; body=body, require_ssl_verification=true)
	return response
	#handle errors way more robustly
end


#MOVE OUT
"""
	generate_next_record_id(config::Config) 

Parameters:
config::Config - struct containing url and api-key

Returns:
The next available ID number for project
"""

function generate_next_record_id(config::Config)
	fields = Dict("token" => config.key, 
				  "content" => "generateNextRecordName")
	output = HTTP.post(config.url; body=fields)
	return parse(Integer, String(output.body)) #return as integer
end


"""
	formatter(data, format, mode::String)

Parameters:
data - the data to be formatted
format - the target format
mode::String - formatting for Import (data to server) or Export (data from server)

Returns:
the specified formatted/unformatted object
"""

function formatter(data, format, mode::String) #flag to save to file?
	println(typeof(data))
	if format=="json"
		json_formatter(data, mode)
	elseif format=="csv"
		csv_formatter(data, mode)
	elseif format=="xml"
		xml_formatter(data, mode)
	elseif format=="odm"
		odm_formatter(data, mode)
	else
		println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\" or \"odm\"")
	end
end


"""
	json_formatter(data, mode::String)

Parameters:
data - the data to be formatted
mode::String - formatting for Import (data to server) or Export (data from server)

Returns:
the opposite of what was given in relation to json format
"""

function json_formatter(data, mode::String)
	if mode=="import"
		test = [""]
		#must turn a dict into json
		#MASSIVE HEAT-SINK OF FAILURE - Next 4 functions
		#=
		println(typeof(JSON.json(data))); println("Returned")
		test[1]=JSON.json(data)
		println(typeof(test)); println(typeof(test[1])); println(test[1])
		return test[1]
		=#
		return JSON.json(data)
	else
		#must turn json into a dict
		try
			return JSON.parse(data)
		catch
			println("Catch")
			return data #for things that arent dicts
		end

	end
end


"""
	csv_formatter(data, mode::String)

Parameters:
data - the data to be formatted
mode::String - formatting for Import (data to server) or Export (data from server)

Returns:
the opposite of what was given in relation to csv format
"""

function csv_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into csv
		try
			formattedData = IOBuffer()
			return CSV.write(formattedData, data)
		catch
			println("Catch")
			return data
		end
	else
		#must turn csv into dict/df
		try
			#bad, broken
			formattedData = Dict()
			CSV.read(IOBuffer(String(data)), formattedData)
			return formattedData
		catch
			println("Catch")
			return data
		end
	end
end


"""
	xml_formatter(data, mode::String)

Parameters:
data - the data to be formatted
mode::String - formatting for Import (data to server) or Export (data from server)

Returns:
the opposite of what was given in relation to xml format
"""

function xml_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into xml
		#do i need to make this?
		xDoc = XMLDocument()
		return xDoc = parse_string(string(data))
	else
		#must turn xml into dict
		try
			#data is an xml
			#println(data); #println(typeof(data))
			return data
		catch
			println("Catch")
			return data
		end
	end
end


"""
	odm_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
the opposite of what was given in relation to odm format
"""

function odm_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into odm
		return data
	else
		#must turn odm into a dict
		try
			1==2
		catch
			println("Catch")
			return data
		end
	end
end

"""
	import_from_file(fileLoc::String, format::String)

Desc.

##Parameters:


##Returns:

"""
function import_from_file(fileLoc::String, format::String)
	if format=="json"
		return #json
	elseif format=="csv"
		return CSV.read(fileLoc)
	elseif format=="xml"
		return #xml
	elseif format=="odm"
		return #odm
	else
		println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\" or \"odm\"")
	end
end


"""
"""

function export_to_file(fileLoc::String, format::String)
	if format=="json"
		#save to file - json
	elseif format=="csv"
		#save to file - csv
	elseif format=="xml"
		#save to file - xml
	elseif format=="odm"
		#save to file - odm
	else
		println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\" or \"odm\"")
	end
end