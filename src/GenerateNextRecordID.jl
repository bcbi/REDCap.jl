""" generateNextRecordID(config::Config) 

To be used by projects with record auto-numbering enabled, this method 
exports the next potential record ID for a project. It generates the 
next record name by determining the current maximum numerical record ID 
and then incrementing it by one.

Note: This method does not create a new record, but merely determines 
what the next record name would be.

If using Data Access Groups (DAGs) in the project, this method accounts 
for the special formatting of the record name for users in DAGs (e.g., DAG-ID); 
in this case, it only assigns the next value for ID for all numbers inside 
a DAG. For example, if a DAG has a corresponding DAG number of 223 wherein 
records 223-1 and 223-2 already exist, then the next record will be 223-3 
if the API user belongs to the DAG that has DAG number 223. 
(The DAG number is auto-assigned by REDCap for each DAG when 
the DAG is first created.) When generating a new record name in a DAG, 
the method considers all records in the entire project when determining 
the maximum record ID, including those that might have been originally 
created in that DAG but then later reassigned to another DAG.

Note: This method functions the same even for projects that 
do not have record auto-numbering enabled."""

function generateNextRecordID(config::Config)
	
	fields = Dict("token" => config.key, 
				  "content" => "generateNextRecordName")
	output = HTTP.post(config.url; body=fields)
	return Int(String(output.body))
end
