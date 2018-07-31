```@meta
CurrentModule = REDCap
```
# Exporting

Exporting from a REDCap database is straightforward. If not specified, data exports will return as a `Dict`. If `csv` is passed as the format, a `DataFrame` will be returned. Some exports, such as version and url/return code for surveys return as simple strings, while most others return in the specified format.

Because REDCap is medical in nature, some information may be identifing information. 
From REDCap Documentation:

<b>Note about export rights:</b>
> Please be aware that Data Export user rights will be applied to this API request. For example, if you have 'No Access' data export rights in the project, then the API data export will fail and return an error. And if you have 'De-Identified' or 'Remove all tagged Identifier fields' data export rights, then some data fields *might* be removed and filtered out of the data set returned from the API. To make sure that no data is unnecessarily filtered out of your API request, you should have 'Full Data Set' export rights in the project.



## Records
___
```@docs
export_records(config::REDCap.Config; format::String="json", dtype::String="flat", records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String, file_loc::String="")
```
___
Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`

```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

#records can also be exported directly to a file by passing `file_loc` a path
export_records(config, file_loc="/src/output.csv", format="csv")
```


## Project Info

Project information, field names, and metadata are all available for export. As above, the can be written directly to a file.

A `.pdf` of the entire project is available through `export_pdf()`, as well as the entire project as an `xml` file through `export_project()`

### Field and Meta Data

```julia
#Get a list of field names for the records
fields = export_field_names(config)

#Project metadata can be read and modified this way - See Section on Imports
metadata = export_metadata(config)

#Metadata output can also be formatted
metacsv = export_metadata(config, format="csv")
```

### Full Project Info
```julia
#A dict of the projects information can be retreived through:
proj_info = export_project_information(config)

#A PDF summary of entire project
export_pdf(config, "<file-path>", allRecords=true)

#A PDF summary of specific records
export_pdf(config, "<file-path>", record="1", event="", instrument="demographics")
```

### Reports

Reports can also be exported using the generated id given on the REDCap dashboard. This is NOT the name of the report.

```julia
report = export_report(config, "2")
```
A Report can contain a subset of records along with a subset of their fields. Report creation is handled through the REDCap project database.

## Users

A full list of users can be exported and viewed/modified using the `export_users()` function. User Rights can be modified (by a user with appropriate rights) using this method. - See Section on Imports

```julia
#Returns an array of dictionaries
user_dict = export_users(config)
```

## Surveys

REDCap allows surveys to be tied both to a given event and to an individual record. Accessing features of these surveys is easy through the provided API.

A survey link can be generated for a particular record and instrument/event through the `export_survey_link()` function. The instrument name may be different then it is displayed on the REDCap dashboard.
```julia
#Creates a URL to survey for a given record
link = export_survey_link(config, "23", "demographics", "")
```

Return codes and Queue links can also be created by passing mostly the same values

```julia
#Survey return codes
code = export_survey_return_code(config, "1", "demographics", "")

#Survey queue link
qlink =  export_survey_queue_link(config, "1")

#Survey Partcipant list
list = export_survey_participant_list(config, "demographics", "")
```

## Arms

```julia

```


## Instruments

```julia

```


### Instrument Event Mappings

```julia

```
