module REDCap

using Dates
using HTTP
using JSON
using URIs

include("types.jl")
include("utils.jl")
#include("api_methods/arms.jl")
#include("api_methods/data_access_groups.jl")
#include("api_methods/events.jl")
include("api_methods/field_names.jl")
#include("api_methods/files.jl")
#include("api_methods/file_repository.jl")
#include("api_methods/instruments.jl")
include("api_methods/logging.jl")
include("api_methods/metadata.jl")
include("api_methods/projects.jl")
include("api_methods/records.jl")
include("api_methods/redcap.jl")
#include("api_methods/repeating_instruments_and_events.jl")
#include("api_methods/reports.jl")
#include("api_methods/surveys.jl")
include("api_methods/users.jl")
include("api_methods/user_roles.jl")

end
