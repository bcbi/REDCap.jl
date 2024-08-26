@test create_project(data = (project_title = "AAA", purpose = 1),format=:csv) ==
"ERROR: You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other)."

@test create_project(data = (project_title = "AAA", purpose = 1),format=:json) ==
"{\"error\":\"You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).\"}"

@test create_project(data = (project_title = "AAA", purpose = 1),format=:xml) ==
"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).</error></hash>"

@test create_project(data = (project_title = "AAA", purpose = 1)) ==
"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).</error></hash>"

@test "18" == 
import_project_info(token=project_token,data=(
project_title="ABCDEFG",
project_language="English",
purpose="Testing",
purpose_other="Other",
project_notes="NONE",
custom_record_label="Q",
secondary_unique_field="R",
is_longitudinal=true,
surveys_enabled="1",
scheduling_enabled=true,
record_autonumbering_enabled=true,
randomization_enabled=true,
project_irb_number=123456,
project_grant_number=123456,
project_pi_firstname="First",
project_pi_lastname="Last",
display_today_now_button=1,
bypass_branching_erase_field_prompt=1
),)

@test "18" == 
import_project_info(token=project_token,data=(
project_title="ABCDEFG",
project_language="English",
purpose="Testing",
purpose_other="Other",
project_notes="NONE",
custom_record_label="Q",
secondary_unique_field="R",
is_longitudinal=true,
surveys_enabled="1",
scheduling_enabled=true,
record_autonumbering_enabled=true,
randomization_enabled=true,
project_irb_number=123456,
project_grant_number=123456,
project_pi_firstname="First",
project_pi_lastname="Last",
display_today_now_button=1,
bypass_branching_erase_field_prompt=1
),format=:csv)

@test "18" == 
import_project_info(token=project_token,data=(
project_title="ABCDEFG",
project_language="English",
purpose="Testing",
purpose_other="Other",
project_notes="NONE",
custom_record_label="Q",
secondary_unique_field="R",
is_longitudinal=true,
surveys_enabled="1",
scheduling_enabled=true,
record_autonumbering_enabled=true,
randomization_enabled=true,
project_irb_number=123456,
project_grant_number=123456,
project_pi_firstname="First",
project_pi_lastname="Last",
display_today_now_button=1,
bypass_branching_erase_field_prompt=1
),format=:json)

@test "18" == 
import_project_info(token=project_token,data=(
project_title="ABCDEFG",
project_language="English",
purpose="Testing",
purpose_other="Other",
project_notes="NONE",
custom_record_label="Q",
secondary_unique_field="R",
is_longitudinal=true,
surveys_enabled="1",
scheduling_enabled=true,
record_autonumbering_enabled=true,
randomization_enabled=true,
project_irb_number=123456,
project_grant_number=123456,
project_pi_firstname="First",
project_pi_lastname="Last",
display_today_now_button=1,
bypass_branching_erase_field_prompt=1
),format=:xml)

@test export_project_info(token=project_token) |> JSON.parse |> x -> x["custom_record_label"] == "Q"
@test export_project_info(token=project_token,format=:csv) |> JSON.parse |> x -> x["custom_record_label"] == "Q"
@test export_project_info(token=project_token,format=:json) |> JSON.parse |> x -> x["custom_record_label"] == "Q"
@test export_project_info(token=project_token,format=:xml) |> JSON.parse |> x -> x["custom_record_label"] == "Q"

export_project_info(token=project_token) 


import_project_info(token=project_token,data=(project_title="NEWNAME"),format=:csv)
@test export_project_info(token=project_token,format=:json) |> JSON.parse |> x -> x["project_title"] == "NEWNAME"

