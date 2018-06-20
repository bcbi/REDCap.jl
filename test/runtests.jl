using REDCap
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
#@test 1 == 2


function testImport(config::Config)
	#print(importRecords(config))
	print(importRecords(config, exportRecords(config; format="csv", returnFormat="csv"); format="csv"))
	#print(importRecords(config; format="xml"))
	
end


function testCrossImport(config::Config, config2::Config)
	#print(importRecords(config))
	print(importRecords(config2, exportRecords(config; format="csv", returnFormat="csv"); format="csv"))
	#print(importRecords(config; format="xml"))
	
end


function testExport(config::Config)
	print(exportRecords(config))
	print(exportRecords(config; format="csv", returnFormat="csv"))
	print(exportRecords(config; format="xml", returnFormat="xml"))
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
	importRecords(config, exportRecords(config))
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
	APIconfig2 = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "AE97D783DD911DC78FA54EA1F6A6A2BD")
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

	elseif testNum==12
		testCrossImport(APIconfig, APIconfig2)

	else

	end
end