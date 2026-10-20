# Docstring fragments shared by several public functions.

const IMPORT_DATA_DOC = """
- `data` (required): a Tables.jl table, a single row (`NamedTuple` or `AbstractDict`), or a
  vector of rows, sent as JSON; or pre-formatted data as an `IO` or [`REDCapFile`](@ref),
  together with `format`. A plain `String` is not accepted.
- `format`: required with `IO`/`REDCapFile` data, not allowed otherwise"""

const IMPORT_TABLE_DOC = "$IMPORT_DATA_DOC: `:csv`, `:json` or `:xml`"

const IO_METHOD_DOC = """
The `IO` method writes REDCap's raw response to `io` instead and returns `nothing`; it
requires `format` (`:csv`, `:json` or `:xml`)."""

const DOWNLOAD_DOC = """
Returns a [`REDCapDownload`](@ref) holding the file name, MIME type and bytes. The `IO`
method writes the file's bytes to `io` instead and returns `nothing`, e.g.
`open(io -> f(project, io; ...), "out.pdf", "w")`."""

const UPLOAD_DOC = """
- `file` (required): the file to upload, as [`REDCapFile`](@ref)`(path)` or an `IO`
- `filename`: the file name REDCap stores; required with an `IO`, defaults to the path's
  base name with a `REDCapFile`"""

const BATCH_DOC = """
# Batching
With `batchsize=n`, the call is split into requests of at most `n` records each, sent one
at a time. All rows of one record stay in the same batch. Batched calls are **not
atomic**: if a batch fails, a [`REDCapBatchError`](@ref) reports the progress and the
earlier batches stay applied."""

const SURVEY_KWARGS_DOC = """
- `record` (required): the record name
- `instrument` (required): the unique instrument name (must be enabled as a survey)
- `event`: the unique event name (longitudinal projects)
- `repeat_instance`: the repeat instance (default 1)"""
