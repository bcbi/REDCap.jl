function generate_project_information()
	#must build out a dict of field info, and send it to the importer, who formats it. 
	#= -example
		{
		"project_id":"18",
		"project_title":"Test-proj",
		"creation_time":"2018-06-11 15:08:22",
		"production_time":"",
		"in_production":"0",
		"project_language":"English",
		"purpose":"0",
		"purpose_other":"",
		"project_notes":"Cory CIS",
		"custom_record_label":"",
		"secondary_unique_field":"",
		"is_longitudinal":0,
		"surveys_enabled":"1",
		"scheduling_enabled":"0",
		"record_autonumbering_enabled":"1",
		"randomization_enabled":"0",
		"ddp_enabled":"0",
		"project_irb_number":"",
		"project_grant_number":"",
		"project_pi_firstname":"",
		"project_pi_lastname":"",
		"display_today_now_button":"1",
		"has_repeating_instruments_or_events":0
		}
	=#

end


function generate_metadata()
	#must build out a dict of metadata, and send it to the importer, who formats it. 
	#= -example
		{"field_name":"record_id",
		"form_name":"demographics",
		"section_header":"",
		"field_type":"text",
		"field_label":"Study ID",
		"select_choices_or_calculations":"",
		"field_note":"",
		"text_validation_type_or_show_slider_number":"",
		"text_validation_min":"",
		"text_validation_max":"",
		"identifier":"",
		"branching_logic":"",
		"required_field":"",
		"custom_alignment":"","question_number":"","matrix_group_name":"",
		"matrix_ranking":"",
		"field_annotation":""
		},
		{
		"field_name":"first_name",
		"form_name":"demographics",
		"section_header":"Contact Information",
		"field_type":"text",
		"field_label":"First Name",
		"select_choices_or_calculations":"",
		"field_note":"",
		"text_validation_type_or_show_slider_number":"",
		"text_validation_min":"",
		"text_validation_max":"",
		"identifier":"y",
		"branching_logic":"",
		"required_field":"",
		"custom_alignment":"",
		"question_number":"",
		"matrix_group_name":"",
		"matrix_ranking":"",
		"field_annotation":""
		},
		{
		"field_name":"last_name",
		"form_name":"demographics",
		"section_header":"",
		"field_type":"text",
		"field_label"
		}
		###WHY THREE???
	=#

end


function generate_user()
	#must build out a dict of user info, and send it to the importer, who formats it. 
	#= -example

	=#

end


function generate_arms()
	#must build out a dict of arms, and send it to the importer, who formats it. 
	#= -example

	=#

end


function generate_events()
	#must build out a dict of event info, and send it to the importer, who formats it. 
	#= -example

	=#

end


function generate_records()
	#must build out a dict of record info, and send it to the importer, who formats it. 
	#= -example
		{
		"record_id":GenerateNextRecordID(),
		"sex":"1",
		"age":"39",
		"address":"123 Fake St. Providence RI 02895",
		"height":"172.96",
		"dob":"1978-07-08",
		"bmi":"26.7",
		"comments":"",
		"email":"JohnSmith78@gmail.com",
		"first_name":"John",
		"demographics_complete":"2",
		"telephone":"(401) 888-9956",
		"weight":"80",
		"last_name":"Smith",
		"ethnicity":"2",
		"race":"4"
		}
	=#

end


function generate_instrument_event_mappings()
	#must build out a dict of event-field mappings info, and send it to the importer, who formats it. 
	#= -example

	=#

end


function generate_file()
	#this could probably be replaced by a cat photo or something, but
	#must build out a basic file, and send it to the importer. 
	#= -example

	=#

end