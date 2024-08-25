@test_throws UndefKeywordError create_project()

@test create_project(data = (project_title = "AAA", purpose = 1),format=:csv) ==
"ERROR: You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other)."

@test create_project(data = (project_title = "AAA", purpose = 1),format=:json) ==
"{\"error\":\"You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).\"}"

@test create_project(data = (project_title = "AAA", purpose = 1),format=:xml) ==
"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).</error></hash>"

@test create_project(data = (project_title = "AAA", purpose = 1)) ==
"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>You must provide some text for 'purpose_other' since you specified 'purpose' as '1' (Other).</error></hash>"


