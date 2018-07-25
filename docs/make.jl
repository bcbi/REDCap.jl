using Documenter, REDCap

makedocs()

deploydocs(
	deps = Deps.pip("mkdocs"),
    repo = "github.com/bcbi/REDCap.jl.git",
    julia = "0.6"
)