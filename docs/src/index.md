```@meta
CurrentModule = REDCap
```

# REDCap.jl

A Julia wrapper for the [REDCap](https://projectredcap.org) API

```julia
pkg> add REDCap
```

```@docs
REDCap
```

## Example

```julia
using REDCap, DataFrames

project = REDCapProject(url="https://redcap.example.org/api/", token=ENV["STUDY_TOKEN"])

export_version(project)                       # v"15.0.1"
metadata = export_metadata(project) |> DataFrame

# Import rows; blanks are ignored and existing values are kept
import_records(project; data=[
    (record_id="1", redcap_event_name="baseline_arm_1", age="34"),
    (record_id="2", redcap_event_name="baseline_arm_1", age="41"),
])                                            # 2

# Export, in batches of 500 records
records = export_records(project; fields=[:record_id, :age], batchsize=500) |> DataFrame

# Write raw CSV to a file
open(io -> export_records(project, io; format=:csv), "records.csv", "w")

# Files
import_file(project; record=1, field=:consent, event="baseline_arm_1", file=REDCapFile("consent.pdf"))
pdf = export_file(project; record=1, field=:consent, event="baseline_arm_1")
write(pdf.filename, pdf.data)

# Destructive operations have their own names
delete_records(project; records=[1, 2])       # 2
```

Creating a project needs a super token:

```julia
superuser = REDCapSuperUser()                 # ENV["REDCAP_API_SUPER_TOKEN"]
project = create_project(superuser;
    data=(project_title="My study", purpose=0),
    odm=REDCapFile("template.REDCap.xml"))
```
