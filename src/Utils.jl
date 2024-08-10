"""
	api_pusher(mode::String, content::String; returnFormat::String="", file_loc::String="", kwargs...)

Pass the type of api call, the config struct, and any needed kwargs for that api call.

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
function api_pusher(mode::String, content::String; format::String="", file_loc::String="", kwargs...)
	#TODO: bytes |> HTTP.Sniff.isjson |> first to determine if data needs to be converted
	config = get_redcap_user_config()
	if isnothing(config)
		@error("Invalid REDCap credentials")
		return
	end

	fields = Dict{String, Any}("token" => config.key,
		"action" => mode,
		"content" => content,
		"format" => "json",
	)

	return HTTP.post(config.url, fields, require_ssl_verification=config.ssl, verbose = 3).body |> String

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
