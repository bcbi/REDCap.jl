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
	body = Dict{String, String}()
	if !isempty(kwargs)
		for (parameter,value) in kwargs
			if !isnothing(value)
				if isa(value, Array)
					for (i, item) in enumerate(value)
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

#TODO: condense these to 1 function after making sure they work for both data attributes and html body parameters
function assemble_data_parameter(;kwargs...)
	data = Dict()
	if !isempty(kwargs)
		for (attribute,value) in kwargs
			if !isnothing(value)
				if isa(value, Array)
					for (i, item) in enumerate(value)
						data["$attribute[$(i-1)]"] = "$item"
					end
				else
					data["attribute"] = "$value"
				end
			end
		end
	end
	return "[$(JSON.json(data))]"
end
