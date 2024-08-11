
export_DAGs(;kwargs...) = redcap_api(; content="dag", kwargs...)
import_DAGs(;kwargs...) = redcap_api(; method="import", content="dag", kwargs...)
