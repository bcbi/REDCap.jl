export delete_arms,
	export_arms,
	import_arms

delete_arms(arms; kwargs...) = redcap_api(; method="delete", content="arm", arms=arms, kwargs...)
export_arms(; kwargs...) = redcap_api(; content="arm", kwargs...)
import_arms(; kwargs) = redcap_api(; method="import", content="arm", kwargs...)

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
