# REDCap.jl
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/)

REDCap.jl is an API wrapper in Julia for REDCap v14.
[REDCap](https://en.wikipedia.org/wiki/REDCap) is a data capture system for scientific research, especially clinical trials.

## Examples
```julia
pkg> activate --temp; add REDCap
julia> using REDCap

julia> export_version()

julia> project_token = create_project(
  data = (project_title = "Test Project", purpose = 0),
  odm = "Data_Dictionary.xml")

julia> import_records(token=project_token, data="example.csv", format=:csv)

julia> delete_records(token=project_token, records=[2,3])

julia> export_logging(token=project_token)
```

For more details, see the internal documentation (`help?> REDCap`).

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics team.
