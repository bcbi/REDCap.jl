# REDCap.jl
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://bcbi.github.io/REDCap.jl/)
[![Aqua QA](https://juliatesting.github.io/Aqua.jl/dev/assets/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

REDCap.jl is a Julia API wrapper for [REDCap](https://en.wikipedia.org/wiki/REDCap), a data capture system for scientific
research, especially clinical trials. The purpose of this package is to

- provide named functions that guarantee the behavior of the API calls (succeed or fail, but never perform the wrong action), and
- support interoperability with Julia, using native types for inputs and outputs.

## Quick start

```julia
pkg> add REDCap

julia> using REDCap

julia> project = REDCapProject(url="https://redcap.example.org/api/", token=ENV["STUDY_TOKEN"])
REDCapProject(https://redcap.example.org/api/, token=…3F9A)

julia> export_version(project)
v"15.0.1"

julia> records = export_records(project; fields=[:record_id, :age])
REDCapTable(120 rows × 3 columns)

julia> import_records(project; data=[(record_id="121", age="34")])
1

julia> delete_records(project; records=["121"])
1
```

## Clients and ENV

Credentials live on an immutable client, which every API function takes as its first
argument. API functions don't take `url` or `token` arguments.

- `REDCapProject(; url, token)` holds a 32-character project token.
- `REDCapSuperUser(; url, token)` holds a 64-character super token. It can only create
  projects (`create_project`, which returns a `REDCapProject` for the new project) and
  call `export_version`.

`url` and `token` fall back to environment variables, independently, and only when the
client is constructed: `REDCAP_API_URL`, `REDCAP_API_TOKEN` and
`REDCAP_API_SUPER_TOKEN`. A missing variable throws an error that names it. The URL must
look like `https://…/api/` (plain `http://` only with `allow_insecure=true`). Printing a
client shows only the last four characters of its token.

## Import data

Imports take `data` as any Tables.jl table (such as a `DataFrame`), a single row (a
`NamedTuple` or `Dict`), or a vector of rows, and send it as JSON. To send data that is
already formatted, pass an `IO` or a `REDCapFile(path)` together with `format`:

```julia
import_records(project; data=df)
import_records(project; data=REDCapFile("records.csv"), format=:csv)
```

A plain `String` is never accepted as `data`, so a file's contents are only ever sent when
you ask for it explicitly.

## Return types

Every function returns one fixed type, stated in its docstring:

| Kind | Examples | Julia type |
|---|---|---|
| Table | records, metadata, arms, events, users, logging, reports | `REDCapTable` (Tables.jl; use `DataFrame(t)`) |
| Object | `export_project_info` | `Dict{String,Any}` |
| Version | `export_version` | `VersionNumber` |
| String | `generate_next_record_name`, survey links and return codes | `String` |
| Count | most imports and deletes | `Int`, as reported by REDCap |
| Record names | `import_records_ids` | `Vector{String}` |
| File | `export_file`, `export_PDF`, File Repository | `REDCapDownload` (file name, MIME type, bytes) |
| XML | `export_project_XML` | `String` |
| Client | `create_project` | `REDCapProject` |

Table values stay exactly as REDCap sends them, usually strings. Empty values stay empty
strings, and there is no type conversion.

## Raw IO methods

Table exports, file exports and `export_project_XML` have a method that takes an `IO` as
its second argument and writes REDCap's raw response to it. For table exports, `format`
is required, and only exists on these methods:

```julia
open(io -> export_records(project, io; format=:csv), "records.csv", "w")
```

## Destructive functions

Options that erase or replace data are separate functions, whose docstrings open with a
warning:

| Safe | Destructive |
|---|---|
| `import_records` (blanks are ignored) | `overwrite_records` (blanks erase values) |
| `import_arms` (add or rename) | `replace_arms` (delete all arms first) |
| `import_events` (add or update) | `replace_events` (delete all events first) |

`import_metadata` (replaces the whole data dictionary), `import_file` (replaces an existing
file), `import_instrument_event_mappings`, `import_repeating_instruments_and_events`, and
every `delete_*` function are also marked destructive.

## Batching

Very large requests can time out, or exceed PHP's `max_input_vars` limit (1000 form fields
by default, so even `delete_records(project; records=1:5000)` can fail).
`export_records`, `import_records`, `import_records_ids`, `overwrite_records` and
`delete_records` accept `batchsize`:

```julia
records = export_records(project; batchsize=500)
```

Batches count records, not rows, and are sent one at a time. Batched calls are **not
atomic**: if a batch fails, a `REDCapBatchError` reports how far the call got, and the
earlier batches stay applied.

## Errors

- A non-2xx response throws a `REDCapError` with the HTTP status, REDCap's error message
  and the function name. Nothing is retried automatically.
- Invalid arguments throw before any request is sent.
- Tokens never appear in errors or debug logs (`ENV["JULIA_DEBUG"] = "REDCap"`).

## Testing

`Pkg.test()` needs no REDCap server: requests go through a `MockTransport`, which you can
also use to test your own code. Live tests against a sandbox project are in
[`test/live/`](test/live/README.md).

For more details, see the [documentation](https://bcbi.github.io/REDCap.jl/) or
`help?> REDCap`.

## Acknowledgments
The contributors are grateful for the support of Mary McGrath, Paul Stey, Fernando Gelin, the Brown Data Science Institute, the Brown Center for Biomedical Informatics, and the Tufts CTSI Informatics team.
