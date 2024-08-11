using REDCap
using Test

test_sets = Dict(
	"Delete" => [
		:(delete_arms(arms)),
		:(delete_events(events)),
		:(delete_file(record, field, event)),
		:(delete_records(records)),
	],

	"Import" => [
		:(import_project_information(data)),
		:(import_metadata(data)),
		:(import_users(data)),
		:(import_arms(data)),
		:(import_events(data)),
		:(import_records(data)),
		:(import_instrument_event_mappings(data)),
		:(import_file(record, field, event, file)),
		:(create_project(project_title, purpose)),
	],

	"Export" => [
		     :(export_repeating_forms_and_events()),
		:(export_field_names()),
		:(export_instruments()),
		:(export_metadata()),
		:(export_project_information()),
		:(export_users()),
		:(export_version()),
		:(export_arms()),
		:(export_events()),
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
)

@testset "User-facing functions" begin
	for test_set_name in keys(test_sets)
		@testset "$test_set_name" begin
			for function_call in test_sets[test_set_name]
				@testset "$function_call" begin
					@test begin
						eval(function_call)
						true
					end
				end
			end
		end
	end
end
