"""
    export_reports(project; report_id, rawOrLabel, exportCheckboxLabel, decimalCharacter) -> REDCapTable
    export_reports(project, io::IO; format, report_id, rawOrLabelHeaders, csvDelimiter, ...) -> nothing

Export the data of a report defined in the project.

$IO_METHOD_DOC

# Keyword arguments
- `report_id` (required): the report's ID number
- `rawOrLabel`: `:raw` (default) or `:label`
- `exportCheckboxLabel`: export checkbox values as labels (`Bool`)
- `decimalCharacter`: `","` or `"."`
- IO method only: `rawOrLabelHeaders` (`:raw` or `:label`, CSV only), `csvDelimiter`

TODO(verify): whether reports can also be exported as ODM.
"""
function export_reports(
        project::REDCapProject;
        report_id, rawOrLabel = nothing, exportCheckboxLabel = nothing, decimalCharacter = nothing,
    )
    return api_call(:export_reports, project; report_id, rawOrLabel, exportCheckboxLabel, decimalCharacter)
end

function export_reports(
        project::REDCapProject, io::IO;
        format, report_id, rawOrLabel = nothing, exportCheckboxLabel = nothing, decimalCharacter = nothing,
        rawOrLabelHeaders = nothing, csvDelimiter = nothing,
    )
    return api_call_io(
        :export_reports, project, io; format, report_id, rawOrLabel, exportCheckboxLabel, decimalCharacter,
        rawOrLabelHeaders, csvDelimiter,
    )
end
