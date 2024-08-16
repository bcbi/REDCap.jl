export delete_arms,
	export_arms,
	import_arms

function delete_arms(;arms=nothing)
	REDCap.request(;
		content="arm",
		action="import",
		arms=arms,
	)
end

function export_arms(;format="xml",arms=nothing,returnFormat=nothing)
	REDCap.request(;
		content="arm",
		format=format,
		arms=arms,
		returnFormat=isnothing(returnFormat) ? format : "xml",
	)
end

function import_arms(;format="xml",data=nothing,override=0,returnFormat=nothing)
	REDCap.request(;
		content="arm",
		override=override,
		action="import",
		format=format,
		data=data,
		returnFormat=isnothing(returnFormat) ? format : "xml",
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
  "name"    => "Arm 1"
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
