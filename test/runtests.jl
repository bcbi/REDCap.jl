using REDCap
using JSON
include("../src/Utils.jl")
include("RecordGenerator.jl")

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
#@test 1 == 2


function test_new_record(config::Config, numRecords)
	id = generate_next_record_id(config)
	records = Array{Any}(numRecords)
	for i in 1:numRecords
		records[i] = record_generator(config, id)
		#println(i)
		id+=1
	end
	return records
end

function test_new_record2(config::Config, numRecords)
	id = generate_next_record_id(config)
	records = Array{Dict}(numRecords)
	for i in 1:numRecords
		records[i] = record_generator(config, id; mode="other")
		#println(i)
		id+=1
	end
	#println(records);
	for record in records
		for (k, v) in record
			#println("$k => $v")
		end
		#println()
		#println(JSON.json(record))
	end
	#println(JSON.json(records))
end

function test_export_method1(config::Config)
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
	println(export_survey_link(config, "1", "demographics", "1", "1"))
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
	println(export_survey_link(config, "1", "demographics", "1", "1"))
	#println(export_survey_queue_link(config, "1"))
	#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
	#println(export_instrument_event_mappings(config))
	println(export_survey_participant_list(config, "demographics", "1", format="xml", returnFormat="xml"))
	#println(export_file(config))
	#println(export_reports(config))
	=#
	#=
	println("TEST 3 - CSV")
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
	println(export_survey_link(config, "1", "demographics", "1", "1"))
	#println(export_survey_queue_link(config, "1"))
	#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
	#println(export_instrument_event_mappings(config))
	println(export_survey_participant_list(config, "demographics", "1", format="csv", returnFormat="csv"))
	#println(export_file(config))
	#println(export_reports(config))
	=#
end

function test_import_method1(config::Config, config2::Config)
	record = export_records(config)
	println(record)
	for i in record
		for (k, v) in i
			println("$k => $v")
		    i[k]="x"
		end
	end
	println(record)
	println(import_records(config, record))
	println(export_records(config))
	#println(import_project_information(config, information))
end

function test_import_method2(config::Config)
	records = test_new_record(config, 10)
	println(records); println(typeof(records))
	println()
	println(JSON.json(records)); println(typeof(JSON.json(records)))

	println(import_records(config, records))
	println(import_records(config, JSON.json(records)))
end

function test_user(config::Config)
	user = export_user(config)
	println(user); println(user[1])
end


function test_modules(testNum; param1="", param2="", param3="")
	APIconfig = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "ADC4B222E6AC5116953F53F04960C712")
	APIconfig2 = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "AE97D783DD911DC78FA54EA1F6A6A2BD")
	if testNum==1
		println(test_new_record(APIconfig, 5))

	elseif testNum==2
		test_new_record2(APIconfig, 5)

	elseif testNum==3
		test_export_method1(APIconfig)

	elseif testNum==4
		test_import_method1(APIconfig, APIconfig2)

	elseif testNum==5
		test_import_method2(APIconfig)

	elseif testNum==6
		test_user(APIconfig)
	
	else

	end
end

function run_test(testNum)
	#actually holds a massive for loop to run alltests, tell who failed
	test_modules(testNum)
end