module REDCap

using HTTP
using JSON

include("parameters.jl")
include("utils.jl")
include("API_methods/arms.jl")
include("API_methods/data_access_groups.jl")
include("API_methods/events.jl")
include("API_methods/field_names.jl")
include("API_methods/files.jl")
include("API_methods/metadata.jl")
include("API_methods/REDCap.jl")

end
