"""
	REDCap - 

Julia frontend for the REDCap API. 
Handles exporting, importing, and generation of project related information. 
Must have a valid config object set up with the chosen API key and url.
"""
module REDCap

using HTTP
using JSON
using LightXML
<<<<<<< HEAD
=======
using HTTP
using Requests
>>>>>>> d539066f5adac360f33eb83f6d52cb72e05930b4
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
	export_users,
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
	import_users,
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

end