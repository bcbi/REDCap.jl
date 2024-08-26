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
  data = (project_title = "Test Project", purpose = 0),
  odm = "Data_Dictionary.xml")

import_records(token=project_token, data="example.csv", format=:csv)

delete_records(token=project_token, records=[2,3])

export_logging(token=project_token)
```
More examples can be found in the [documentation](https://docs.bcbi.brown.edu/REDCap.jl/latest/examples/).

## Syntax
Every REDCap API method is available as a function that supplies certain required parameters and checks user inputs for validity.
Return values and REDCap messages are returned directly, but the documentation shows how these can be parsed.

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
The `data` parameter accepts a collection (Dict, NamedTuple, etc.) or a String.
String values are parsed - if they end with a .csv, .json, or .xml file extension, they are treated as a file name; otherwise, they are assumed to be a formatted string and are sent directly as part of the API request.

In the REDCap API, The presence of a `data` parameter often changes the behavior of a method.
For instance, most import methods are implemented as an export method with an added data parameter.
In REDCap.jl, it would be considered a bug for `import_project_data` to ever act as `export_project_data`, so the data paramater is almost always required where it is present.


### Format
Generally, the `format` parameter designates user input and the `returnFormat` parameter applies to REDCap messages and return values.
However, this is not consistent within REDCap.
REDCap.jl functions are designed to not accept any parameters that have no effect on the result.

## Content and Action
The `content` and `action` parameters are what define each REDCap method, for the most part.
These are passed internally in REDCap.jl and are never supplied by the user.

### Troubleshooting

If a function call doesn't produce the expected results, try making debug messages visible for this package by running `ENV["JULIA_DEBUG"] = REDCap`.
Feel free to create an issue for any unexpected errors, or for feature requests.

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics core.
