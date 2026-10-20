"""
    REDCap

A Julia wrapper for the [REDCap](https://projectredcap.org) API

# Clients

Credentials live on a client, which every API function takes as its first argument:

```julia
using REDCap
project = REDCapProject()   # url and token from ENV
records = export_records(project; fields=[:record_id, :age])
```

- [`REDCapProject`](@ref)`(; url, token)` holds a 32-character project token. `url`
  defaults to `ENV["REDCAP_API_URL"]` and `token` to `ENV["REDCAP_API_TOKEN"]`,
  independently, and only when the client is constructed:
  `REDCapProject(token=ENV["STUDY_B_TOKEN"])` works.
- [`REDCapSuperUser`](@ref)`(; url, token)` holds a 64-character super token
  (`ENV["REDCAP_API_SUPER_TOKEN"]`). It can only call [`create_project`](@ref), which
  returns a `REDCapProject` for the new project, and [`export_version`](@ref).
- The URL must look like `https://example.org/redcap/api/` (plain `http://` only with
  `allow_insecure=true`), and tokens must be uppercase hexadecimal of the right length.
- Clients are immutable, and printing one shows only the token's last four characters.
  There is no global default client.

# Import data

Imports take `data` as any Tables.jl table (e.g. a `DataFrame`), a single row (a
`NamedTuple` or `Dict`), or a vector of rows. It is sent as JSON. Values are sent as
strings; `missing` and `nothing` become blanks, `Bool`s become `1`/`0`, and nested `Dict`s
(e.g. per-instrument user rights) become JSON objects.

To send data that is already formatted, pass an `IO` or a [`REDCapFile`](@ref), together
with `format` (`:csv`, `:json`, `:xml`, or `:odm` for records):

```julia
import_records(project; data=REDCapFile("records.csv"), format=:csv)
```

A plain `String` is never accepted as `data`.

# Return types

Every function returns one fixed type, stated in its docstring:

| Kind | Examples | Julia type |
|---|---|---|
| Table | records, metadata, arms, events, users, logging, reports | [`REDCapTable`](@ref) |
| Object | [`export_project_info`](@ref) | `Dict{String,Any}` |
| Version | [`export_version`](@ref) | `VersionNumber` |
| String | next record name, survey links and codes | `String` |
| Count | most imports and deletes | `Int` (as reported by REDCap) |
| Record names | [`import_records_ids`](@ref) | `Vector{String}` |
| File | [`export_file`](@ref), [`export_PDF`](@ref), file repository | [`REDCapDownload`](@ref) |
| XML | [`export_project_XML`](@ref) | `String` |
| Client | [`create_project`](@ref) | [`REDCapProject`](@ref) |

A [`REDCapTable`](@ref) is a Tables.jl column table: use `t[:age]`, or `DataFrame(t)`.
Values stay exactly as REDCap sends them, usually strings, with no type conversion; empty
values stay empty strings.

# Raw IO methods

Table exports, file exports and [`export_project_XML`](@ref) also have a method with an
`IO` second argument, which writes REDCap's raw response to it and returns `nothing`. For
table exports, `format` (`:csv`, `:json`, `:xml`; also `:odm` for records) is required and
only exists on these methods:

```julia
open(io -> export_records(project, io; format=:csv), "records.csv", "w")
```

# Destructive functions

Functions that erase or replace existing data have docstrings that open with a warning:
[`overwrite_records`](@ref), [`delete_records`](@ref), [`import_metadata`](@ref),
[`replace_arms`](@ref), [`delete_arms`](@ref), [`replace_events`](@ref),
[`delete_events`](@ref), [`delete_DAGs`](@ref), [`import_file`](@ref),
[`delete_file`](@ref), [`delete_file_from_file_repository`](@ref),
[`import_instrument_event_mappings`](@ref),
[`import_repeating_instruments_and_events`](@ref), [`delete_users`](@ref) and
[`delete_user_roles`](@ref).

# Batching

[`export_records`](@ref), [`import_records`](@ref), [`import_records_ids`](@ref),
[`overwrite_records`](@ref) and [`delete_records`](@ref) accept `batchsize`, to split
large requests (which can time out, or exceed PHP's `max_input_vars`) into requests of at
most that many records, sent one at a time. All rows of one record stay together.
Batching is opt-in, and batched calls are **not atomic**: if a batch fails, a
[`REDCapBatchError`](@ref) reports the progress, and earlier batches stay applied.

# Errors

- Any non-2xx response throws a [`REDCapError`](@ref) with the HTTP status, REDCap's error
  message and the function name. There are no automatic retries, since writes are not
  safe to repeat.
- Invalid arguments throw `ArgumentError` (or `MethodError`/`UndefKeywordError` for
  missing or unsupported keywords) before any request is sent.
- Tokens never appear in errors or in the `@debug` request logs
  (`ENV["JULIA_DEBUG"] = "REDCap"`).

# Testing your code

Clients take a `transport`. [`MockTransport`](@ref) records requests and answers with
canned responses, without a network; [`RecordingTransport`](@ref) saves real responses as
fixtures.
"""
module REDCap

using Dates
using HTTP
using JSON
using Tables
using URIs: URI, escapeuri

include("errors.jl")
include("request.jl")
include("transport.jl")
include("clients.jl")
include("table.jl")
include("params.jl")
include("data.jl")
include("spec.jl")
include("builder.jl")
include("response.jl")
include("call.jl")
include("batch.jl")

include("methods/docs.jl")
include("methods/arms.jl")
include("methods/data_access_groups.jl")
include("methods/events.jl")
include("methods/files.jl")
include("methods/file_repository.jl")
include("methods/instruments.jl")
include("methods/logging.jl")
include("methods/metadata.jl")
include("methods/projects.jl")
include("methods/records.jl")
include("methods/redcap.jl")
include("methods/repeating.jl")
include("methods/reports.jl")
include("methods/surveys.jl")
include("methods/users.jl")

# Types
export AbstractREDCapClient, REDCapProject, REDCapSuperUser
export AbstractTransport, HTTPTransport, MockTransport, RecordingTransport
export REDCapTable, REDCapFile, REDCapDownload, REDCapError, REDCapBatchError

# API functions
export create_file_repository_folder,
    create_project,
    delete_arms,
    delete_DAGs,
    delete_events,
    delete_file,
    delete_file_from_file_repository,
    delete_records,
    delete_user_roles,
    delete_users,
    export_arms,
    export_DAGs,
    export_events,
    export_field_names,
    export_file,
    export_file_from_file_repository,
    export_file_repository_list,
    export_instrument_event_mappings,
    export_instruments,
    export_logging,
    export_metadata,
    export_PDF,
    export_PDF_all_records,
    export_project_info,
    export_project_XML,
    export_records,
    export_records_eav,
    export_repeating_instruments_and_events,
    export_reports,
    export_survey_access_code,
    export_survey_link,
    export_survey_participants,
    export_survey_queue_link,
    export_survey_return_code,
    export_user_DAG_assignment,
    export_user_role_assignments,
    export_user_roles,
    export_users,
    export_version,
    generate_next_record_name,
    import_arms,
    import_DAGs,
    import_events,
    import_file,
    import_file_into_file_repository,
    import_instrument_event_mappings,
    import_metadata,
    import_project_info,
    import_records,
    import_records_ids,
    import_repeating_instruments_and_events,
    import_user_DAG_assignment,
    import_user_role_assignments,
    import_user_roles,
    import_users,
    overwrite_records,
    rename_record,
    replace_arms,
    replace_events,
    switch_DAG

end
