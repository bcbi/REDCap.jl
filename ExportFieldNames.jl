""" exportFieldNames(config::Config; format::String="json") 

This method returns a list of the export/import-specific version of field names 
for all fields (or for one field, if desired) in a project. This is mostly used for 
checkbox fields because during data exports and data imports, checkbox fields have a 
different variable name used than the exact one defined for them in the Online Designer 
and Data Dictionary, in which *each checkbox option* gets represented as its own export 
field name in the following format: field_name + triple underscore + converted coded value 
for the choice. For non-checkbox fields, the export field name will be exactly the same 
as the original field name. Note: The following field types will be automatically 
removed from the list returned by this method since they cannot be utilized during 
the data import process: 'calc', 'file', and 'descriptive'.

The list that is returned will contain the three 
following attributes for each field/choice: 'original_field_name', 'choice_value', and 'export_field_name'. 
The choice_value attribute represents the raw coded value for a checkbox choice. 
For non-checkbox fields, the choice_value attribute will always be blank/empty. The export_field_name 
attribute represents the export/import-specific version of that field name. """

function exportFieldNames(config::Config; format::String="json")
	
	fields = Dict("token" => config.key, 
				  "content" => "exportFieldNames", 
				  "format" => format)

	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return JSON.parse(String(output.body))
end