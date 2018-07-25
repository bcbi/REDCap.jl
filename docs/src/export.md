
## Exporting

### Records

Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`

```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

#records can also be exported directly to a file
export_records(config, file_loc="/src/output.csv", format="csv")
```

### Project Data

Project information, field names, metadata, events/arms, and users are all available for export. As above, the can be written directly to a file.

Some exports, such as version and url/return code for surveys return as simple strings, while most others return in the specified format.

A `.pdf` of the entire project is available through `export_pdf()`, as well as the entire project as an `xml` file through `export_project()`