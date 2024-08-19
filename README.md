# REDCap.jl

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/REDCap.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)
[![](https://travis-ci.org/bcbi/REDCap.jl.svg?branch=master)](https://travis-ci.org/bcbi/REDCap.jl/branches)
[![](http://codecov.io/github/bcbi/REDCap.jl/coverage.svg?branch=master)](http://codecov.io/github/bcbi/REDCap.jl?branch=master)

A Julia frontend for the REDCap API

## Examples
```julia
using REDCap, CSV, JSON

export_version()

import_records(
  data=CSV.File("example.csv") |> JSON.json,
  format="json")

delete_records(records=[2,3])

export_logging()
```

## Notes
Your REDCap token and you institution's REDCap API URL are read from Julia's environment variables.
You can make them avaiable to REDCap.jl by putting the following lines in [your local Julia startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file) (probably `~/.julia/config/startup.jl`):
```julia
ENV["REDCAP_API_TOKEN"] = "C0FFEEC0AC0AC0DEC0FFEEC0AC0AC0DE"
ENV["REDCAP_API_URL"] = "http://example.com/redcap/api/"
```
Otherwise, all REDCap parameters are passed to REDCap.jl functions as named arguments, and these take values that are natural Julian types (Strings, Ints, Bools, DatesTimes, and Arrays).
Each REDCap API method is available as a named function that supplies required parameters and checks user inputs for validity.
If you need greater control over the parameters (due to REDCap version differences, for example), you could try calling the underlying `REDCap.request()` function directly:
```julia
REDCap.request(content="version")
```

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics core.
