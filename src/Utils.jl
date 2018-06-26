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
	#=
	if mode=="import"
		#input validation: send as a wrapped object-
		if get(fields, "format", "x")!="x"
			if	fields["format"]=="json"
				println("Jason!")
				fieldsMod = JSON.json(fields)
			elseif fields["format"]=="xml"
				#xml
				println("xml")


			elseif fields["format"]=="csv"
				#csv - BROKEN AF
				println("csv")


			else
				#odm
				println("odm")


			end
			response = poster(config, fieldsMod)
		else
			response = poster(config, fields)
		end
	else
		response = poster(config, fields)
	end
	=#
	response = poster(config, fields)
	

	#handle formatting here?
	output = String(response.body) 
	
	#check for return format
	if mode=="export"
		if get(fields, "format", "x")!="x"
			if	fields["format"]=="json"
				println("Jason!")
				try
					outputMod = JSON.parse(output)
					return outputMod
				catch
					return output
				end
			elseif fields["format"]=="xml"
				#xml
				println("xml")
				try
					outputMod = JSON.parse(string(output))
					return outputMod
				catch
					return output
				end
			elseif fields["format"]=="csv"
				#csv - BROKEN AF
				println("csv")
				try
					outputMod = CSV.read(IOBuffer(String(output)))
					return outputMod
				catch
					return output
				end
			else
				#odm
				println("odm")
				try

					return outputMod
				catch
					return output
				end
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