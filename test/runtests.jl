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


end