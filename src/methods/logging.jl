"""
    export_logging(project; logtype, user, record, dag, beginTime, endTime) -> REDCapTable
    export_logging(project, io::IO; format, ...) -> nothing

Export the project's logging (audit trail), one row per logged event.

$IO_METHOD_DOC

The API has no paging parameters, so logging exports can't be batched; use `beginTime`
and `endTime` to limit large exports.

# Keyword arguments
- `logtype`: only this kind of event: `:export`, `:manage`, `:user`, `:record`,
  `:record_add`, `:record_edit`, `:record_delete`, `:lock_record` or `:page_view`
- `user`: only events by this username
- `record`: only events for this record name
- `dag`: only events in this Data Access Group (unique group name)
- `beginTime`, `endTime`: only events logged after/before this `DateTime`
"""
function export_logging(
        project::REDCapProject;
        logtype = nothing, user = nothing, record = nothing, dag = nothing, beginTime = nothing, endTime = nothing,
    )
    return api_call(:export_logging, project; logtype, user, record, dag, beginTime, endTime)
end

function export_logging(
        project::REDCapProject, io::IO;
        format, logtype = nothing, user = nothing, record = nothing, dag = nothing, beginTime = nothing,
        endTime = nothing,
    )
    return api_call_io(:export_logging, project, io; format, logtype, user, record, dag, beginTime, endTime)
end
