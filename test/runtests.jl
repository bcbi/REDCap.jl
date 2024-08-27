using REDCap
using JSON
using Test
using Dates
using DataFrames

#TODO: I have to rewrite these tests...
# I can't just use a tempname, since the file handle gets parsed...
# Maybe just add a method definition for file handles?
# Is it bad practice to parse strings that way?
#TODO: ensure tests are run from a certain directory?

function run_all_tests()

list_of_test_files = []
function all_subfiles(dir)
	contents = readdir(dir, join=true)
	for file in contents[@. !isdir(contents)]
		if endswith(file, ".jl"); push!(list_of_test_files, file) end
	end
	for subdirectory in contents[@. isdir(contents)]
		all_subfiles(subdirectory)
	end
end
all_subfiles("test_files")

@testset verbose=true "Full testset" begin
	for test_file in list_of_test_files
		@testset "$test_file" begin
			begin
				global file_name, file_handle
				include(test_file)
			end
		end
	end
end

#=
write("users.csv", export_users(format=:csv))
import_users(data=read("small.json",String), format=:json, returnFormat=:xml)
import_users(data=Dict(:username => "userName"))
import_users(data="""[{"username":"userName"}]""", format=:json)
import_users(data="""username\naharris""", format=:csv)
=#


	#export_project_XML(token=project_token)
	#export_project_info(token=project_token)

	#export_metadata(token=project_token)

	#@assert "1" == import_project_info(token=project_token,data=(project_title="$(now())",purpose=0))

	#TODO: for CSV inputs, use triple quotes, and add a comma at the end if the last inner character is also a quote
	# Can this always be done, or only when the last column is blank?
#=
	import_DAGs(token=project_token,format=:csv,data="""data_access_group_name,unique_group_name
       "CA Site",
       "FL Site",
       "New Site",""")

	import_users(token=project_token,format=:xml,data="""<?xml version="1.0" encoding="UTF-8" ?>
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
=#

	#CSV.read(export_users(format=:csv) |> IOBuffer, DataFrame )

end

if (get(ENV, "REDCAP_API_URL", "")) |> isempty && (get(ENV, "REDCAP_API_TOKEN", "")) |> isempty
	@info("To run these tests, add values for REDCAP_API_URL and REDCAP_API_TOKEN to your Julia startup file")
	@test true
else
	const project_token = create_project(data=(project_title="$(now())",purpose=0))
	const file_name = tempname() |> touch
	const file_handle = open(file_name, "w+")
	run_all_tests()
end


