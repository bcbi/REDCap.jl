@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

using REDCap

config = ""
full_test=false
#Get keys from user environment
api_url=get(ENV, "REDCAP_URL", "")
if length(api_url)>0
	super_key=get(ENV, "REDCAP_SUPER_API", "")
	if length(super_key)>0
		full_test=true
		super_config = REDCap.Config(api_url, super_key)
	else
		warn("Cannot find REDCap Super API key in environment.")
		key=get(ENV, "REDCAP_API", "")
		if length(key)>0
			config = REDCap.Config(api_url, key)
		else
			@error("Cannot find REDCap API key in environment.")
		end
	end
else
	@error("Cannot find REDCap URL in environment.")	
end
			
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
	if full_test
		println("full test")
		#Creating
		#config = create_project(super_config, "Test Project", 1; purpose_other="Testing REDCap.jl Functionality", project_notes="This is not an actual REDCap Database.", 
		#					is_longitudinal=1, surveys_enabled=1, record_autonumbering_enabled=1)
	end

	#Importing- 
	#stock records
	stock_records=[Dict("sex" => "1",
					  "age" => "56",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "180",
					  "dob" => "1962-07-30",
					  "record_id" => "1",
					  "bmi" => "",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "JSmith@aol.com",
					  "first_name" => "John",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict("sex" => "1",
					  "age" => "16",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "190",
					  "dob" => "2002-07-30",
					  "record_id" => "2",
					  "bmi" => "",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "M_Smith@aol.com",
					  "first_name" => "Matthew",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "100",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict("sex" => "0",
					  "age" => "20",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "170",
					  "dob" => "1998-07-30",
					  "record_id" => "3",
					  "bmi" => "",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "MJ_Smith@aol.com",
					  "first_name" => "Mary",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict("sex" => "0",
					  "age" => "46",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "185",
					  "dob" => "1972-07-30",
					  "record_id" => "4",
					  "bmi" => "",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "L_Smith@aol.com",
					  "first_name" => "Lisa",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "90",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1")]


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
	@test response == length(stock_proj_info) || 23 #either the changed or all values idk...


	#Exporting - verify that data exported is accurate and in there(?)
	#Call functions in more varietyies of ways - show off options - export to file, verifiy file is there and can 
	#be grabbed, modified, and re-imported
	modules = [:(export_field_names(config)),
				:(export_records(config, format="csv")),
				:(export_records(config, format="xml")),
				:(export_records(config, format="odm")),
				:(export_records(config, fields=["record_id","first_name"])),
				:(export_metadata(config)),
				:(export_version(config)),
				#:(export_arms(config)),
				#:(export_events(config)),
				:(export_pdf(config, "export.pdf")),
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

	ex_records = export_records(config)
	@test isequal(ex_records[1]["first_name"], stock_records[1]["first_name"])

	ex_info = export_project_information(config)
	@test ex_info["project_title"] == stock_proj_info["project_title"]


	if full_test
		#final_proj_info=Dict("project_title" => "RC Production",
		#				  	 "in_production" => "1")
		#import_project_information(config, final_proj_info)

		#Do things to a production project you shouldnt do

	end

end