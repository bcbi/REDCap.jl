function request(;url,token,content,kwargs...)
	body = Dict()
	body["x-forwarded-proto"] = "https"
	body["token"] = token
	body["content"] = content
	for (k,v) in kwargs
		if !isnothing(v)
			if isa(v, Array)
				for (i, item) in enumerate(v)
					body["$k[$(i-1)]"] = "$item"
				end
			else
				body[String(k)] = "$v"
			end
		end
	end

	#return body

	return HTTP.post(
		url;
		#get_valid_url();
		body=body,
		require_ssl_verification=true,
		#verbose = 3,
		status_exception=false,
	).body |> String 
	#HTTP.iserror(r)
end
