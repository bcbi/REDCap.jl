#TODO: add something to automatically break files into < 500kb chunks?

function request(;
	url::URI,
	token::Union{REDCap_token, REDCap_super_token},
	content::REDCap_content,
	data=nothing,
	kwargs...)

	#TODO: replace interpolation with string()?
	html_request_body = assemble_html_body(;kwargs...)
	html_request_body["token"] = token
	html_request_body["content"] = "$content"
	#TODO: Can't the data parameter be nothing and still hav an effect in at least 1 function?
	if !isnothing(data); html_request_body["data"] = "$data" end

	println("Posting the following (token not shown): ", filter(x->(first(x)!="token"), html_request_body))

	response = HTTP.post(
		URI(url);
		#get_valid_url();
		body=html_request_body,
		require_ssl_verification=true,
		#verbose = 3,
		status_exception=false,
	)

	#HTTP.iserror(r)
	
	status_codes_message = Dict(
		200 => "OK: Success!",
		400 => "Bad Request: The request was invalid.",
		401 => "Unauthorized: API token was missing or incorrect.",
		403 => "Forbidden: You do not have permissions to use the API.",
		404 => "Not Found: The URI you requested is invalid or the resource does not exist.",
		406 => "Not Acceptable: The data being imported was formatted incorrectly.",
		500 => "Internal Server Error: The server encountered an error processing your request.",
		501 => "Not Implemented: The requested method is not implemented.",
		)

	@debug("HTTP response $(response.status), $(get(status_codes_message,response.status,"Unknown"))")

	return response.body|> String 
end

function assemble_html_body(;kwargs...)
	body = Dict{String, String}()
	if !isempty(kwargs)
		for (parameter,value) in kwargs
			value::redcap_generic_parameter
			if !isnothing(value)
				#if parameter ∈ [:data, :filterLogic]
					#body["$parameter"] = IOBuffer(string(value))
				if isa(value, Array)
					for (i, item) in enumerate(value)
						body["$parameter[$(i-1)]"] = string(item)
					end
				else
					body["$parameter"] = "$value"
				end
			end
		end
	end
	return body
end

function get_token()
	if !haskey(ENV, "REDCAP_API_TOKEN")
		@error("No REDCap API token found")
		throw(ArgumentError)
	end

	return ENV["REDCAP_API_TOKEN"]
end

function get_url()
	if !haskey(ENV, "REDCAP_API_URL")
		@error("No REDCap API URL found")
		throw(ArgumentError)
	end

	return ENV["REDCAP_API_URL"]
end

