#handling ssl- place up top as a global var, create a function that calls and modifies it? 
#have poster just look at that to decide how to act?

#=
###HTTP CODE###
function Form(d::Dict)
    boundary = compat_string(rand(UInt128), base=16)
    data = IO[]
    io = IOBuffer()
    len = length(d)
    for (i, (k, v)) in enumerate(d)
        write(io, (i == 1 ? "" : "\r\n") * "--" * boundary * "\r\n")
        write(io, "Content-Disposition: form-data; name=\"$k\"")
        if isa(v, IO)
            writemultipartheader(io, v)
            seekstart(io)
            push!(data, io)
            push!(data, v)
            io = IOBuffer()
        else
            write(io, "\r\n\r\n")
            write(io, escapeuri(v))
            println("What it is given:\n$v\nWhat it gives:")
            println(escapeuri(v))
        end
        i == len && write(io, "\r\n--" * boundary * "--" * "\r\n")
    end
    seekstart(io)
    push!(data, io)
    return Form(data, 1, boundary)
end
=#

"""
	api_pusher(mode::String, content::String, config::Config; kwargs...)

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
	fields["content"] = content #what to access

	#validation here? Everyone passes through here...
	#not the file vs data validation happening at the base of all imports; thats too specific due to passing keywords
	#dont want to have to do a whole dict of just validating data to the right keyword.
	#validate via kwarg? eg if match, check for value validation
	#import validation?
	#export validation?
	#fill dict with passed kwargs - function?
	#println(kwargs)
	for (k,v) in kwargs
		if isequal(String(k), "format")
			println(v)
			format = v
			if isequal(v, "df")
				#Pass as the closest thing to api, but handle internally as df
				fields["format"]="csv"
			else
				fields["format"]=v
			end
		elseif isequal(String(k), "dtype") #type is reserved in julia, quick-fix
			fields["type"] = v
		#elseif isequal(String(k), "data")
		#	data = IOBuffer()
		#	write(data, v)
		#	println(data)
		#	fields["data"] = data
		else
			fields[String(k)] = v
		end
	end
	#println("Fields:")
	#println(fields)
	#for (k,v) in fields
	#	print(HTTP.escapeuri(v))
	#end

	#POST request and get response
	response = poster(config, fields)
	output = String(response.body)

	#check if user wanted to save the file here -
	to_file = (length(file_loc)>1 ? true : false)
	#check for return format 
	if mode=="export" && haskey(fields, "format") 
		if to_file==false
			println("outputting")
			return formatter(output, fields["format"], mode)
		else
			#exporting to file
			println("to file")
			export_to_file(file_loc, output)
		end
	elseif mode=="import" && haskey(fields, "format")
		#handle input feedback/errors
		return formatter(output, fields["format"], "export") #treat returns from imports as exports
	else
		#delete - this is a simple little report of how many things you deleted if anything -
		#doesnt even take a format, so treat 'im like a JSON, or whatever is easier, and format it out simple like
		#low priority
	end
	#horribly messy- make work gud
	return output
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
	response = HTTP.post(config.url; body=body, require_ssl_verification=true, verbose=3)
	#NEW WAY
	#HTTP.open("POST", config.url) do io
	#	write(io, JSON.json(body))
	#	startread(io)
	#end
	println("POSTd")
	#or is this an apropo place for a try/catch?
	if response.status>=400
		#Error - handle errors way more robustly- check for "error" field? here or back at api_pusher?
		#an error is an error is an error, so it throws no matter what...
		println(response.status)

	else
		return response
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
	output = poster(config, fields)
	return parse(Integer, String(output.body)) #return as integer
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
		df_formatter(data, mode)
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
		#must turn a dict/data structure into json
		return JSON.json(data)
	else
		#must turn json into a dict
		try
			return JSON.parse(data) 
		catch
			println("Catch - data cannot be json formatted")
			return data #for things that arent dicts
		end

	end
end

		#MASSIVE HEAT-SINK OF FAILURE#


"""
	csv_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
The opposite of what was given in relation to csv format
"""
###BROKEN###
function csv_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into csv
		try
			formattedData = IOBuffer()
			return CSV.write(formattedData, data, missingstring=" ")
		catch
			println("Catch")
			return data
		end
	else
		#must turn csv into dict/df
		try
			println(data)
			return df_formatter(data, mode)
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
###BROKEN###
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
			return df_formatter(data, mode)
		catch
			println("Catch - data cannot be xml formatted")
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
The opposite of what was given in relation to odm format
"""
###BROKEN###
function odm_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into odm
		return data
	else
		#must turn odm into a dict
		try
			return data
		catch
			println("Catch - data cannot be odm formatted")
			return data
		end
	end
end


"""
	df_scrubber(data)

Tries to remove missing values from a df but cant actually.....
"""
function df_scrubber(data)
	for row in 1:size(data)[1]
		for col in 1:size(data)[2]
			println(typeof(data[row, col]))
	    	if isequal(typeof(data[row,col]), Missings.Missing)
	        	data[row,col]=" "
	        end
	    end
	end
	return data
end


"""
	df_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted

##Returns:
A JSON of the given data to send to the API
"""
###BROKEN###
function df_formatter(data, mode::String)
	target = df_formatter(data)
	try
		if mode=="import"
			return target
		else
			return target
		end
	catch
		println("Catch - data cannot be df formatted")
		return data
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
		#DF => Dict
		#data = df_scrubber(data)
		chartDict=[]
		for row in DataFrames.eachrow(data)
			rowDict=Dict()
			for item in row
				rowDict[String(item[1])]=string(item[2])
			end
			push!(chartDict,rowDict)
		end
		return chartDict
	else
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
###(half)BROKEN###
function import_from_file(file_loc::String, format::String)
	#take from file
	#verify file exists
	#try
		open(file_loc) do file
			#Leave separate now just in case, but plan to simplify this
			if format=="json"
				return String(read(file))
			elseif format=="csv" || format=="df"
				#output=String(read(file)) #comes out a df- cant be sent as df...
				#println(typeof(output))
				return String(read(file))
			elseif format=="xml"
				 #xml
				 return String(read(file))
			elseif format=="odm"
				return #odm
			else
				error("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
			end
		end
	#catch
	#	error("File could not be read:\n$file_loc")
	#end
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
	#handle validation and import validation - if not already passing formatted data, format - else leave alone and pass
	#take the data as the file-location?
	#loading from file - eg take csv file, open it, throw into a buffer(?), pass to import func. 
	#rely on user to check if format works?
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