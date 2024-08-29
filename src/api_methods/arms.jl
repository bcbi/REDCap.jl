export delete_arms,
	export_arms,
	import_arms

function delete_arms(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
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
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	returnFormat::redcap_returnFormat_input=nothing,
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

#All examples use JSON
#TODO: what is the proper format for multi-item XML? I can't find this anywhere...
function import_arms(;
	url::redcap_url_input=get_url(),
	token::redcap_token_input=get_token(),	
	format::redcap_format_input=nothing,
	data::redcap_data_input=nothing, #TODO: is this required, given the action parameter?
	returnFormat::redcap_returnFormat_input=nothing,
	override=0,
	)

	REDCap.request(;
		url=REDCap_url(url),
		token=REDCap_token(token),
	       content=REDCap_content(:arm),
		override=override,
		action=REDCap_action(:import),
		format=REDCap_format(format),
		data=REDCap_data(data,REDCap_format(format),xml_tag="arms"),
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
