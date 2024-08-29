#TODO: add something to automatically break files into < 500kb chunks?

function request(;
	url::URI,
	token::Union{REDCap_token, REDCap_super_token},
	content::REDCap_content,
	data=nothing,
	odm=nothing,
	kwargs...)

	#TODO: replace interpolation with string()?
	html_request_body = assemble_html_body(;kwargs...)
	html_request_body["token"] = token
	html_request_body["content"] = "$content"
	#TODO: Can't the data parameter be nothing and still hav an effect in at least 1 function?
	
	if !isnothing(odm)
		html_request_body["odm"] = read(odm,String)
	end

	#TODO: Add chunking (but what is bakgroundProcess=true, new to REDCap 14?)
	#Also, different formats have to be chunked differently.
	#Maybe stick to creating an iterator outside REDCap...
	if !isnothing(data)
		#if endswith.(data,[".csv",".json",".xml"]) |> any
		#TODO: is there any chance that this causes an issue
		#I would hate for a file to be sent against the user's intentions.
		#Example: someone puts in a value just for testing and doesn't realize they have that file present?
		#Maybe it is better to have no ambiguity - string gets sent, files are passed as file handles or something
		##TODO: also, there's something unsettling about how a variable could be passed,
		#and if that variable contains a file name, even by mistake, the contents of that file get sent.
		#but this is so convenient, and any actual issue it could cause seems far-fetched
		if !istoolong(data) && isfile(data)
			html_request_body["data"] = read(data,String)
		else
			html_request_body["data"] = "$data"
		end
	end

	@debug(filter(x->(first(x)!="token"), html_request_body))

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

#https://github.com/JuliaLang/julia/issues/39774#issuecomment-786797712
function istoolong(filename)
	try
		stat(filename)
		false
	catch e
		if isa(e, Base.IOError)
			e.code == -36
		else
			rethrow()
		end
	end
end


