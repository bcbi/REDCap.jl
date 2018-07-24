@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

using REDCap

const REDCap_API = get(ENV, "REDCAP_API", "")
const REDCap_URL = get(ENV, "REDCAP_URL", "")

# -=: Test: Functionality :=- #
@testset "Functionality" begin
	#setup for any needed vars
	config = Config(REDCap_URL, REDCap_API)
	
	r = HTTP.get(config.url)
	@test r.status == 200

	#=	TESTING:
	# needs to be able to manipulate a project, and verify what comes back. Create project in users environment? Dedicated test env?
	# Must: Create, Import, Export, make sure what you put in is what you got out, and delete everything properly.
	# Create: make a project from scratch using stock settings- can just be a premade dict.
	# Import: Make (and save) a bunch of generic constructions for fields, metadata, records, everything that can be imported- 
	# 	After, lock the project/make it as 'out of development' and try to re-import everything that-
	#	should be blocked once out of dev in REDCap.
	# Export: grab everything from the project and verify it matches the generated data perfectly- 
	#	also check any files and the pdf and xml of project.
	# Delete: Delete everything from the project piece by piece, and finally the project-
	# 	Verify everything, and try to export from it again.
	#
	# Have a file that contains ~40 example records, and all testing data needed? Not include generators? Space vs. complexity
	# 
	=#
	
	#Creating
	#project_config = create_project(super_config, "Test Project", 1; purpose_other="Testing REDCap.jl Functionality", project_notes="This is not an actual REDCap Database.", 
	#					is_longitudinal=1, surveys_enabled=1, record_autonumbering_enabled=1)


	#Importing- 
	#Make ~10 records, verify matches.

	id = generate_next_record_id(config)
	records = Array{Any}(10)
	for i in 1:length(records)
		records[i] = record_generator(config, id)
		id+=1
	end
	response = import_records(config, records)
	println(response); println(get(response, "count", "x"))

	@test response["count"] == length(records)




	#Exporting - verify that data exported is accurate and in there(?)
	#Call functions in more varietyies of ways - show off options - export to file, verifiy file is there and can 
	#be grabbed, modified, and re-imported

	#get out of a lump function- make like 4-5 meaningful calls
	function test_export_methods(config::Config)
		#=
		println("TEST 1 - Press X to JSON")
		println(export_field_names(config))
		println(export_instruments(config))
		println(export_metadata(config))
		println(export_project_information(config))
		println(export_user(config))
		println(export_version(config))
		#println(export_arms(config))
		#println(export_events(config))
		println(export_pdf(config))
		println(export_project(config))
		println(export_records(config))
		println(export_survey_link(config, 1, "demographics", "1", 1))
		#println(export_survey_queue_link(config, "1"))
		#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
		#println(export_instrument_event_mappings(config))
		println(export_survey_participant_list(config, "demographics", "1"))
		#println(export_file(config))
		#println(export_reports(config))
		=#
		#=
		println("TEST 2 - XML")
		println(export_field_names(config, format="xml"))
		println(export_instruments(config, format="xml"))
		println(export_metadata(config, format="xml"))
		println(export_project_information(config, format="xml", returnFormat="xml"))
		println(export_user(config, format="xml", returnFormat="xml"))
		println(export_version(config, format="xml", returnFormat="xml"))
		#println(export_arms(config))
		#println(export_events(config))
		println(export_pdf(config))
		println(export_project(config))
		println(export_records(config, format="xml"))
		println(export_survey_link(config, 1, "demographics", "1", 1))
		#println(export_survey_queue_link(config, "1"))
		#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
		#println(export_instrument_event_mappings(config))
		println(export_survey_participant_list(config, "demographics", "1", format="xml", returnFormat="xml"))
		#println(export_file(config))
		#println(export_reports(config))
		=#
		
		println("TEST 3 - CSV")
		#=
		println(export_field_names(config, format="csv"))
		println(export_instruments(config, format="csv"))
		println(export_metadata(config, format="csv"))
		println(export_project_information(config, format="csv", returnFormat="csv"))
		println(export_user(config, format="csv", returnFormat="csv"))
		println(export_version(config, format="csv", returnFormat="csv"))
		#println(export_arms(config))
		#println(export_events(config))
		println(export_pdf(config))
		println(export_project(config))
		println(export_records(config, format="csv"))
		=#
		println(export_records(config, format="csv"))
		println(typeof(export_records(config, format="csv")))
		println("Saving"); CSV.write("~/gitHub/REDCap.jl/csvout.txt", export_records(config, format="csv"))
		println(export_survey_link(config, 1, "demographics", "1", 1))
		#println(export_survey_queue_link(config, "1"))
		#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
		#println(export_instrument_event_mappings(config))
		println(export_survey_participant_list(config, "demographics", "1", format="csv", returnFormat="csv"))
		#println(export_file(config))
		#println(export_reports(config))
		
	end

	#testing for importing and record verifiyng



	#test deletion and project closure

end