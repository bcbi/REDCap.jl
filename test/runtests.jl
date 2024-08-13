using REDCap
using Test

test_sets = Dict(
	"Arms" => [
		:(delete_arms()),
		:(export_arms()),
		:(import_arms()),
	],
	"Data Access Groups" => [
		:(delete_DAGs()),
		:(export_DAGs()),
		:(export_user_DAG_assignment()),
		:(import_DAGs()),
		:(import_user_DAG_assignment()),
		:(switch_DAG()),
	],
	"Events" => [
		:(delete_events()),
		:(export_events()),
		:(import_events()),
	],
	"Field Names" => [
		:(export_list_of_export_field_names),
	],
	"Files" => [
		:(delete_file()),
		:(export_file()),
		:(import_file()),
	],
	"File Repository" => [
		:(create_new_folder()),
		:(delete_file_from_file_repository()),
		:(export_file_from_file_repository()),
		:(export_list_of_folders()),
		:(import_file_from_file_repository()),
	],
	"Instruments" => [
		:(export_instrument_event_mappings()),
		:(export_instruments()),
		:(export_PDF_of_instruments()),
		:(import_instrument_event_mappings()),
	],
	"logging" => [
		:(export_logging()),
	],
	"Metadata" => [
		:(import_metadata()),
		:(export_metadata()),
	],
	"Projects" => [
		:(create_new_project()),
		:(export_project_info()),
		:(export_project_XML()),
		:(import_project_info()),
	],
	"REDCap" => [
		:(export_version()),
	],
	"Records" => [
		:(delete_records()),
		:(export_records()),
		:(generate_next_record_name()),
		:(import_records()),
		:(rename_record()),
	],
	"Repeating Instruments and Events" => [
		:(export_repeating_instruments_and_events()),
		:(import_repeating_instruments_and_events()),
	],
	"Reports" => [
		:(export_reports()),
	],
	"Surveys" => [
		:(export_survey_link()),
		:(export_survey_participants()),
		:(export_survey_queue_link()),
		:(export_survey_return_code()),
	],
	"Users" => [
		:(export_users()),
		:(import_users()),
		:(delete_users()),
	],

	#=
	"Delete" => [
		:(delete_arms(arms)),
		:(delete_file(record, field, event)),
		:(delete_records(records)),
	],

	"Import" => [
		:(import_project_information(data)),
		:(import_users(data)),
		:(import_arms(data)),
		:(import_records(data)),
		:(import_instrument_event_mappings(data)),
		:(import_file(record, field, event, file)),
		:(create_project(project_title, purpose)),
	],

	"Export" => [
		     :(export_repeating_forms_and_events()),
		:(export_field_names()),
		:(export_instruments()),
		:(export_project_information()),
		:(export_users()),
		:(export_version()),
		:(export_arms()),
		:(export_pdf("./X.pdf")),
		:(export_project()),
		:(export_records()),
		:(export_survey_queue_link(record::String)),
		:(export_survey_return_code(record::String, instrument::String, event::String)),
		:(export_instrument_event_mappings()),
		:(export_survey_participant_list(instrument::String, event::String)),
		:(export_file(record::String, field::String, event::String)),
		:(export_report(report_id)),
		:(export_survey_link(record::String, instrument::String, event::String)),
	       ],
	       =#
)

@testset "API Methods" begin
	name_width = maximum(length.(keys(test_sets)))
	for method_type in keys(test_sets)
		for function_call in test_sets[method_type]
			@testset "$(rpad(method_type, name_width, '.')): $function_call" begin
				@test begin
					eval(function_call)
					true
				end
			end
		end
	end
end

nothing
