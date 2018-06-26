include("Utils.jl")

"""
	import_project_information(config::Config, infoData; format::String="json")

update basic attributes of given REDCap project.
"""

function import_project_information(config::Config, infoData; format::String="json")
	output = api_pusher("import", "project_settings", config, infoData=infoData, format=format)
	return output
end


"""
	import_metadata(config::Config, metaData; format::String="json", returnFormat::String="json")

import metadata (i.e., Data Dictionary) into a project.
"""

function import_metadata(config::Config, metaData; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "metadata", config, metaData=metaData, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_user(config::Config, userData; format::String="json", returnFormat::String="json")

update/import new users into a project.
"""

function import_user(config::Config, userData; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "user", config, userData=userData, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_arms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json")

update/import Arms into a project.
"""

function import_arms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json")
	output = api_pusher("import", "arm", config, armData=armData, override=override, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_events(config::Config, userData; override::Int=0, format::String="json", returnFormat::String="json")

update/import Events into a project.
"""

function import_events(config::Config, userData; override::Int=0, format::String="json", returnFormat::String="json")
	output = api_pusher("import", "event", config, userData=userData, override=override, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_records(config::Config, data::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false, dateFormat::String="YMD",
						returnContent::String="count", returnFormat::String="json")

import a set of records for a project.
"""

function import_records(config::Config, data::Any; format::String="json", dtype::String="flat", 
						overwriteBehavior::String="normal", forceNumber::Bool=false, dateFormat::String="YMD",
						returnContent::String="count", returnFormat::String="json")
	record = """[{"sex":"0","age":"45","address":"199 Easton Sq. Smithfield RI 02855","height":"2","dob":"1972-12-13","record_id":6,"bmi":"22.0","comments":"Randomly Generated - Demographics","email":"EMorgan250@yahoo.com","first_name":"Elizabeth","telephone":"6171261901","weight":"9","ethnicity":"1","last_name":"Morgan","race":"2"},{"sex":"0","age":"61","address":"60 Waltham Ln. Brockton MA 01275","height":"1","dob":"1956-12-11","record_id":7,"bmi":"38.0","comments":"Randomly Generated - Demographics","email":"S_Johnson231@outlook.com","first_name":"Susan","telephone":"6175784803","weight":"1","ethnicity":"2","last_name":"Johnson","race":"6"},{"sex":"0","age":"84","address":"208 34th Blvd. Newton MA 02144","height":"1","dob":"1934-05-22","record_id":8,"bmi":"17.0","comments":"Randomly Generated - Demographics","email":"E_King34@mail.com","first_name":"Erica","telephone":"6178974168","weight":"5","ethnicity":"1","last_name":"King","race":"5"},{"sex":"0","age":"51","address":"239 Cumberland Ave. Providence RI 02880","height":"2","dob":"1967-02-08","record_id":9,"bmi":"13.0","comments":"Randomly Generated - Demographics","email":"LindaYang@brown.edu","first_name":"Linda","telephone":"6178362410","weight":"6","ethnicity":"1","last_name":"Yang","race":"2"},{"sex":"1","age":"56","address":"53 Cross St. Boston MA 02260","height":"1","dob":"1962-04-08","record_id":10,"bmi":"43.0","comments":"Randomly Generated - Demographics","email":"PJames@ccri.edu","first_name":"Peter","telephone":"4014204044","weight":"1","ethnicity":"2","last_name":"James","race":"1"}]"""

	output = api_pusher("import", "record", config, data=record, format=format, dtype=dtype, 
							overwriteBehavior=overwriteBehavior, forceNumber=forceNumber, dateFormat=dateFormat,
							returnContent=returnContent, returnFormat=returnFormat)
	return output
end


"""
	import_insrument_event_mappings(config::Config, instData, arms; format::String="json", returnFormat::String="json")

import Instrument-Event Mappings into a project 

NOTE: This only works for longitudinal projects.
"""

function import_insrument_event_mappings(config::Config, instData, arms; format::String="json", returnFormat::String="json")
	output = api_pusher("import", "formEventMapping", config, instData=instData, arms=arms, format=format, returnFormat=returnFormat)
	return output
end


"""
	import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")

upload a document to specific record/field.
"""

function import_file(config::Config, record::Int, field::String, event::String, repeat_instance::Int, file;
					returnFormat::String="json")
	output = api_pusher("import", "file", config, record=record, field=field, event=event, repeat_instance=repeat_instance, 
							file=file, returnFormat=returnFormat)
	return output
end