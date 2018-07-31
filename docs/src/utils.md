```@meta
CurrentModule = REDCap
```
# Other Functionality

## Config

All REDCap projects need to be tied to their url and API Key, which is done by creating a REDCap.Config object
```julia
config = REDCap.Config("<url>", "<32-digit_API_key>")
```
This object is then passed to all API calling functions. The config object also contains an `ssl` field, allowing the user to enable/disable SSL verification. For some projects that cannot properly verify SSL, disable this feature. 

#### NOTE: SSL verification should be left on at all times.
SSL Verification prevents Man-in-the-Middle attacks.

## Project Creation
___
```@docs
create_project(config::REDCap.Config, project_title::String, purpose::Integer; format::String="json",
						returnFormat::String="json", odm="", purpose_other::String="", project_notes::String="", 
						is_longitudinal::Integer=0, surveys_enabled::Integer=0, record_autonumbering_enabled::Integer=1)
```
___

Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for the new project.

```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

#A default test project.
config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```