```@meta
CurrentModule = REDCap
```
# REDCap
```@contents
```

## Overview

A Julia frontend for the REDCap API. REDCap.jl supports both importing and exporting records, as well as deletion from the REDCap Database. It also includes functions for surveys and report generation. 

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
