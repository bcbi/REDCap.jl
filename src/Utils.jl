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
	fields = Dict()
	fields["token"] = config.key; fields["action"] = mode; fields["content"] = content
	for arg in kwargs
		fields[string(arg[1])] = arg[2]
	end
	response = poster(config, fields)

	output = String(response.body) 
	
	#check for return format
	if mode=="export"
		if get(fields, "format", "x")!="x"
			if	fields["format"]=="json"
				println("Jason!")
				return json_formatter(output, mode)

			elseif fields["format"]=="xml"
				#xml
				println("xml")
				return xml_formatter(output, mode)

			elseif fields["format"]=="csv"
				#csv - BROKEN AF
				println("csv")
				return csv_formatter(output, mode)	

			else
				#odm
				println("odm")
				return odm_formatter(output, mode)	

			end
		end
	end
	#print out errors here
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
	return HTTP.post(config.url; body=body)
end


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
	create_project(config::SuperConfig, format::String="json", data; 
					returnFormat::String="json", odm="NULL")

Parameters:
config::SuperConfig - struct containing url and super-api-key
format::String - "json", "xml", "csv", or "odm". declares format of imported data
data - dict of attributes of project to create- only project_title and purpose are required (* for default)
	-project_title: title
	-purpose: must be numerical (0 - test, 1 - other, 2 - research, 3 - Qual+, 4 - OpSupport)
	-purpose_other: if purpose 1- string of purpose
	-project_notes: notes
	-is_longitudinal: 0 - false*, 1 - true
	-surveys_enabled: 0 - false*, 1 - true
	-record_autonumbering_enabled: 0 - false, 1 - true*
returnFormat::String - error message format
odm - XML string containing metadata

Returns:
The standard api key
"""

function create_project(config::SuperConfig, data; format::String="json",
						returnFormat::String="json", odm="NULL")
	fields = Dict("token" => config.key,
					"content" => "project",
					"format" => format,
					"data" => data,
					"returnFormat" => returnFormat,
					"odm" => odm)
	output = HTTP.post(config.url; body=fields)
	return String(output.body)
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
		#must turn a dict into json

		return JSON.json(data)
	else
		#must turn json into a dict
		try
			return JSON.parse(data)
		catch
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
			return data
		end
	else
		#must turn csv into dict/df
		try
			formattedData = Dict()
			CSV.read(IOBuffer(String(data)), formattedData)
			return formattedData
		catch
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
		return data
	else
		#must turn xml into dict
		try
			xDoc = XMLDocument()
			return xDoc = parse_string(string(data))
		catch
			return data
		end
	end
end


"""
	odm_formatter(data, mode::String)

Parameters:
data - the data to be formatted
mode::String - formatting for Import (data to server) or Export (data from server)

Returns:
the opposite of what was given in relation to odm format
"""

function odm_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into odm
		return data
	else
		#must turn odm into a dict
		try

		catch
			return data
		end
	end
end