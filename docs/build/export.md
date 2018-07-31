


<a id='Exporting-1'></a>

# Exporting


Exporting from a REDCap database is straightforward. If not specified, data exports will return as a `Dict`. If `csv` is passed as the format, a `DataFrame` will be returned. Some exports, such as version and url/return code for surveys return as simple strings, while most others return in the specified format.


Because REDCap is medical in nature, some information may be identifing information.  From REDCap Documentation:


<b>Note about export rights:</b>


> Please be aware that Data Export user rights will be applied to this API request. For example, if you have 'No Access' data export rights in the project, then the API data export will fail and return an error. And if you have 'De-Identified' or 'Remove all tagged Identifier fields' data export rights, then some data fields *might* be removed and filtered out of the data set returned from the API. To make sure that no data is unnecessarily filtered out of your API request, you should have 'Full Data Set' export rights in the project.



<a id='Records-1'></a>

## Records


___

<a id='REDCap.export_records-Tuple{REDCap.Config}' href='#REDCap.export_records-Tuple{REDCap.Config}'>#</a>
**`REDCap.export_records`** &mdash; *Method*.



```
export_records(config::REDCap.Config; format::String="json", dtype::String="flat", 
				records::Array=[], fields::Array=[], forms::Array=[], events::Array=[], rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
				exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
				exportDataAccessGroups::Bool=false, filterLogic::String="", file_loc::String="")
```

**Parameters:**

  * `config` - struct containing url and api-key
  * `format` - "json", "xml", "csv", or "odm". decides format of returned data
  * `dtype` - output mode: "flat" (output one record per row) or "eav" (one data point per row)
  * `records` - array of record names to include
  * `fields` - array of field names to include
  * `forms` - array of form names to include
  * `events` - array of event names to include
  * `rawOrLabel` - "raw" or "label" - export raw coded values or labels for multiple choice fields
  * `rawOrLabelHeaders` - same as above, for headers
  * `exportCheckboxLabel` - checkbox behavior: export checkboxes as "checked/unchecked" or as "field-name/<blank>"
  * `returnFormat` - error message format
  * `exportSurveyField` - flag to return survey fields or not
  * `exportDataAccessGroups` - flag to return DAGroups or not
  * `filterLogic` - allows collection of records that fulfill a criteria eg. "[age] > 65"
  * `file_loc` - location to export to

**Returns:**

Array of formatted dicts of set of records for a project.


___ Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`


```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

#records can also be exported directly to a file by passing `file_loc` a path
export_records(config, file_loc="/src/output.csv", format="csv")
```


<a id='Project-Info-1'></a>

## Project Info


Project information, field names, and metadata are all available for export. As above, the can be written directly to a file.


A `.pdf` of the entire project is available through `export_pdf()`, as well as the entire project as an `xml` file through `export_project()`


<a id='Field-and-Meta-Data-1'></a>

### Field and Meta Data


```julia
#Get a list of field names for the records
fields = export_field_names(config)

#Project metadata can be read and modified this way - See Section on Imports
metadata = export_metadata(config)

#Metadata output can also be formatted
metacsv = export_metadata(config, format="csv")
```


<a id='Full-Project-Info-1'></a>

### Full Project Info


```julia
#A dict of the projects information can be retreived through:
proj_info = export_project_information(config)

#A PDF summary of entire project
export_pdf(config, "<file-path>", allRecords=true)

#A PDF summary of specific records
export_pdf(config, "<file-path>", record="1", event="", instrument="demographics")
```


<a id='Reports-1'></a>

### Reports


  * broken fix reports


Reports can also be exported using the report name given on the REDCap dashboard.


```julia
report = export_report(config, "A")
```


<a id='Users-1'></a>

## Users


A full list of users can be exported and viewed/modified using the `export_users()` function. User Rights can be modified (by a user with appropriate rights) using this method. - See Section on Imports


```julia
#Returns an array of dictionaries
user_dict = export_users(config)
```


<a id='Surveys-1'></a>

## Surveys


  * broken fix surveys


REDCap allows surveys to be tied both to a given event and to an individual record. Accessing features of these surveys is easy through the provided API.


A survey link can be generated for a particular record and instrument/event through the `export_survey_link()` function;


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


<a id='Arms-1'></a>

## Arms


```julia

```


<a id='Instruments-1'></a>

## Instruments


```julia

```


<a id='Instrument-Event-Mappings-1'></a>

### Instrument Event Mappings


```julia

```

