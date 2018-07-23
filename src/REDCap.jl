"""
	REDCap - 

Julia frontend for the REDCap API. Handles exporting, importing, and generation of 
project related information.
"""

module REDCap
#more modules?
using JSON
using LightXML
using HTTP
using Requests
using CSV

using DataStructures
using DataFrames

include("Config.jl")
include("Utils.jl")
include("Export.jl")
include("Import.jl")
include("Delete.jl")

export export_field_names
export export_instruments
export export_metadata
export export_project_information
export export_user
export export_version
export export_arms
export export_events
export export_pdf
export export_project
export export_records
export export_survey_queue_link
export export_survey_return_code
export export_instrument_event_mappings
export export_survey_participant_list
export export_file
export export_reports
export export_survey_link
export generate_next_record_id

#search records? 
#insert specific things into records (export current, replace with given value, and import/overwrite)?
#create default fields for users/metdata/info? Not records- useless in medical studies
include("../test/myTests.jl")
export record_generator #just so I can use it...

export import_project_information
export import_metadata
export import_user
export import_arms
export import_events
export import_records
export import_insrument_event_mappings
export import_file

export delete_arms
export delete_events
export delete_file
export delete_records

export create_project

end