"""
    create_project(superuser; data, format, odm) -> REDCapProject

Create a new REDCap project, and return a [`REDCapProject`](@ref) client for it, with
the new project's API token and the super user's URL and transport.

REDCap projects can't be deleted through the API.

# Keyword arguments
- `data` (required): exactly one row of project attributes, such as `project_title`,
  `purpose` (`0`–`4`), `purpose_other`, `project_notes`, `is_longitudinal`,
  `surveys_enabled` and `record_autonumbering_enabled`; or pre-formatted data as an `IO`
  or [`REDCapFile`](@ref) with `format` (`:csv`, `:json` or `:xml`)
- `format`: required with `IO`/`REDCapFile` data, not allowed otherwise
- `odm`: a REDCap project XML file (e.g. from [`export_project_XML`](@ref)) to build the
  project from, as an `IO` or [`REDCapFile`](@ref)
"""
create_project(superuser::REDCapSuperUser; data, format = nothing, odm = nothing) =
    api_call(:create_project, superuser; data, format, odm)

"""
    export_project_info(project) -> Dict{String,Any}

Export the project's settings, such as `project_id`, `project_title`, `in_production` and
`is_longitudinal`, as a `Dict`. Values are kept as REDCap sends them: some are numbers
(e.g. `in_production`) rather than strings.
"""
export_project_info(project::REDCapProject) = api_call(:export_project_info, project)

"""
    import_project_info(project; data, format) -> Int

Update project settings (exactly one row). Settings not in `data` are kept. Available
attributes include `project_title`, `project_language`, `purpose`, `purpose_other`,
`project_notes`, `custom_record_label`, `secondary_unique_field`, `is_longitudinal`,
`surveys_enabled`, `scheduling_enabled`, `record_autonumbering_enabled`,
`randomization_enabled`, `project_irb_number`, `project_grant_number`,
`project_pi_firstname`, `project_pi_lastname`, `display_today_now_button` and
`bypass_branching_erase_field_prompt`.

Returns the number of settings updated, as reported by REDCap.

# Keyword arguments
$IMPORT_TABLE_DOC
"""
import_project_info(project::REDCapProject; data, format = nothing) =
    api_call(:import_project_info, project; data, format)

"""
    export_project_XML(project; returnMetadataOnly, records, fields, events, exportSurveyFields,
                       exportDataAccessGroups, filterLogic, exportFiles) -> String
    export_project_XML(project, io::IO; ...) -> nothing

Export the whole project (metadata and data) as a REDCap project XML (CDISC ODM) file,
which can be used to create a new project (see [`create_project`](@ref)).

Returns the XML as a `String`; the `IO` method writes it to `io` instead.

# Keyword arguments
- `returnMetadataOnly`: export the metadata only, without data (`Bool`)
- `records`, `fields`, `events`: only export these (scalar or vector)
- `exportSurveyFields`: include survey identifier and timestamp fields (`Bool`)
- `exportDataAccessGroups`: include the `redcap_data_access_group` field (`Bool`)
- `filterLogic`: only export records for which this logic is true
- `exportFiles`: include the contents of File Upload and Signature fields (`Bool`)
"""
function export_project_XML(
        project::REDCapProject;
        returnMetadataOnly = nothing, records = nothing, fields = nothing, events = nothing,
        exportSurveyFields = nothing, exportDataAccessGroups = nothing, filterLogic = nothing, exportFiles = nothing,
    )
    return api_call(
        :export_project_XML, project; returnMetadataOnly, records, fields, events, exportSurveyFields,
        exportDataAccessGroups, filterLogic, exportFiles,
    )
end

function export_project_XML(
        project::REDCapProject, io::IO;
        returnMetadataOnly = nothing, records = nothing, fields = nothing, events = nothing,
        exportSurveyFields = nothing, exportDataAccessGroups = nothing, filterLogic = nothing, exportFiles = nothing,
    )
    return api_call_io(
        :export_project_XML, project, io; returnMetadataOnly, records, fields, events, exportSurveyFields,
        exportDataAccessGroups, filterLogic, exportFiles,
    )
end
