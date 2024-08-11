module REDCap

using HTTP
using JSON

include("Utils.jl")
include("arms.jl")
include("metadata.jl")

export export_version
export_version(;kwargs...) = redcap_api(;content="version", kwargs...)

end
