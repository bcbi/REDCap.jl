module REDCap

using HTTP
using JSON
using LightXML
using CSV
using DataStructures
using DataFrames

include("Utils.jl")
include("metadata.jl")

export redcap_api,
	export_metadata,
	import_metadata
	#export_field_names,
	#export_instruments,
	#export_project_information,
	#export_users,
	#export_repeating_forms_and_events,
	#export_version,
	#export_arms,
	#export_events,
	#export_pdf,
	#export_project,
	#export_records,
	#export_survey_queue_link,
	#export_survey_return_code,
	#export_instrument_event_mappings,
	#export_survey_participant_list,
	#export_file,
	#export_report,
	#export_survey_link,
	#generate_next_record_id,

	#import_project_information,
	#import_users,
	#import_arms,
	#import_events,
	#import_records,
	#import_instrument_event_mappings,
	#import_file,

	#delete_arms,
	#delete_events,
	#delete_file,
	#delete_records,

	#create_project

end
