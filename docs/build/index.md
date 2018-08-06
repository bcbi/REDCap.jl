


<a id='REDCap-1'></a>

# REDCap

- [REDCap](index.md#REDCap-1)
    - [Overview](index.md#Overview-1)
    - [Usage](index.md#Usage-1)
    - [Index](index.md#Index-1)
- [Exporting](export.md#Exporting-1)
    - [Records](export.md#Records-1)
    - [Project Info](export.md#Project-Info-1)
    - [Users](export.md#Users-1)
    - [Surveys](export.md#Surveys-1)
    - [Arms](export.md#Arms-1)
    - [Events](export.md#Events-1)
    - [Instruments](export.md#Instruments-1)
    - [Instrument Event Mappings](export.md#Instrument-Event-Mappings-1)
- [Importing](import.md#Importing-1)
    - [Records](import.md#Records-1)
    - [Project Info](import.md#Project-Info-1)
    - [Metadata](import.md#Metadata-1)
    - [Users](import.md#Users-1)
    - [Files](import.md#Files-1)
    - [Arms](import.md#Arms-1)
    - [Events](import.md#Events-1)
    - [Instrument Event Mappings](import.md#Instrument-Event-Mappings-1)
- [Deleting](delete.md#Deleting-1)
    - [Records](delete.md#Records-1)
    - [Files](delete.md#Files-1)
    - [Arms](delete.md#Arms-1)
    - [Events](delete.md#Events-1)
- [Other Functionality](utils.md#Other-Functionality-1)
    - [Config](utils.md#Config-1)
    - [Project Creation](utils.md#Project-Creation-1)


<a id='Overview-1'></a>

## Overview


A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation.


This package is meant to be a straightforward wrapper for the REDCap API, and assumes familiarity with REDCap. 


<a id='Usage-1'></a>

## Usage


A basic project can be created and accessed like so:


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


Several projects may wish to take advantage of saving and loading directly to/from a file;


```julia
#Exporting - file_loc must be provided as the save path
export_records(config, file_loc="<path>/records.xml", format="xml")

export_users(config, file_loc="<path>/users.csv", format="csv")

#Importing - data passed as a file-path is loaded directly into the API
import_records(config, "<path>/records.xml", format="xml") #NOTE: The format must match the file format you are uploading

import_users(config, "<path>/users.csv", format="csv")
```


<a id='Index-1'></a>

## Index

- [`REDCap.create_project`](utils.md#REDCap.create_project-Tuple{REDCap.Config,String,Integer})
- [`REDCap.delete_arms`](delete.md#REDCap.delete_arms-Tuple{REDCap.Config,Array})
- [`REDCap.delete_events`](delete.md#REDCap.delete_events-Tuple{REDCap.Config,Array})
- [`REDCap.delete_file`](delete.md#REDCap.delete_file-Tuple{REDCap.Config,String,String,String})
- [`REDCap.delete_records`](delete.md#REDCap.delete_records-Tuple{REDCap.Config,Array})
- [`REDCap.export_arms`](export.md#REDCap.export_arms-Tuple{REDCap.Config})
- [`REDCap.export_events`](export.md#REDCap.export_events-Tuple{REDCap.Config})
- [`REDCap.export_instrument_event_mappings`](export.md#REDCap.export_instrument_event_mappings)
- [`REDCap.export_instruments`](export.md#REDCap.export_instruments-Tuple{REDCap.Config})
- [`REDCap.export_records`](export.md#REDCap.export_records-Tuple{REDCap.Config})
- [`REDCap.export_report`](export.md#REDCap.export_report-Tuple{REDCap.Config,Integer})
- [`REDCap.export_users`](export.md#REDCap.export_users-Tuple{REDCap.Config})
- [`REDCap.import_arms`](import.md#REDCap.import_arms-Tuple{REDCap.Config,Any})
- [`REDCap.import_events`](import.md#REDCap.import_events-Tuple{REDCap.Config,Any})
- [`REDCap.import_file`](import.md#REDCap.import_file-Tuple{REDCap.Config,String,String,String,String})
- [`REDCap.import_instrument_event_mappings`](import.md#REDCap.import_instrument_event_mappings-Tuple{REDCap.Config,Any})
- [`REDCap.import_metadata`](import.md#REDCap.import_metadata-Tuple{REDCap.Config,Any})
- [`REDCap.import_project_information`](import.md#REDCap.import_project_information-Tuple{REDCap.Config,Any})
- [`REDCap.import_records`](import.md#REDCap.import_records-Tuple{REDCap.Config,Any})
- [`REDCap.import_users`](import.md#REDCap.import_users-Tuple{REDCap.Config,Any})

