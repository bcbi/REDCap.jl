export redcap_api

"""
	redcap_api(mode::String, content::String; returnFormat::String="", file_loc::String="", kwargs...)


API documentation found here:
https://<your-redcap-site.com>/redcap/api/help/

#### Parameters:
* `mode` - "import", "export", or "delete"
* `content` - Passed by calling modules to indicate what data to access
* `format` - "json", "xml", "csv", or "odm". decides format of returned data
* `file_loc` - Location of file
* `kwargs...` - Any addtl. arguments passed by the calling module

#### Returns:
Formatted response body
"""
function redcap_api(;
	token::String=get(ENV, "REDCAP_API_TOKEN", ""),
	url::String=get(ENV, "REDCAP_API_URL", ""),
	action::String="",
	content::String="",
	data::String="",
	file_loc::String="",
	kwargs...)

	fields = Dict("token" => token,
		"action" => action,
		"content" => content,
	)

for (k,v) in kwargs
		k=String(k) #k is a Symbol, make easier to handle
		if mode=="import" && isequal(k, "data") #Turn all imported data into an IOBuffer so HTTP won't mess with it OR turn filterLogic data into a buffer because it uses []'s and REDCap can't understand URI encoding
			fields[k]=IOBuffer(v)
		elseif isa(v, Array) #Turn arrays into specially URI encoded arrays
			for (i, item) in enumerate(v)
			    fields["$k[$(i-1)]"]=String(item)
			end
		elseif isequal(k, "filterLogic") && v != ""
			fields[k]=IOBuffer(v)
		else
			fields[k]=string(v)
		end
	end

	return HTTP.post(url; body=fields, require_ssl_verification=true).body |> String 


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
