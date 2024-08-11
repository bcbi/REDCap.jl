
export_DAGs(;kwargs...) = redcap_api(; content="dag", kwargs...)
import_DAGs(;kwargs...) = redcap_api(; action="import", content="dag", kwargs...)
