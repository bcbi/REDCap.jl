#handling ssl- place up top as a global var, create a function that calls and modifies it? 
#have poster just look at that to decide how to act?
"""
	api_pusher(mode::String, content::String, config::Config; file_loc::String="", kwargs...)

Pass the type of api call, the config struct, and any needed kwargs for that api call.
Handles creation of the Dict of fields to pass to REDCap, and file IO/formatting. 

API documentation found here:
https://<your-redcap-site.com>/redcap/api/help/?content=exp_field_names

##Parameters:
* `mode` - "import", "export", or "delete"
* `content` - Passed by calling modules to indicate what data to access
* `config` - struct containing url and api-key
* `file_loc`: location of file
* `kwargs...` - Any addtl. arguments passed by the calling module

##Returns:
Formatted response body
"""
function api_pusher(mode::String, content::String, config::Config; file_loc::String="", kwargs...)
	#initialize dict with basic info and api calls
	fields = Dict()
	fields["token"] = config.key
	fields["action"] = mode #import, export, delete
	fields["content"] = content #what API function to access

	for (k,v) in kwargs
		if isequal(String(k), "format")
			format=v
			if isequal(v, "df")
				#Pass as the closest thing to api, but handle internally as df
				fields["format"]="csv"
			else
				fields["format"]=v
			end
		elseif isequal(String(k), "dtype") #type is reserved in julia, quick-fix
			fields["type"]=v
		elseif isequal(mode, "import") && isequal(String(k), "data") #check if its one of those oddly named import fields
			#println("DING")
			fields[String(k)]=IOBuffer(v)
		elseif isa(v, Array)
			for (i, item) in enumerate(v)
			    fields["$(String(k))[$(i-1)]"]=String(item)
			end
		else
			fields[String(k)]=v
		end
	end

	#POST request and get response
	response = poster(config, fields)

	#check if user wanted to save the file here - set flag
	to_file = (length(file_loc)>1 ? true : false)
	#check for return format 
	if mode=="export" && haskey(fields, "format") 
		if to_file==false
			#println("outputting")
			return formatter(response, fields["format"], mode)
		else
			#exporting to file
			#println("to file")
			export_to_file(file_loc, response)
			return formatter(response, fields["format"], mode)
		end
	elseif mode=="import" && haskey(fields, "format")
		#handle input feedback/errors
		return formatter(response, fields["format"], "export") #treat returns from imports as exports?
	else
		#delete - this is a simple little report of how many things you deleted if anything -
		return response
	end
end


"""
	poster(config::Config, body)

Handles the POST duties for all modules. Also does basic Status checking and SSL verification.

##Parameters:
* `config` - struct containing url and api-key
* `body` - request body data

##Returns:
Anything the server returns; data or error messages.
"""
function poster(config::Config, body)
	println("POSTing")
	response = HTTP.post(config.url; body=body, require_ssl_verification=true)#, verbose=3)
	println("POSTd")
	if response.status != 200
		#Error - handle errors way more robustly- check for "error" field? here or back at api_pusher?
		#an error is an error is an error, so it throws no matter what...
		println(response.status)
	else
		return String(response.body)
	end
end


"""
	generate_next_record_id(config::Config) 

##Parameters:
* `config` - struct containing url and api-key

##Returns:
The next available ID number for project
"""

function generate_next_record_id(config::Config)
	fields = Dict("token" => config.key, 
				  "content" => "generateNextRecordName")
	return parse(Int8, poster(config, fields)) #return as integer
end


"""
	formatter(data, format, mode::String)

Takes data and sends out to the proper formating function.

##Parameters:
* `data` - the data to be formatted
* `format` - the target format
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The specified formatted/unformatted object
"""

function formatter(data, format, mode::String) #flag to save to file?
	#println(typeof(data))
	if format=="json"
		json_formatter(data, mode)
	elseif format=="csv"
		csv_formatter(data, mode)
	elseif format=="xml"
		xml_formatter(data, mode)
	elseif format=="odm"
		odm_formatter(data, mode)
	elseif format=="df"
		#Special solution
		df_formatter(data)
	else
		error("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
	end
end


"""
	json_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The opposite of what was given in relation to json format
"""

function json_formatter(data, mode::String)
	if mode=="import"
		return JSON.json(data)
	else
		try
			return JSON.parse(data) 
		catch
			println("Catch - data cannot be json formatted")
			return data #for things that arent dicts - a surprising amount of REDCap's output
		end
	end
end


"""
	csv_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The opposite of what was given in relation to csv format
"""
###BROKEN(?)###
function csv_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into csv
		try
			formattedData = IOBuffer()
			return CSV.write(formattedData, data)
		catch
			println("Catch - data cannot be csv formatted")
			return data
		end
	else
		#must turn recieved csv into dict? df?
		try
			return CSV.read(IOBuffer(data))
		catch
			println("Catch - data cannot be csv formatted")
			return data
		end
	end
end


"""
	xml_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The opposite of what was given in relation to xml format
"""
###BROKEN(?)###
function xml_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into xml
		#do i need to make this?
		xDoc = XMLDocument()
		return xDoc = parse_string(string(data))
	else
		#must turn xml into dict-array
		try
			output=[]
			for record in collect(child_elements(root(data)))
				data = Dict()
				for item in child_elements(record)
					data[name(item)]=content(item)
				end
				push!(output, data)
			end
			return data
		catch
			println("Catch - data cannot be xml formatted")
			return data
		end
	end
end


"""
	odm_formatter(data, mode::String)

May just be XML in disguise
##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The opposite of what was given in relation to odm format
"""
###BROKEN###
function odm_formatter(data, mode::String)
	if mode=="import"
		#dict => odm
		return data
	else
		#odm => dict
		try
			return data
		catch
			println("Catch - data cannot be odm formatted")
			return data
		end
	end
end


"""
	df_formatter(data::Union{DataFrame, Dict})

Takes a DF/Dict, turns it into a Dict/DF

Parameters:
* `data` - data to be formatted

Returns:
The opposite of the diven format.
"""
function df_formatter(data::Union{DataFrame, Array})
	if isequal(typeof(data), DataFrame)
		#df => dict
		chartDict=[]
		for row in DataFrames.eachrow(data)
			rowDict=Dict()
			for item in row
				if !isa(item[2], Missings.Missing)
					rowDict[String(item[1])]=string(item[2])
				else
					rowDict[String(item[1])]="NA"
				end
			end
			push!(chartDict,rowDict)
		end
		return chartDict
	else
		#dict => df
		chartDF=DataFrames.DataFrame(String, length(data), length(data[1]))
		keylist=[]
		for key in keys(data[1])
			push!(keylist,key)
		end
		rename!(chartDF, f=>t for (f,t)=zip(names(chartDF), Symbol.(keylist)))
		i=1
		for row in data
			println(row)
			for (k, v) in row
				chartDF[i:i, k] = v
			end
			i+=1
		end
		return df_scrubber(chartDF)
	end
end


"""
	import_from_file(fileLoc::String, format::String)

Called by importing functions to load already formatted data directly from a designated file

##Parameters:
* `file_loc`: location of file
* `format`: the target format

##Returns:
The formatted data
"""
function import_from_file(file_loc::String, format::String)
	valid_formats = ("json","csv","xml","df","odm") #redcap accepted formats (also df)
	try
		open(file_loc) do file
			if format ∈ valid_formats
				return String(read(file))
			else
				error("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
			end
		end
	catch
		error("File could not be read:\n$file_loc")
	end
end


"""
	import_file_checker()

Checks if the passed data is a valid path to a file, or data in itself. 
If a path, calls a loading function; if data, calls a formatter.

##Parametes:
* `data` - The data to check
* `format` - the format to pass along

##Returns:
The retreived/formatted data
"""
function import_file_checker(data, format::String)
	if length(data)<70 && isa(data, String) && ispath(data)
		return import_from_file(data, format)
	else
		return formatter(data, format, "import")
	end
end


"""
	export_to_file(fileLoc::String, format::String, data)

Called by exporting functions to dump data into designated file, or yell at you for a bad path.

##Parameters:
* `file_loc`: location of file - pass with proper extensions
* `data`: the data to save to file

##Returns:
Nothing/error
"""
function export_to_file(file_loc::String, data)
	try
		open(file_loc, "w") do file
			write(file, data)
		end
	catch
		error("File could not be read:\n$file_loc")
	end
end