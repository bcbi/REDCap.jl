# REDCap.jl
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/)

[REDCap](https://en.wikipedia.org/wiki/REDCap) is a data capture system for scientific research, especially clinical trials.
REDCap.jl is an API wrapper for REDCap v14, written in Julia.

## Examples
```julia
using REDCap

export_version()

project_token = create_project(
  data = (project_title = "Test Project", purpose = 0),
  odm = "Data_Dictionary.xml")

import_records(token=project_token, data="example.csv", format=:csv)

delete_records(token=project_token, records=[2,3])

export_logging(token=project_token)
```

For more details, see the internal documentation (`?REDCap`).

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics team.
