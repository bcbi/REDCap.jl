using REDCap

#REDCap.get_redcap_superuser_config();
#REDCap.get_redcap_user_config();

function_calls = [
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
       ]

@testset "Export" begin
	for fc in function_calls
		@testset "$fc" begin
			eval(fc)
			@test true
		end
	end
end
nothing


