#TODO: AssertionError
#TODO: Eventually, each function should check for the proper type of token
# super tokens are for project creation, and most other functions work only with a project-level token

is_valid_super_token(token) = occursin(r"^[0-9A-F]{64}$", token)

#=
function assert_valid_token(token)
	if is_valid_token(token)
		return token
	else
		@error("REDCap API token is invalid")
		throw(AssertionError)
	end
end
=#

function get_valid_token()
	if !haskey(ENV, "REDCAP_API_TOKEN")
		@error("No REDCap API token found")
		throw(ArgumentError)
	end

	return ENV["REDCAP_API_TOKEN"] |> REDCap_token
end

function get_valid_super_token()
	if !haskey(ENV, "REDCAP_API_TOKEN")
		@error("No REDCap API token found")
		throw(ArgumentError)
	end

	return ENV["REDCAP_API_TOKEN"] |> REDCap_super_token
end

#=
function assert_valid_super_token(token)
	if is_valid_super_token(token)
		return token
	else
		@error("REDCap API token is invalid")
		throw(AssertionError)
	end
end
=#

function get_valid_url()
	if !haskey(ENV, "REDCAP_API_URL")
		@error("No REDCap API URL found")
		throw(ArgumentError)
	end

	return ENV["REDCAP_API_URL"] |> REDCap_url

	#=
	if !occursin(r"^https:\/\/.*\/api\/?$", url)
		@error("REDCap API URL is invalid")
		throw(AssertionError)
	end

	return url
	=#
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


