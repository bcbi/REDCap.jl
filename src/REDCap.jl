"""
	REDCap - 

Julia frontend for the REDCap API. Handles exporting, importing, and generation of 
project related information.
"""

module REDCap
using JSON
using LightXML
using HTTP
using CSV

using DataStructures
using DataFrames

include("Config.jl")
include("Utils.jl")
include("Export.jl")
include("Import.jl")
include("Delete.jl")

export export_field_names,
	export_instruments,
	export_metadata,
	export_project_information,
	export_user,
	export_version,
	export_arms,
	export_events,
	export_pdf,
	export_project,
	export_records,
	export_survey_queue_link,
	export_survey_return_code,
	export_instrument_event_mappings,
	export_survey_participant_list,
	export_file,
	export_reports,
	export_survey_link,
	generate_next_record_id,

	import_project_information,
	import_metadata,
	import_user,
	import_arms,
	import_events,
	import_records,
	import_insrument_event_mappings,
	import_file,

	delete_arms,
	delete_events,
	delete_file,
	delete_records,

	create_project

#search records? 
#insert specific things into records (export current, replace with given value, and import/overwrite)?
#create default fields for users/metdata/info? Not records- useless in medical studies
include("../test/myTests.jl")
export record_generator #just so I can use it...


end