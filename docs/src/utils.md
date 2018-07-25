### Config

All REDCap projects need to be tied to their url and API Key, which is done by creating a Config object
```julia
config = REDCap.Config("<url>", "<32-digit_API_key>")
```
This object is then passed to all API calling functions. 

### Other Functionality

Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for that project.

```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```