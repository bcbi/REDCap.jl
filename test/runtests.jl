@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

using REDCap

include("RecordGenerator.jl")

super_config = REDCap.Config(get(ENV, "REDCAP_URL", ""), get(ENV, "REDCAP_SUPER_API", ""))
config = REDCap.Config(get(ENV, "REDCAP_URL", ""), get(ENV, "REDCAP_API", ""))

# -=: Test: Functionality :=- #
@testset "Import Functionality" begin
	#setup for any needed vars

	#=	TESTING:
	# needs to be able to manipulate a project, and verify what comes back. Create project in users environment? Dedicated test env?
	# Must: Create, Import, Export, make sure what you put in is what you got out, and delete everything properly.
	# Create: make a project from scratch using stock settings
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
	#config = create_project(super_config, "Test Project", 1; purpose_other="Testing REDCap.jl Functionality", project_notes="This is not an actual REDCap Database.", 
	#					is_longitudinal=1, surveys_enabled=1, record_autonumbering_enabled=1)


	#Importing- 
	#stock records
	stock_records=[record_generator(config, 1),
					record_generator(config, 2),
					record_generator(config, 3),
					record_generator(config, 4),
					record_generator(config, 5)]
	response = import_records(config, stock_records)

	@test response["count"] == length(stock_records)

	stock_user=[Dict("username" => "john_smith@email.com",
					 "email" => "john_smith@email.com",
					 "lastname" => "Smith")]
	response = import_users(config, stock_user)
	@test response == 1

	stock_proj_info=Dict("project_title" => "RC Test",
						 "project_notes" => "testing")
	response = import_project_information(config, stock_proj_info)
	@test response == length(stock_proj_info) || 23 #either the changed of all values idk...


	#Exporting - verify that data exported is accurate and in there(?)
	#Call functions in more varietyies of ways - show off options - export to file, verifiy file is there and can 
	#be grabbed, modified, and re-imported
	modules = [:(export_field_names(config)),
				:(export_metadata(config)),
				:(export_version(config)),
				#:(export_arms(config)),
				#:(export_events(config)),
				#:(export_pdf(config)),
				:(export_project(config))]
	for m in modules
		try #use carefully!
			eval(m)
			@test 1==1
		catch
			println("Failed - $m")
			@test 1==2
		end
	end

	#ex_users = export_users(config)
	#@test ex_users[2]["email"] == stock_user[1]["email"]

	ex_records = export_records(config)
	@test isequal(ex_records[1]["first_name"], stock_records[1]["first_name"])

	ex_info = export_project_information(config)
	@test ex_info["project_title"] == stock_proj_info["project_title"]

	#final_proj_info=Dict("project_title" => "RC Test",
	#				  	 "in_production" => "1")
	#import_project_information(config, final_proj_info)

	#get out of a lump function- make like 4-5 meaningful calls
<<<<<<< HEAD
=======
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
>>>>>>> d539066f5adac360f33eb83f6d52cb72e05930b4

	#testing for importing and record verifiyng



	#test deletion and project closure

end