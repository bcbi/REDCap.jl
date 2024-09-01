#TODO: add something to automatically break files into < 500kb chunks?
#There's also a new batchProcess parameter

#TODO: could enforce types here
function request(; url::URI, data=nothing, odm=nothing, kwargs...)

	html_request_body = generate_request_body(; data, odm, kwargs...)

	log_redacted_request(html_request_body)

	response = HTTP.post(
		URI(url);
		#get_valid_url();
		body=html_request_body,
		require_ssl_verification=true,
		#verbose = 3,
		status_exception=false,
	)
	#HTTP.iserror(r)
	log_status_code(response.status)
	
	return response.body|> String 
end

function generate_request_body(; data=nothing, odm=nothing, kwargs...)
	html_request_body = Dict{String, String}()
	if !isempty(kwargs)
		for (parameter,value) in kwargs
			append_as_redcap_pair!(html_request_body, parameter, value)
		end
	end

	if !isnothing(odm); append_as_redcap_pair!(html_request_body, :odm, read(odm,String)) end

	#TODO: Add chunking (but what is bakgroundProcess=true, new to REDCap 14?)
	#Also, different formats have to be chunked differently.
	#Maybe stick to creating an iterator outside REDCap...
	#TODO: Can't the data parameter be nothing and still hav an effect in at least 1 function?
	if !isnothing(data)
		#if endswith.(data,[".csv",".json",".xml"]) |> any
		#TODO: is there any chance that this causes an issue
		#I would hate for a file to be sent against the user's intentions.
		#Example: someone puts in a value just for testing and doesn't realize they have that file present?
		#Maybe it is better to have no ambiguity - string gets sent, files are passed as file handles or something
		##TODO: also, there's something unsettling about how a variable could be passed,
		#and if that variable contains a file name, even by mistake, the contents of that file get sent.
		#but this is so convenient, and any actual issue it could cause seems far-fetched
		#TODO: improve this syntax?
		append_as_redcap_pair!(html_request_body, :data, as_redcap_data(data))
	end
	return html_request_body
end

append_as_redcap_pair!(d::Dict, parameter::Symbol, value::Nothing) = nothing
function append_as_redcap_pair!(parameter::Symbol, value::Array)
	for (i, item) in enumerate(value)
		d[string(parameter,'[',i-1,']')] = string(item)
	end
end
function append_as_redcap_pair!(d::Dict, parameter::Symbol, value)
	d[string(parameter)] = string(value)
end

function as_redcap_data(data)
	if !istoolong(data) && isfile(data)
		return read(data,String)
	else
		return string(data)
	end
end

function log_redacted_request(html_request_body)
	#TODO: is this misleading where there is no token?
	@debug(merge(filter(x->(first(x)!="token"), html_request_body), Dict("token" => "***")))
end

function log_status_code(status)
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
	message = get(status_codes_message,status,"Unknown")
	@debug(string("HTTP response", status, message))
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


