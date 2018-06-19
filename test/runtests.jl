using REDCap
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
#@test 1 == 2


function testImports(config::Config)
	data = """[{"sex":"1","age":"39","address":"123 Fake St. Providence RI 02895",
			"height":"172.96","dob":"1978-07-08","record_id":3,
			"bmi":"26.7","comments":"","email":"JohnSmith78@gmail.com",
			"first_name":"colby","demographics_complete":"2","telephone":"(401) 888-9956",
			"weight":"80","last_name":"Smith","ethnicity":"2","race":"4"},{"sex":"1","age":"25","address":"335 Harrington Ave. Warwick RI 02888",
			"height":"187.96","dob":"1992-12-14","record_id":4,"bmi":"28",
			"comments":"self","email":"Cory_Cothrum@brown.edu","first_name":"mark",
			"demographics_complete":"1","telephone":"(401) 338-8369",
			"weight":"99","last_name":"Cothrum","ethnicity":"1","race":"4"}]"""
	importRecords(config, data)
end


function testExports(config::Config)
	record = exportRecords(config)
	print(record)
end

function testExportFieldNames(config::Config)
	fieldNames=exportFieldNames(config)
	for fieldSet in fieldNames
		for fields in fieldSet
			println(fields)
		end
	end
end

function testImEx(config::Config)
	record=exportRecords(config)
	#record[1]["first_name"]="colby"; record[1]["record_id"]=3
	#record[2]["first_name"]="mark"; record[2]["record_id"]=4
	#record=[{"sex":"1","age":"39","address":"123 Fake St. Providence RI 02895","height":"172.96","dob":"1978-07-08","record_id":3,"bmi":"26.7","comments":"","email":"JohnSmith78@gmail.com","first_name":"colby","demographics_complete":"2","telephone":"(401) 888-9956","weight":"80","last_name":"Smith","ethnicity":"2","race":"4"},{"sex":"1","age":"25","address":"335 Harrington Ave. Warwick RI 02888","height":"187.96","dob":"1992-12-14","record_id":4,"bmi":"28","comments":"self","email":"Cory_Cothrum@brown.edu","first_name":"mark","demographics_complete":"1","telephone":"(401) 338-8369","weight":"99","last_name":"Cothrum","ethnicity":"1","race":"4"}]

	importRecords(config, record)
end

function testExportArms(config::Config)
	print(exportArms(config))
end

function testExportUser(config::Config)
	print(exportUser(config))
end

function testExportVersion(config::Config)
	print(exportVersion(config))
end	

function testNextRecordNum(config::Config)
	print(generateNextRecordID(config))
end

function testExportPDF(config::Config)
	print(exportPDF(config; allRecords=true))
end

function testExportSurveyLink(config::Config)
	print(exportSurveyLink(config, 1, "demographics", 1, 1))
end

function testExportMetadata(config::Config)
	print(exportMetadata(config))
end


function runTest(testNum; param1="", param2="", param3="")
	APIconfig = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "ADC4B222E6AC5116953F53F04960C712")
	if testNum==1
		testExport(APIconfig)

	elseif testNum==2
		testImport(APIconfig)

	elseif testNum==3
		testImEx(APIconfig)

	elseif testNum==4
		testExportFieldNames(APIconfig)

	elseif testNum==5
		testExportArms(APIconfig)

	elseif testNum==6
		testExportUser(APIconfig)

	elseif testNum==7
		testExportVersion(APIconfig)

	elseif testNum==8
		testNextRecordNum(APIconfig)

	elseif testNum==9
		testExportPDF(APIconfig)

	elseif testNum==10
		testExportSurveyLink(APIconfig)

	elseif testNum==11
		testExportMetadata(APIconfig)

	else

	end
end