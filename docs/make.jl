using Documenter, REDCap
using Literate

makedocs()

deploydocs(
	deps = Deps.pip("mkdocs==0.17.5", "mkdocs-material==2.9.4"),
    repo = "github.com/bcbi/REDCap.jl.git",
    julia = "0.6",
    osname = "linux"
)