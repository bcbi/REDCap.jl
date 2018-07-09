#handling ssl- place up top as a global var, create a function that calls and modifies it? 
##Poster just look at that to decide how to act?

"""
	api_pusher(mode::String, content::String, config::Config; kwargs...)

Pass the type of api call, the config struct, and any needed kwargs for that api call 
API documentation found here:
https://<your-redcap-site.com>/redcap/api/help/?content=exp_field_names

##Parameters:
* `mode` - "import", "export", or "delete"
* `content` - Passed by calling modules to indicate what data to access
* `config` - struct containing url and api-key
* `kwargs...` - Any addtl. arguments passed by the calling module

##Returns:
Formatted response body
"""

function api_pusher(mode::String, content::String, config::Config; to_file::Bool=false, kwargs...)
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
	for (k,v) in kwargs
		#type is reserved in julia, quick-fix
		if isequal(String(k), "dtype")
			fields["type"] = v
		elseif isequal(String(v), "df")
			fields["format"] = "csv" #Pass as the closest thing
		else
			fields[String(k)] = v
		end
	end
	#println(fields)
	#POST request and get response
	response = poster(config, fields)
	output = String(response.body) 
	
	#check if user wanted to save the file here -

	#check for return format
	if mode=="export" && haskey(fields, "format") && to_file==false #handle this differently? to_file is weird...
		return formatter(output, fields["format"], mode)
	elseif mode=="import" && haskey(fields, "format") && to_file==false
		#handle input feedback/errors
		return formatter(output, fields["format"], "export") #treat returns from imports as exports
	else
		#delete
	end
	#horribly messy- make work gud
	return output
end


"""
	poster(config::Config, body)

Handles the POST duties for all modules.

##Parameters:
* `config` - struct containing url and api-key
* `body` - request body data

##Returns:
Anything the server returns; data or error messages.
"""

function poster(config::Config, body)
	println("POSTing")
	response = HTTP.post(config.url; body=body, require_ssl_verification=true)
	println("POSTd")
	return response
	#handle errors way more robustly- check for "error" field? here or back at api_pusher?
end


#MOVE OUT? Can be considered a Utility, is required by importing if you do not specifiy record id and need it.
#Make get_next_record_id and place in export? It's basically an export function.
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

##Parameters:
* `data` - the data to be formatted
* `format` - the target format
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
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
	elseif format=="df"
		#special dataframe case- handles dataframe objects specifically, separate from CSV (but totally used with CSV, neat right?)
		#Note: df is not a REDCap type, will pass an error or the default (JSON)
	else
		println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
	end
end


"""
	json_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
the opposite of what was given in relation to json format
"""

function json_formatter(data, mode::String)
	if mode=="import"
		#must turn a dict into json
		#MASSIVE HEAT-SINK OF FAILURE - Next 4 functions
		#=
		println(typeof(JSON.json(data))); println("Returned")
		test[1]=JSON.json(data)
		println(typeof(test)); println(typeof(test[1])); println(test[1])
		return test[1]
		=#
		return JSON.json(data) #Different method of JSON.? JSON.print?
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

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
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

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
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
	df_formatter(data, mode::String)

##Parameters:
* `data` - the data to be formatted
* `mode` - formatting for Import (data to server) or Export (data from server)

##Returns:
the opposite of what was given in relation to df format
"""

function df_formatter(data, mode::String)
	if mode=="import"
		#must turn dict into a dataframe
		return data
	else
		#must turn dataframe into a dict
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

Called by importing functions to load data directly from a designated file

##Parameters:
* `file_loc`: location of file
* `format`: the target format

##Returns:
The formatted data
"""
function import_from_file(file_loc::String, format::String)
	#take from file
	#verify file exists
	try
		open(file_loc) do file
			if format=="json"
				return JSON.json(read(file))
			elseif format=="csv"
				output=CSV.read(file) #comes out a df- cant be sent as df...
				return output
			elseif format=="xml"
				return parse_file(file) #xml
			elseif format=="odm"
				return #odm
			elseif format=="df"
				#handle the elusive last format- df. NOTE- df is not a supported format, and will probably pass to REDCap as
				#	an error, or bounce back default format (JSON), so play around with how to pass it to the API
			else
				println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
			end
		end
	catch
		println("File could not be read:\n$file_loc")
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
	#handle validation and import validation - if not already passing formatted data, format - else leave alone and pass
	#take the data as the file-location?
	#loading from file - eg take csv file, open it, throw into a buffer(?), pass to import func. 
	#rely on user to check if format works?
	if isa(data, String) && ispath(data)
		return import_from_file(data, format)
	else
		return formatter(data, format, "import")
	end
end


"""
	export_to_file(fileLoc::String, format::String, data)

Called by exporting functions to dump data into designated file

##Parameters:
* `file_loc`: location of file
* `format`: the target format ###may not be needed!
* `data`: the data to save to file

##Returns:
nothing/error
"""

function export_to_file(file_loc::String, format::String, data)
	try
		open(file_loc, "w") do file
			if format=="json"
				#save to file - json - is there a more JSONy way to do this?
				writelm(file, data)
			elseif format=="csv"
				#save to file - csv
				write(file, data)
			elseif format=="xml"
				#save to file - xml
				write(file, data)
			elseif format=="odm"
				#save to file - odm
			elseif format=="df"
				#you must know the drill. 
			else
				println("$format is an invalid format.\nValid formats: \"json\", \"csv\", \"xml\", \"odm\", or \"df\"")
			end
		end
	catch
		println("File could not be read:\n$file_loc")
	end
end

function import_file()
	#handles file importing - non specific
	#grab a file, return as data object?
end