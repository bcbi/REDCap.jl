""" importArms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json") 

This method allows you to import Arms into a project or to rename existing Arms in a project. 
You may use the parameter override=1 as a 'delete all + import' action in order to erase all 
existing Arms in the project while importing new Arms. Notice: Because of the 'override' 
parameter's destructive nature, this method may only use override=1 for projects in 
Development status.

NOTE: This only works for longitudinal projects. """
###############NOT IMPLEMENTED/BROKEN###############
function importArms(config::Config, armData; override::Int=0, format::String="json", returnFormat::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "arm", 
				  "format" => format,
				  "override" => override,
				  "action" => "import",
				  "data" => data,
				  "returnFormat" => returnFormat)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end
