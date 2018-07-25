


<a id='REDCap-1'></a>

# REDCap

    - [Exporting](export.md#Exporting-1)
    - [Importing](import.md#Importing-1)
- [REDCap](index.md#REDCap-1)
    - [Overview](index.md#Overview-1)
    - [Usage](index.md#Usage-1)
    - [Index](index.md#Index-1)
- [Other Functionality](utils.md#Other-Functionality-1)
    - [Config](utils.md#Config-1)
    - [Project Creation](utils.md#Project-Creation-1)


<a id='Overview-1'></a>

## Overview


A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation. 


<a id='Usage-1'></a>

## Usage


```julia
using REDCap

#create config object for project creation
super_config = REDCap.Config("<URL>", "<S-API>")

config = create_project(super_config, "Test Project", 1; purpose_other="Testing REDCap.jl Functionality", project_notes="This is not an actual REDCap Database.")


#Importing- NOTE: Records may be incomplete. Only provided fields will be updated
record=[Dict("sex"=>"0",
			  "age"=>"56",
			  "address"=>"168 Anderson Blvd. Quincy MA 01227",
			  "height"=>"80",
			  "dob"=>"1962-04-08",
			  "record_id"=>"1",
			  "bmi"=>"125",
			  "comments"=>"Randomly Generated - Demographics",
			  "email"=>"ALin@aol.com",
			  "first_name"=>"Alexia",
			  "demographics_complete"=>"0",
			  "telephone"=>"(617) 882-6049",
			  "weight"=>"80",
			  "last_name"=>"Lin",
			  "ethnicity"=>"1",
			  "race"=>"1")]

import_records(config, record)

#create new user with basic import/export permissions
user=[Dict("username" => "john_smith@email.com",
				 "email" => "john_smith@email.com",
				 "lastname" => "Smith",
				 "api_export"=>"1",
				 "api_import"=>"1")]

import_users(config, user)

#Exporting
records = export_records(config)

#Edit project info to remove development status
final_proj_info=Dict("project_title" => "RC Production",
				  	 "in_production" => "1")
import_project_information(config, final_proj_info)

#pdf summary of the project
export_pdf(config, "/<path>/export.pdf", allRecords=true)
```

<a id='REDCap.export_field_names-Tuple{REDCap.Config}' href='#REDCap.export_field_names-Tuple{REDCap.Config}'>#</a>
**`REDCap.export_field_names`** &mdash; *Method*.



```
export_field_names(config::Config; format::String="json", file_loc::String="")
```

##Parameters:

  * `config` - struct containing url and api-key
  * `format` - "json", "xml", "csv", or "odm". decides format of returned data
  * `file_loc` - location to export to

##Returns: Formatted dict of export/import-specific version of field names  for all fields (or for one field, if desired) in project:  'original_field_name', 'choice_value', and 'export_field_name'


<a id='Index-1'></a>

## Index

- [`REDCap.export_field_names`](index.md#REDCap.export_field_names-Tuple{REDCap.Config})

