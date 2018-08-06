```@meta
CurrentModule = REDCap
```
# Other Functionality

## Config

```@docs
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


## Project Creation

```@docs
create_project(config::REDCap.Config, project_title::String, purpose::Integer; format::String="json", returnFormat::String="json", odm="", purpose_other::String="", project_notes::String="", is_longitudinal::Integer=0, surveys_enabled::Integer=0, record_autonumbering_enabled::Integer=1)
```

Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for the new project.

```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

#A default test project.
config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```

Any new calls to this project can now be made using the returned config object. 
