demography_token = create_project(data = (project_title = "Basic Demography $(now())", purpose = 0), odm="data/project_files/BasicDemography.REDCap.xml")
field_names = export_list_of_export_field_names(token=demography_token, format=:json) |> JSON.parse .|> x -> x["export_field_name"]
@test field_names == [ "record_id"
        "first_name"
        "last_name"
        "address"
        "telephone"
        "email"
        "dob"
        "age"
        "ethnicity"
        "race"
        "sex"
        "height"
        "weight"
        "bmi"
        "comments"
        "demographics_complete"
       ]

import_records(token=demography_token,data=(record_id=1,first_name="A",last_name="Person"))
@test generate_next_record_name(token=demography_token) == "2"
for i in 2:10
	import_records(
	       token=demography_token,
		data=(
			record_id = generate_next_record_name(token=demography_token),
			first_name = "A",
			last_name = "NotherPerson"))
end
@test generate_next_record_name(token=demography_token) == "11"