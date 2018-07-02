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



#=
#Field Names-
[{"original_field_name":"record_id","choice_value":"","export_field_name":"record_id"},{"original_field_name":"first_name","choice_value":"","export_field_name":"first_name"},{"original_field_name":"last_name","choice_value":"","export_field_name":"last_name"},{"original_field_name":"address","choice_value":"","export_field_name":"address"},{"original_field_name":"telephone","choice_value":"","export_field_name":"telephone"},{"original_field_name":"email","choice_value":"","export_field_name":"email"},{"original_field_name":"dob","choice_value":"","export_field_name":"dob"},{"original_field_name":"age","choice_value":"","export_field_name":"age"},{"original_field_name":"ethnicity","choice_value":"","export_field_name":"ethnicity"},{"original_field_name":"race","choice_value":"","export_field_name":"race"},{"original_field_name":"sex","choice_value":"","export_field_name":"sex"},{"original_field_name":"height","choice_value":"","export_field_name":"height"},{"original_field_name":"weigh

#Instruments
[{"instrument_name":"demographics","instrument_label":"Basic Demography Form"}]"""

#Metadata
[{"field_name":"record_id","form_name":"demographics","section_header":"","field_type":"text","field_label":"Study ID","select_choices_or_calculations":"","field_note":"","text_validation_type_or_show_slider_number":"","text_validation_min":"","text_validation_max":"","identifier":"","branching_logic":"","required_field":"","custom_alignment":"","question_number":"","matrix_group_name":"","matrix_ranking":"","field_annotation":""},
{"field_name":"first_name","form_name":"demographics","section_header":"Contact Information","field_type":"text","field_label":"First Name","select_choices_or_calculations":"","field_note":"","text_validation_type_or_show_slider_number":"","text_validation_min":"","text_validation_max":"","identifier":"y","branching_logic":"","required_field":"","custom_alignment":"","question_number":"","matrix_group_name":"","matrix_ranking":"","field_annotation":""},
{"field_name":"last_name","form_name":"demographics","section_header":"","field_type":"text","field_label"

#Project Info
{"project_id":"18","project_title":"Test-proj","creation_time":"2018-06-11 15:08:22","production_time":"","in_production":"0","project_language":"English","purpose":"0","purpose_other":"","project_notes":"Cory CIS","custom_record_label":"","secondary_unique_field":"","is_longitudinal":0,"surveys_enabled":"1","scheduling_enabled":"0","record_autonumbering_enabled":"1","randomization_enabled":"0","ddp_enabled":"0","project_irb_number":"","project_grant_number":"","project_pi_firstname":"","project_pi_lastname":"","display_today_now_button":"1","has_repeating_instruments_or_events":0}"""

#User
[{"username":"cory_cothrum@brown.edu","email":"cory_cothrum@brown.edu","firstname":"","lastname":"","expiration":"","data_access_group":"","data_access_group_id":"","design":"1","user_rights":"1","data_access_groups":"1","data_export":"1","reports":"1","stats_and_charts":"1","manage_survey_participants":"1","calendar":"1","data_import_tool":"1","data_comparison_tool":"1","logging":"1","file_repository":"1","data_quality_create":"1","data_quality_execute":"1","api_export":"1","api_import":"1","mobile_app":"1","mobile_app_download_data":"1","record_create":"1","record_rename":"1","record_delete":"1","lock_records_all_forms":"0","lock_records":"0","lock_records_customization":"0","forms":{"demographics":"1"}},{"username":"fernando_gelin@brown.edu","email":"fernando_gelin@brown.edu","firstname":"","lastname":"","expiration":"","data_access_group":"","data_access_group_id":"","design":"1","user_rights":"1","data_access_groups":"1","data_export":"1","reports":"1","stats_and_charts":"1","mana

#NO ARMS - not long


#NO EVENTS - not long

#Record
[{"record_id":"1","first_name":"John","last_name":"Smith","address":"123 Fake St. Providence RI 02895","telephone":"(401) 888-9956","email":"JohnSmith78@gmail.com","dob":"1978-07-08","age":"39","ethnicity":"2","race":"4","sex":"1","height":"172.96","weight":"80","bmi":"26.7","comments":"","demographics_complete":"2"},{"record_id":"2","first_name":"Cory","last_name":"Cothrum","address":"335 Harrington Ave. Warwick RI 02888","telephone":"(401) 338-8369","email":"Cory_Cothrum@brown.edu","dob":"1992-12-14","age":"25","ethnicity":"1","race":"4","sex":"1","height":"187.96","weight":"99","bmi":"28","comments":"self","demographics_complete":"1"},{"record_id":"3","first_name":"colby","last_name":"Smith","address":"123 Fake St. Providence RI 02895","telephone":"(401) 888-9956","email":"JohnSmith78@gmail.com","dob":"1978-07-08","age":"39","ethnicity":"2","race":"4","sex":"1","height":"172.96","weight":"80","bmi":"26.7","comments":"","demographics_complete":"2"},{"record_id":"4","first_name":"mark


=#