using Documenter
using REDCap

makedocs(
    sitename = "REDCap.jl",
    format = Documenter.HTML(),
    modules = [REDCap],
    pages = ["Home" => "index.md", "API reference" => "api.md", "Internals" => "internals.md"],
)

deploydocs(
    repo = "github.com/bcbi/REDCap.jl.git",
)
