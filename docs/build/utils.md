


<a id='Other-Functionality-1'></a>

# Other Functionality


<a id='Config-1'></a>

## Config


```
REDCap.Config(url::String, key::String; ssl::Bool = true)
```


All REDCap projects need to be tied to their url and API Key, which is done by creating a REDCap.Config object


```julia
config = REDCap.Config("<url>", "<32-digit_API_key>")
```


For certain projects, SSL Verifification may need to be disabled. The config object can be set-up without ssl verification as so:


```julia
config = REDCap.Config("<url>", "<32-digit_API_key>", ssl=false)
```


SSL verification should only be disabled in circumstances where a REDCap API cannot be SSL secured, but must still be accessed. The ssl setting will default to true.


<a id='Project-Creation-1'></a>

## Project Creation

<a id='REDCap.create_project-Tuple{REDCap.Config,String,Integer}' href='#REDCap.create_project-Tuple{REDCap.Config,String,Integer}'>#</a>
**`REDCap.create_project`** &mdash; *Method*.



```
create_project(config::REDCap.Config, project_title::String, purpose::Integer; format::String="json",
					returnFormat::String="json", odm="", purpose_other::String="", project_notes::String="", 
					is_longitudinal::Integer=0, surveys_enabled::Integer=0, record_autonumbering_enabled::Integer=1)
```

Creates a project with the given parameters

**Parameters:**

  * `config` - Struct containing url and super-api-key
  * `format` - "json", "xml", "csv", or "odm". declares format of imported data
  * `data` - Attributes of project to create- only project_title and purpose are required (* for default)

```
* `project_title`: Title
* `purpose`: Must be numerical (0 - test, 1 - other, 2 - research, 3 - Qual+, 4 - OpSupport)
* `purpose_other`: If purpose == 1, string of purpose
* `project_notes`: Notes
* `is_longitudinal`: 0 - false*, 1 - true
* `surveys_enabled`: 0 - false*, 1 - true
* `record_autonumbering_enabled`: 0 - false, 1 - true*
```

  * `returnFormat` - Error message format
  * `odm` - XML string containing metadata

**Returns:**

The standard config for that project.


Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for the new project.


```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

#A default test project.
config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```


Any new calls to this project can now be made using the returned config object. 


<a id='NOTE:-1'></a>

#### NOTE:


There is currently no available way to delete a project through the API. Under most circumstances, only your REDCap system administrator can delete a project.


<a id='Record-ID-1'></a>

## Record ID


It may be necessary for some projects to retreive the next available record ID. This can be done using `generate_next_record_id()`. 


```julia
generate_next_record_id(config)
```


From the REDCap Documentation:


> If using Data Access Groups (DAGs) in the project, this method accounts for the special formatting of the record name for users in DAGs (e.g., DAG-ID); in this case, it only assigns the next value for ID for all numbers inside a DAG. For example, if a DAG has a corresponding DAG number of 223 wherein records 223-1 and 223-2 already exist, then the next record will be 223-3 if the API user belongs to the DAG that has DAG number 223. (The DAG number is auto-assigned by REDCap for each DAG when the DAG is first created.) When generating a new record name in a DAG, the method considers all records in the entire project when determining the maximum record ID, including those that might have been originally created in that DAG but then later reassigned to another DAG.


