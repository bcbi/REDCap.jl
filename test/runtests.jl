using REDCap

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
#@test 1 == 2



# -=: Test: Functionality :=- #
@testset "Functionality" begin
	#setup for any needed vars
	config = SuperConfig("url", "skey")
	
	r = HTTP.get(config.url)
	@test r.status == 200

	@test 1 == 1 #will fail if this throws an error- write tests for Bool vals

	#=
	#	TESTING:
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
	# 
	=#
	modules = [:(run_test(7)),
			   :(run_test(1)),
			   :(run_test(2)),]
	passed = true
	for i in modules
		@test eval(i)==true
	end










end