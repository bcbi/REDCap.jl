using REDCap
using JSON
using Test
using Dates
using DataFrames

if (get(ENV, "REDCAP_API_URL", "")) |> isempty && (get(ENV, "REDCAP_API_TOKEN", "")) |> isempty
	@info("To run these tests, add values for REDCAP_API_URL and REDCAP_API_TOKEN to your Julia startup file")
	@test true
else

@test export_version() == "13.7.31"
#@test create_project(data="""[{"project_title":"My New REDCap Project","purpose":"0"}]""",format="json") |> REDCap.is_valid_token
#TODO: account for running test without token in ENV

#TODO: more tests like this, checking the API's return value
#=
write("users.csv", export_users(format=:csv))
import_users(data=read("small.json",String), format=:json, returnFormat=:xml)
import_users(data=Dict(:username => "userName"))
import_users(data="""[{"username":"userName"}]""", format=:json)
import_users(data="""username\naharris""", format=:csv)
=#

begin
	token = create_project(data=Dict(:project_title=>"$(now())",:purpose=>0))
	export_project_XML(token=token)
	export_project_info(token=token)

	export_metadata(token=token)


	@assert "1" == import_project_info(token=token,data=Dict(:project_title=>"$(now())",:purpose=>0))
	export_logging(token=token, format=:json) |>JSON.parse |> DataFrame

	import_users(token=token,format=:xml,data="""<?xml version="1.0" encoding="UTF-8" ?>
       <users>
          <item>
             <username>harrispa</username>
             <expiration>2015-12-07</expiration>
             <user_rights>1</user_rights>
             <design>0</design>
             <forms>
                <demographics>1</demographics>
                <day_3>2</day_3>
                <other>0</other>
             </forms>
             <forms_export>
                <demographics>1</demographics>
                <day_3>0</day_3>
                <other>2</other>
             </forms_export>
          </item>
       </users>""")

	CSV.read(export_users(format=:csv) |> IOBuffer, DataFrame )

	@test true
end

#TODO: Add sensible arguments and expected return values

#=
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
		:(create_folder()),
		:(delete_file_from_file_repository()),
		:(export_file_from_file_repository()),
		:(export_list_of_folders()),
		:(import_file_from_file_repository()),
	],
	"Instruments" => [
		:(export_instrument_event_mappings()),
		:(export_instruments()),
		:(export_PDF()),
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
		:(create_project()),
		:(export_project_info()),
		:(export_project_XML()),
		#:(import_project_info()),
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
	"User Roles" => [
	:(export_user_roles()),
	:(import_user_roles()),
	:(delete_user_roles()),
	:(export_user_role_assignment()),
	:(import_user_role_assignment()),
	],
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
=#

end
