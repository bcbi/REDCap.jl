# RedCap

[![Build Status](https://travis-ci.org/FLCN17/RedCap.jl.svg?branch=master)](https://travis-ci.org/FLCN17/RedCap.jl)

[![Coverage Status](https://coveralls.io/repos/FLCN17/RedCap.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/FLCN17/RedCap.jl?branch=master)

[![codecov.io](http://codecov.io/github/FLCN17/RedCap.jl/coverage.svg?branch=master)](http://codecov.io/github/FLCN17/RedCap.jl?branch=master)

A Julia frontend for the REDCap API.

Progress:
======----

### Documentation:

Put links here

### Features:

REDCap.jl supports both importing and exporting records, as well as deletion.

### Requirements:


### Usage:

All REDCap projects need to be tied to their url and API Key, which is done by creating a Config object
```julia
config = REDCap.Config("<url>", "<32-digit_API_key>")
```


#### Exporting:
Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`
```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

export_records(config, file_loc="/src/output.csv", format="csv")
```


#### Importing:

Importing is handled much the same way, with the ability to import directly from a file
```julia
import_records(config, records_data)

import_records(config, "/src/records.csv", format="csv")
```
By default, `json` is passed as the target format, but `csv`/`df`, `xml`, and `odm` formats are supported for import as well as output.


#### Other Functionality:

Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for that project.
```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```


```julia
code example
```

```julia
code example
```

```julia
code example
```