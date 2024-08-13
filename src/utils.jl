function request(;content="",kwargs...)
	#TODO: each of the user-facing method functions should be 
	#responsible for formatting and asserting their own args
	#This function should just accept anything and everything
	#Arguments that are always present

#=
for (k,v) in kwargs
		k=String(k) #k is a Symbol, make easier to handle
		if mode=="import" && isequal(k, "data") #Turn all imported data into an IOBuffer so HTTP won't mess with it OR turn filterLogic data into a buffer because it uses []'s and REDCap can't understand URI encoding
			api_data_fields[k]=IOBuffer(v)
		elseif isa(v, Array) #Turn arrays into specially URI encoded arrays
			for (i, item) in enumerate(v)
			    api_data_fields["$k[$(i-1)]"]=String(item)
			end
		elseif isequal(k, "filterLogic") && v != ""
			api_data_fields[k]=IOBuffer(v)
		else
			api_data_fields[k]=string(v)
		end
	end
	=#
	
	body = Dict()
	body["x-forwarded-proto"] = "https"
	body["token"] = get_valid_token()
	body["content"] = content
	for (k,v) in kwargs
		if !isnothing(v)
			if isa(v, Array)
				for (i, item) in enumerate(v)
					body["$k[$(i-1)]"] = "$item"
				end
			else
				body[String(k)] = "$v"
			end
		end
	end

	return HTTP.post(
		get_valid_url();
		body=body,
		require_ssl_verification=true,
		#verbose = 3,
		status_exception=false,
	).body |> String 
	#HTTP.iserror(r)


end


"""
	import_from_file(file_loc::String, format::String)

Called by importing functions to load already formatted data directly from a designated file

#### Parameters:
* `file_loc` - Location of file
* `format` - The target format

#### Returns:
The formatted data
"""
function import_from_file(file_loc::String)
	try
		open(file_loc) do file
			return String(read(file))
		end
	catch
		@error("File could not be opened:\n$file_loc")
	end
end


"""
	export_to_file(fileLoc::String, format::String, data)

Called by exporting functions to dump data into designated file, or yell at you for a bad path.

#### Parameters:
* `file_loc` - Location of file - pass with proper extensions
* `data` - The data to save to file

#### Returns:
Nothing/error
"""
function export_to_file(file_loc::String, data)
	try
		open(file_loc, "w") do file
			write(file, data)
			return "Success"
		end
	catch
		@error("File could not be opened:\n$file_loc")
	end
end

