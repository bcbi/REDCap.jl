export delete_arms,
	export_arms,
	import_arms

function delete_arms(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:arm),
	       action=REDCap_action(:import),
		arms=arms,
	)
end

function export_arms(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:arm),
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
	)
end

function import_arms(;
	url::redcap_url_parameter=get_url(),
	token::redcap_token_parameter=get_token(),	
	format::redcap_format_parameter=nothing,
	data::redcap_data_parameter=nothing,
	returnFormat::redcap_returnFormat_parameter=nothing,
	override=0,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:arm),
		override=override,
		action=REDCap_action(:import),
		format=REDCap_format(format),
		data=REDCap_data(data),
		returnFormat=REDCap_format(returnFormat),
	)
end

#=
julia> arms = export_arms()
POSTing
POSTd
1-element Array{Any,1}:
Dict{String,Any}(Pair{String,Any}("name", "Arm 1"),Pair{String,Any}("arm_num", 1))

julia> newarm
Dict{String,Any} with 2 entries:
"name" => "Arm 1"
"arm_num" => 1

julia> push!(arms, newarm)
2-element Array{Any,1}:
Dict{String,Any}(Pair{String,Any}("name", "Arm 1"),Pair{String,Any}("arm_num", "1"))
Dict{String,Any}(Pair{String,Any}("name", "Arm 2"),Pair{String,Any}("arm_num", "2"))

julia> import_arms(arms)
POSTing
POSTd
2	<- this should indicate 2 arms added.

julia> export_arms()
POSTing
POSTd
1-element Array{Any,1}:
Dict{String,Any}(Pair{String,Any}("name", "Arm 1"),Pair{String,Any}("arm_num", 1))

=#
