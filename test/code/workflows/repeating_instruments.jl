workflow_token = create_project(data = (project_title = "Repeating Instruments $(now())", purpose = 0), odm="data/project_files/RepeatingInstruments.REDCap.xml")
import_records(token=workflow_token,data=(record_id=1,first_name="A",last_name="Person"))

for i in 1:10
	import_records(
	       token=workflow_token,
		data=(
			record_id = 1,
			redcap_repeat_instrument = :visits,
			redcap_repeat_instance = :new,
			weight = 50
			))
end
