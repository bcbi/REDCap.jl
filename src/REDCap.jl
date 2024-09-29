#TODO: some import methods can be used to delete entries
# Should this behavior be migrated to delete_* functions?

"""
REDCap API methods are defined as named Julia functions.
The `content` and `action` parameters are managed internally.

Function docstrings indicate how to use the Julia functions.
Refer to the official documentation for detailed specifications on the corresponding REDCap methods.

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
The `data` parameter contains a list of attributes, which varies between REDCap methods.
For definitive attribute lists, see the official REDCap documentation.
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
data_string = \"\"\"
    [{"data_access_group_name":"CA Site","unique_group_name":"ca_site"},
    {"data_access_group_name":"FL Site","unique_group_name":"fl_site"},
    {"data_access_group_name":"New Site","unique_group_name":""}]
\"\"\"
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

For import methods, the `format` parameter designates user input and the `returnFormat` parameter applies to REDCap messages and return values.
Otherwise, there is generally only a single `format` parameter that applies to REDCap messages and return values.

### `content` and `action`
The `content` and `action` parameters are what define each REDCap method, for the most part.
In REDCap.jl, these are passed internally and don't need to be supplied by the user.
Instead, they're fixed for each function.

## Troubleshooting
- If a function call doesn't produce the expected results, try making debug messages visible for this package by running `ENV["JULIA_DEBUG"] = REDCap`.
- The `data` parameter is converted to a formatted string, so you might try different format parameters (`:csv`, `:json`, or `:xml`).
If you're uncertain about the format for an input data parameter, try setting up an example in the browser and exporting the data.
You may have to remove the values for certain generated columns before importing.
- Feel free to create an issue for any unexpected errors, or for feature requests.
"""
module REDCap

using Dates
using HTTP
using JSON
using URIs

include("types.jl")

include("export.jl")
include("request.jl")
include("utils.jl")
include("api_methods/arms.jl")
include("api_methods/data_access_groups.jl")
include("api_methods/events.jl")
include("api_methods/field_names.jl")
include("api_methods/files.jl")
include("api_methods/file_repository.jl")
include("api_methods/instruments.jl")
include("api_methods/logging.jl")
include("api_methods/metadata.jl")
include("api_methods/projects.jl")
include("api_methods/records.jl")
include("api_methods/redcap.jl")
include("api_methods/repeating_instruments_and_events.jl")
include("api_methods/reports.jl")
include("api_methods/surveys.jl")
include("api_methods/users.jl")
include("api_methods/user_roles.jl")

end
