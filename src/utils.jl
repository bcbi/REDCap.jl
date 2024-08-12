export redcap_api

function redcap_api(;
	#Arguments that are always present
	token="",
	url="",
	content="",
	format="",
	returnFormat="",

	#Arguments that are often absent
	action=nothing,
	dag=nothing,
	dag_id=nothing,
	doc_id=nothing,
	data=nothing,
	event=nothing,
	field=nothing,
	fields=nothing,
	file=nothing,
	folder_id=nothing,
	forms=nothing,
	instrument=nothing,
	logtype=nothing,
	name=nothing,
	override=nothing,
	record=nothing,
	repeat_instance=nothing,
	role_id=nothing,
	compactDisplay=nothing,
	user=nothing,
	beginTime=nothing,
	endTime=nothing,

	# Arrays
	arms=nothing,
	dags=nothing,
	events=nothing,

	# Value is ignored, but passing the parameter has an effect
	allRecords=nothing,
	
)

	api_data_fields = Dict("token" => token,
		"content" => content,
		"format" => format,
		"returnFormat" => returnFormat,
	)
	if(!isnothing(action))		
		api_data_fields["action"] = action
	end
	if(!isnothing(data))		
		api_data_fields["data"] = String(data)
	end
	if(!isnothing(fields))
		api_data_fields["fields"] = String(fields)
	end
	if(!isnothing(fields))		
		api_data_fields["fields"] = String(fields)
	end
	if(!isnothing(forms))		
		api_data_fields["forms"] = String(forms)
	end
	if(!isnothing(override))		
		api_data_fields["override"] = "$override"
	end
	if(!isnothing(dag))		
		api_data_fields["dag"] = String(dag)
	end
	if(!isnothing(event))		
		api_data_fields["event"] = String(event)
	end
	if(!isnothing(repeat_instance))		
		api_data_fields["repeat_instance"] = "$repeat_instance"
	end
	if(!isnothing(file))		
		api_data_fields["file"] = String(file)
	end
	if(!isnothing(name))		
		api_data_fields["name"] = String(name)
	end
	if(!isnothing(doc_id))		
		api_data_fields["doc_id"] = String(doc_id)
	end
	if(!isnothing(dag_id))		
		api_data_fields["dag_id"] = String(dag_id)
	end
	if(!isnothing(folder_id))		
		api_data_fields["folder_id"] = String(folder_id)
	end
	if(!isnothing(role_id))		
		api_data_fields["role_id"] = String(role_id)
	end
	if(!isnothing(compactDisplay))		
		api_data_fields["compactDisplay"] = String(compactDisplay)
	end
	if(!isnothing(instrument))		
		api_data_fields["instrument"] = String(instrument)
	end
	if(!isnothing(logtype))		
		api_data_fields["logtype"] = String(logtype)
	end
	if(!isnothing(user))		
		api_data_fields["user"] = String(user)
	end
	if(!isnothing(beginTime))		
		api_data_fields["beginTime"] = String(beginTime)
	end
	if(!isnothing(endTime))		
		api_data_fields["endTime"] = String(endTime)
	end

	# Value doesn't matter
	if(!isnothing(allRecords))		
		api_data_fields["allRecords"] = ""
	end

	if(!isnothing(arms))		
		for (i, item) in enumerate(arms)
			api_data_fields["arms[$(i-1)]"]=String(item)
		end
	end
	if(!isnothing(dags))		
		for (i, item) in enumerate(dags)
			api_data_fields["dags[$(i-1)]"]=String(item)
		end
	end
	if(!isnothing(events))		
		for (i, item) in enumerate(events)
			api_data_fields["events[$(i-1)]"]=String(item)
		end
	end


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

	return HTTP.post(
		url;
		body=api_data_fields,
		require_ssl_verification=true,
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

