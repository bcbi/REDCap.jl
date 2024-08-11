
function get_valid_token()
	token = get(ENV, "REDCAP_API_TOKEN", "")
	if occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", token)
		return token
	else
		@error("No valid REDCap API token found")
		throw(ArgumentError)
	end
end

function get_valid_url()
	url = get(ENV, "REDCAP_API_URL", "")
	if occursin(r"^https:\/\/.*\/api\/?$", url)
		return url
	else
		@error("No valid REDCap API URL found")
		throw(ArgumentError)
	end
end

function get_valid_format(format)
	if format ∈ ["csv", "json", "xml"]
		return format
	else
		@error("Invalid REDCap API parameter")
		throw(ArgumentError)
	end
end

function get_valid_folder_name(name)
	if length(name) ≤ 150
		return name
	else
		@error("Invalid REDCap API parameter")
		throw(ArgumentError)
	end
end


