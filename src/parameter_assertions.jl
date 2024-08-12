#TODO: AssertionError

function assert_valid_token()
	if !haskey(ENV, "REDCAP_API_TOKEN")
		@error("No REDCap API token found")
		throw(ArgumentError)
	end

	token = ENV["REDCAP_API_TOKEN"]

	if !occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", token)
		@error("REDCap API token is invalid")
		throw(AssertionError)
	end

	return token
end

function assert_valid_super_token()
	if !haskey(ENV, "REDCAP_API_TOKEN")
		@error("No REDCap API token found")
		throw(ArgumentError)
	end

	token = ENV["REDCAP_API_TOKEN"]

	if !occursin(r"^[0-9A-F]{64}$", token)
		@error("REDCap API token is invalid")
		throw(AssertionError)
	end

	return token
end

function assert_valid_url()
	if !haskey(ENV, "REDCAP_API_URL")
		@error("No REDCap API URL found")
		throw(ArgumentError)
	end

	url = ENV["REDCAP_API_URL"]

	if !occursin(r"^https:\/\/.*\/api\/?$", url)
		@error("REDCap API URL is invalid")
		throw(AssertionError)
	end

	return url
end

function assert_valid_format(format)
	if !isnothing(format) && format ∈ ["csv", "json", "xml"]
		return format
	else
		@error("Invalid REDCap API parameter")
		throw(ArgumentError)
	end
end

#TODO: could use some work
#=
function assert_valid_folder_name(name)
	if isa(name, String) && length(name) ≤ 150
		return name
	else
		@error("Invalid REDCap API parameter")
		throw(ArgumentError)
	end
end
=#


