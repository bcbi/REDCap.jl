# REDCap.jl
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/latest)

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

## Syntax
Each REDCap method accepts a number of parameters that follow a shared naming convention.
REDCap.jl is designed to closely follow the design and syntax patterns of REDCap.
Every REDCap API method is available as a function that supplies certain required parameters and checks user inputs for validity.

Return values and REDCap messages are returned as Strings directly, but the documentation shows how these can be parsed in useful ways.

Function arguments are named after REDCap method parameters.
These are passed as named arguments and take values with intuitive types.

### `token` and `url`
Nearly all REDCap methods accept a token that is unique to the project and user.

The URL must exactly match this example:
```https://example.example/redcap/api/```

Your REDCap token and your institution's REDCap API URL can be read by default from Julia's environment variables.
You can make them avaiable to REDCap.jl by putting the following lines in [your local Julia startup file](https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file) (probably `~/.julia/config/startup.jl`):
```julia
ENV["REDCAP_API_TOKEN"] = "C0FFEEC0AC0AC0DEC0FFEEC0AC0AC0DE"
ENV["REDCAP_API_URL"] = "http://example.com/redcap/api/"
```
They can also be passed as ordinary named arguments.

A few methods accept a super token, including `create_project`, which can be used to generate a project and project-level token.
If you have a super token, you might wish to keep that in your startup file, generating and saving project-level tokens as needed.

### `data`
The `data` parameter contains a list of attributes.
In REDCap.jl, this can be a NamedTuple (or any derived type), a file handle, or a String.
If you use a NamedTuple, it will be translated internally into whatever `format` you use (xml by default).
```julia
import_project_info(
    data=(
        project_title="New name",
        project_notes="New notes"
    ),
    returnFormat=:csv,
)
```
But please keep in mind that a NamedTuple with one value must contain a comma:
```julia
import_project_info(
    data=(
        project_title="New name", # this comma is required
    ),
    returnFormat=:csv,
)
```
A `Dict` value is fine as well.
```julia
import_project_info(data=Dict(:project_title=>"New name"), returnFormat=:csv)
```
String values are accepted. If the string is a file name, the contents of the file are sent; otherwise, the value is sent directly as part of the API request.
```julia
data_string = """
    [{"data_access_group_name":"CA Site","unique_group_name":"ca_site"},
    {"data_access_group_name":"FL Site","unique_group_name":"fl_site"},
    {"data_access_group_name":"New Site","unique_group_name":""}]
"""
out = open("data_file.json","w"); write(out, data_string); close(out)

import_DAGs(token=t,data=data_string, format=:json) # string is passed to the API

import_DAGs(token=t, data="data_file.json", format=:json) # string is pattern-matched as a filename 

```
As for collections, only collections of scalar entries are currently supported.
So, a list of attributes and values is accepted, but a Dict containing multiple rows per column can only be read in from a file.

In the REDCap API, the presence of a `data` parameter often changes the behavior of a method.
For instance, most import methods are implemented as an export method with an added data parameter.
In REDCap.jl, it would be considered a bug for `import_project_data` to ever act as `export_project_data`, so the data paramater is almost always required where it is present.

### `format` and `returnFormat`
Supported options are `:csv`, `:json`, `:xml` (the default value), and sometimes `:odm`.
These values can be passed as Strings or Symbols.

Generally, the `format` parameter designates user input and the `returnFormat` parameter applies to REDCap messages and return values.
However, this is not consistent within REDCap.
REDCap.jl functions are designed to not accept any parameters that have no effect on the result.

### `content` and `action`
The `content` and `action` parameters are what define each REDCap method, for the most part.
In REDCap.jl, these are passed internally and don't need to be supplied by the user.
Instead, they're fixed for each function.

## Troubleshooting
If a function call doesn't produce the expected results, try making debug messages visible for this package by running `ENV["JULIA_DEBUG"] = REDCap`.
The data parameter is converted to a formatted string, so you might try different format parameters (`:csv`, `:json`, or `:xml`).
Feel free to create an issue for any unexpected errors, or for feature requests.

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics team.
