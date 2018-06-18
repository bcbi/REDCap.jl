function testImport()
	testRecord = ("record_id" => "0",
				"first_name" => "Cory",
				"last_name" => "Cothrum",
				"address" => "335 Harrington Ave. Warwick RI 02888",
				"telephone" => "401-338-8369",
				"email" => "cory_cothrum@brown.edu",
				"dob" => "12-14-92",
				"age" => 25,
				"height" => 187.96,
				"weight" => 99,
				"bmi" => 28.2,
				"comments" => "self")
				
	config = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "ADC4B222E6AC5116953F53F04960C712")

	importRecord(config, testRecord)
end


function testExport()
	config = Config("https://redcap.cis-dev.brown.edu/redcap/api/", "ADC4B222E6AC5116953F53F04960C712")
	
	exportRecord(config)
end