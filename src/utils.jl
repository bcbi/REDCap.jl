function request(;
	dry_run=false,
	url::redcap_url_parameter,
	token::redcap_either_token,
	content::redcap_content_parameter,
	kwargs...)

	html_request_body = assemble_html_body(;kwargs...)
	html_request_body["x-forwarded-proto"] = "https"
	html_request_body["token"] = REDCap_token(token)
	html_request_body["content"] = "$content"

	return dry_run ? html_request_body : HTTP.post(
		URI(url);
		#get_valid_url();
		body=html_request_body,
		require_ssl_verification=true,
		#verbose = 3,
		status_exception=false,
	).body |> String 
	#HTTP.iserror(r)
end

function assemble_html_body(;kwargs...)
	body = Dict{String, String}() #TODO: Any way to use limited strings here? Anything with constant size?
	if !isempty(kwargs)
		for (parameter,value) in kwargs
			if !isnothing(value)
				if isa(value, Array)
					for (i, item) in enumerate(value)
						#TODO: define print functions for custom internal types
						body["$parameter[$(i-1)]"] = "$item"
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

