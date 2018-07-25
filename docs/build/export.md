


<a id='Exporting-1'></a>

# Exporting


<a id='Records-1'></a>

## Records

<a id='REDCap.export_records-Tuple{REDCap.Config}' href='#REDCap.export_records-Tuple{REDCap.Config}'>#</a>
**`REDCap.export_records`** &mdash; *Method*.



```
export_records(config::Config; format::String="json", dtype::String="flat", 
				records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", 
				exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, 
				exportDataAccessGroups::Bool=false, filterLogic::String, file_loc::String="")
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


Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`


```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

#records can also be exported directly to a file
export_records(config, file_loc="/src/output.csv", format="csv")
```


<a id='Project-Data-1'></a>

## Project Data


Project information, field names, metadata, events/arms, and users are all available for export. As above, the can be written directly to a file.


Some exports, such as version and url/return code for surveys return as simple strings, while most others return in the specified format.


A `.pdf` of the entire project is available through `export_pdf()`, as well as the entire project as an `xml` file through `export_project()`


<a id='Functions-1'></a>

## Functions

- [`REDCap.export_records`](export.md#REDCap.export_records-Tuple{REDCap.Config})

