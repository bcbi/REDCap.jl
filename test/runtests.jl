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
	"Metadata" => [
		:(import_metadata()),
		:(export_metadata()),
	],
	"REDCap" => [
		:(export_version()),
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
