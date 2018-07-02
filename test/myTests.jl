using REDCap
using JSON
include("../src/Utils.jl")
include("RecordGenerator.jl")

function test_new_record(config::Config, numRecords)
	#id = generate_next_record_id(config)
	id = "x"
	records = Array{Any}(numRecords)
	for i in 1:numRecords
		records[i] = record_generator(config, id)
		#println(i)
		#id+=1
	end
	return records
end

function test_new_record2(config::Config, numRecords)
	#id = generate_next_record_id(config)
	id = "x"
	records = Array{Dict}(numRecords)
	for i in 1:numRecords
		records[i] = record_generator(config, id; mode="socialdata")
		#println(i)
		#id+=1
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
	println(export_survey_link(config, 1, "demographics", "1", 1))
	#println(export_survey_queue_link(config, "1"))
	#println(export_survey_return_code(config, "1", "demographics", "1", "1"))
	#println(export_instrument_event_mappings(config))
	println(export_survey_participant_list(config, "demographics", "1"))
	#println(export_file(config))
	#println(export_reports(config))
	=#
	
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
	println(export_survey_link(config, 1, "demographics", "1", 1))
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
	println("printing record:")
	println(record)
	println(import_records(config, record))
	println(export_records(config))
	#println(import_project_information(config, information))
end

function test_import_method2(config::Config)
	records = test_new_record(config, 10)
	println(records); println(typeof(records))
	println()
	#println(JSON.json(records)); println(typeof(JSON.json(records)))

	println(import_records(config, records, format="csv"))
	#println(import_records(config, JSON.json(records)))
end

function test_import_method3(config::Config; format="json")
	record = export_records(config, format=format)
	println(record); println(typeof(record));
	println(import_records(config, record, format=format))
end

function test_user(config::Config)
	user = export_user(config)
	println(user); println(user[1])
end

function test_eval()
	println("This is evaluating, just like you told me to!")
	return true
end

function test_modules(testNum; param1="", param2="", param3="")
	APIconfig = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "ADC4B222E6AC5116953F53F04960C712")
	APIconfig2 = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "AE97D783DD911DC78FA54EA1F6A6A2BD")
	if testNum==1
<<<<<<< HEAD
		output = test_new_record(APIconfig, 50)
=======
		output = test_new_record(APIconfig, 5)
>>>>>>> 3bd792fc6e3e407dfbaac6cb50a89ba2f8984541
		println(JSON.json(output))
		# #Journal Entry 1
		#= THIS IS WHAT IT WANTS, RIGHT HERE- The array of Dicts, outputted into a JSON builder. Thats it, right there.
		#	"Not JSON formatted - must be an array [{ ... }]""
		#  when I show this to POSTman and ask him to bring it manually, he does and it works just fine! Just takes it! Throws nitpicking errors on formatting!
		#  Solutions- abandon json, use xml or csv. Problem- xml is weird to build- just fine to parse though.
		#	json is really common and preffered though, and its bugging me intensely.
		#	If I try to force this into a string, it also says "Not JSON formatted - must be an array [{ ... }]"
		#	If I try to just JSON everything I throw at it, it goes "lol no access" because now it can't find the api-key.
			[
				{"sex":"1",
				"age":"63",
				"address":"69 Providence Ave. West Warwick RI 02826",
				"height":"228.0",
				"dob":"1954-09-06",
				"record_id":"x",
				"bmi":"38.0",
				"comments":"Randomly Generated - Demographics",
				"email":"Kenneth_Wong54@aol.com",
				"first_name":"Kenneth",
				"telephone":"5088497862",
				"weight":"198.0",
				"ethnicity":"2",
				"last_name":"Wong",
				"race":"2"},

				{"sex":"1",
				"age":"49",
				"address":"221 Wright Blvd. East Providence RI 02885",
				"height":"188.0",
				"dob":"1968-11-09",
				"record_id":"x",
				"bmi":"53.0",
				"comments":"Randomly Generated - Demographics",
				"email":"D_Hill@msn.com",
				"first_name":"David",
				"telephone":"4014055857",
				"weight":"188.0",
				"ethnicity":"1",
				"last_name":"Hill",
				"race":"5"},

				{"sex":"0",
				"age":"7",
				"address":"150 Hill Ave. Somerville MA 01255",
				"height":"197.0",
				"dob":"2010-09-16",
				"record_id":"x",
				"bmi":"15.0",
				"comments":"Randomly Generated - Demographics",
				"email":"J_Patel10@outlook.com",
				"first_name":"Joan",
				"telephone":"6179606009",
				"weight":"59.0",
				"ethnicity":"2",
				"last_name":"Patel",
				"race":"6"},

				{"sex":"1",
				"age":"32",
				"address":"120 Taylor Ln. Pawtucket RI 02830",
				"height":"139.0",
				"dob":"1985-07-07",
				"record_id":"x",
				"bmi":"57.0",
				"comments":"Randomly Generated - Demographics",
				"email":"M_John85@iCloud.com",
				"first_name":"Mark",
				"telephone":"5083652189",
				"weight":"111.0",
				"ethnicity":"2",
				"last_name":"John",
				"race":"1"},

				{"sex":"0",
				"age":"5",
				"address":"60 View Blvd. Newton MA 02054",
				"height":"204.0",
				"dob":"2013-04-19",
				"record_id":"x",
				"bmi":"18.0",
				"comments":"Randomly Generated - Demographics",
				"email":"JudithLi@gmail.com",
				"first_name":"Judith",
				"telephone":"4012435788",
				"weight":"78.0",
				"ethnicity":"2",
				"last_name":"Li",
				"race":"3"}
			]

		=#
		return true

	elseif testNum==2
		test_new_record2(APIconfig, 5)
		return true

	elseif testNum==3
		test_export_method1(APIconfig)

	elseif testNum==4
		test_import_method1(APIconfig, APIconfig2)

	elseif testNum==5
		test_import_method2(APIconfig)

	elseif testNum==6
		test_user(APIconfig)
	
	elseif testNum==7
		test_eval()

	elseif testNum==8
			modules = [:(run_test(7)),
				   :(run_test(1)),
				   :(run_test(7)),
				   :(run_test(2)),]
		passed = true
		for i in modules
			eval(i)
		end
	elseif testNum==9
		test_import_method3(APIconfig, format=param1)
	elseif testNum==10
	
	elseif testNum==11 #these tests go to 11...
	
	else

	end
end

<<<<<<< HEAD
function run_test(testNum; param1="x")
=======
function run_test(testNum, param1)
>>>>>>> 3bd792fc6e3e407dfbaac6cb50a89ba2f8984541
	#actually holds a massive for loop to run alltests, tell who failed
	test_modules(testNum, param1=param1)
end
