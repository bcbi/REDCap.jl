module REDCap

using HTTP
using JSON

include("Utils.jl")
include("API_Methods/arms.jl")
include("API_Methods/data_access_groups.jl")
include("API_Methods/metadata.jl")
include("API_Methods/REDCap.jl")

end
