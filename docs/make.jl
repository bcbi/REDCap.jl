using Documenter, REDCap
using Literate

makedocs()

deploydocs(
	deps = Deps.pip("mkdocs", "mkdocs-material"),
    repo = "github.com/bcbi/REDCap.jl.git",
    julia = "0.6"
)