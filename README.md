# REDCap.jl

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/REDCap.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)
[![](https://travis-ci.org/bcbi/REDCap.jl.svg?branch=master)](https://travis-ci.org/bcbi/REDCap.jl/branches)
[![](http://codecov.io/github/bcbi/REDCap.jl/coverage.svg?branch=master)](http://codecov.io/github/bcbi/REDCap.jl?branch=master)

A Julia frontend for the REDCap API

## Example
```julia
using REDCap

export_version()

project_token = create_project(
  data=Dict(:project_title => "Test Project",:purpose => 0),
  odm="Data_Dictionary.xml")

import_records(token=project_token, data="example.csv", format=:csv)

delete_records(token=project_token, records=[2,3])

export_logging(token=project_token)
```
More examples can be found in the [documentation](https://docs.bcbi.brown.edu/REDCap.jl/latest/examples/).

## Syntax
Every REDCap API method is available as a function that supplies certain required parameters and checks user inputs for validity.
Type and coherency checks are quite strict, which prevents certain user errors that can be difficult to diagnose with the REDCap's error messages.

Function arguments are named after RECap method parameters.
These are passed as named arguments and take values with intuitive types, with a few exceptions to note:

### Token and URL
Your REDCap token and your institution's REDCap API URL can be read by default from Julia's environment variables.
You can make them avaiable to REDCap.jl by putting the following lines in [your local Julia startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file) (probably `~/.julia/config/startup.jl`):
```julia
ENV["REDCAP_API_TOKEN"] = "C0FFEEC0AC0AC0DEC0FFEEC0AC0AC0DE"
ENV["REDCAP_API_URL"] = "http://example.com/redcap/api/"
```

### Data
The data parameter accepts either a filename, or a Julia `Dict`.

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics core.
