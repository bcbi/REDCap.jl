"""
    export_records(project; records, fields, forms, events, rawOrLabel, exportCheckboxLabel,
                   exportSurveyFields, exportDataAccessGroups, filterLogic, dateRangeBegin,
                   dateRangeEnd, decimalCharacter, exportBlankForGrayFormStatus) -> REDCapTable
    export_records(project, io::IO; format, rawOrLabelHeaders, csvDelimiter, ...) -> nothing

Export records in the flat format (one row per record, event and repeat instance).

Returns a [`REDCapTable`](@ref) of strings. The `IO` method writes REDCap's raw response
to `io` instead, in `format` `:csv`, `:json`, `:xml` or `:odm`. For the EAV format, see
[`export_records_eav`](@ref).

# Keyword arguments
- `records`: record names to export (scalar or vector)
- `fields`: field names to export (scalar or vector)
- `forms`: instrument names to export (scalar or vector)
- `events`: unique event names to export (longitudinal projects; scalar or vector)
- `rawOrLabel`: `:raw` (default) or `:label`
- `exportCheckboxLabel`: export checkbox values as labels (`Bool`)
- `exportSurveyFields`: include survey identifier and timestamp fields (`Bool`)
- `exportDataAccessGroups`: include the `redcap_data_access_group` field (`Bool`)
- `filterLogic`: logic string; only records for which it is true are exported
- `dateRangeBegin`, `dateRangeEnd`: only records created or modified after/before this `DateTime`
- `decimalCharacter`: `","` or `"."`
- `exportBlankForGrayFormStatus`: export blank instead of `0` for gray (never edited) form status (`Bool`)
- `batchsize`: export in batches of this many records (see below)
- IO method only: `format` (required), `rawOrLabelHeaders` (`:raw` or `:label`, CSV only),
  `csvDelimiter` (`","`, `"tab"`, `";"`, `"|"` or `"^"`)

$BATCH_DOC

Without `records`, a batched export first exports only the record ID field (the first
field of the data dictionary), with your `filterLogic`, date range and `events` filters,
to find the records to export. Batches are not a consistent snapshot: records edited
during a long export can produce mixed results. The batches' tables are combined, and must
have the same columns; rows come back batch by batch, so when `records` is given out of
order, the row order can differ from an unbatched export. A batched `IO` export supports `format=:csv` (one header) and
`:json` (one array) only; with no matching records it writes nothing (CSV) or `[]` (JSON).
"""
function export_records(
        project::REDCapProject;
        records = nothing, fields = nothing, forms = nothing, events = nothing, rawOrLabel = nothing,
        exportCheckboxLabel = nothing, exportSurveyFields = nothing, exportDataAccessGroups = nothing,
        filterLogic = nothing, dateRangeBegin = nothing, dateRangeEnd = nothing,
        decimalCharacter = nothing, exportBlankForGrayFormStatus = nothing, batchsize = nothing,
    )
    return api_call(
        :export_records, project; batchsize, records, fields, forms, events, rawOrLabel, exportCheckboxLabel,
        exportSurveyFields, exportDataAccessGroups, filterLogic, dateRangeBegin, dateRangeEnd,
        decimalCharacter, exportBlankForGrayFormStatus,
    )
end

function export_records(
        project::REDCapProject, io::IO;
        format, rawOrLabelHeaders = nothing, csvDelimiter = nothing,
        records = nothing, fields = nothing, forms = nothing, events = nothing, rawOrLabel = nothing,
        exportCheckboxLabel = nothing, exportSurveyFields = nothing, exportDataAccessGroups = nothing,
        filterLogic = nothing, dateRangeBegin = nothing, dateRangeEnd = nothing,
        decimalCharacter = nothing, exportBlankForGrayFormStatus = nothing, batchsize = nothing,
    )
    return api_call_io(
        :export_records, project, io; format, batchsize, rawOrLabelHeaders, csvDelimiter, records, fields, forms,
        events, rawOrLabel, exportCheckboxLabel, exportSurveyFields, exportDataAccessGroups,
        filterLogic, dateRangeBegin, dateRangeEnd, decimalCharacter, exportBlankForGrayFormStatus,
    )
end

"""
    export_records_eav(project; <same keywords as export_records>) -> REDCapTable
    export_records_eav(project, io::IO; format, csvDelimiter, ...) -> nothing

Export records in REDCap's EAV format: one row per record, field and value (with
columns such as `record`, `field_name` and `value`).

Returns a [`REDCapTable`](@ref) of strings; the `IO` method writes the raw response to `io`.
Keywords are as for [`export_records`](@ref), except that EAV exports can't be batched.
"""
function export_records_eav(
        project::REDCapProject;
        records = nothing, fields = nothing, forms = nothing, events = nothing, rawOrLabel = nothing,
        exportCheckboxLabel = nothing, exportSurveyFields = nothing, exportDataAccessGroups = nothing,
        filterLogic = nothing, dateRangeBegin = nothing, dateRangeEnd = nothing,
        decimalCharacter = nothing, exportBlankForGrayFormStatus = nothing,
    )
    return api_call(
        :export_records_eav, project; records, fields, forms, events, rawOrLabel, exportCheckboxLabel,
        exportSurveyFields, exportDataAccessGroups, filterLogic, dateRangeBegin, dateRangeEnd,
        decimalCharacter, exportBlankForGrayFormStatus,
    )
end

function export_records_eav(
        project::REDCapProject, io::IO;
        format, csvDelimiter = nothing,
        records = nothing, fields = nothing, forms = nothing, events = nothing, rawOrLabel = nothing,
        exportCheckboxLabel = nothing, exportSurveyFields = nothing, exportDataAccessGroups = nothing,
        filterLogic = nothing, dateRangeBegin = nothing, dateRangeEnd = nothing,
        decimalCharacter = nothing, exportBlankForGrayFormStatus = nothing,
    )
    return api_call_io(
        :export_records_eav, project, io; format, csvDelimiter, records, fields, forms, events,
        rawOrLabel, exportCheckboxLabel, exportSurveyFields, exportDataAccessGroups, filterLogic,
        dateRangeBegin, dateRangeEnd, decimalCharacter, exportBlankForGrayFormStatus,
    )
end

const IMPORT_RECORDS_KWARGS_DOC = """
$IMPORT_DATA_DOC: `:csv`, `:json`, `:xml` or `:odm`
- `forceAutoNumber`: let REDCap assign record names; the names in `data` are only used to
  group rows (`Bool`)
- `dateFormat`: format of date values in `data`: `:YMD` (default), `:MDY` or `:DMY`
- `csvDelimiter`: delimiter of CSV `data`: `","` (default), `"tab"`, `";"`, `"|"` or `"^"`
- `batchsize`: import in batches of this many records (table data only)
- `recordIdField`: the record ID column used to group rows into batches; by default the
  first field of the data dictionary (with `batchsize` only)

Blank values in `data` are ignored; existing values are never erased (see
[`overwrite_records`](@ref) for that)."""

"""
    import_records(project; data, format, forceAutoNumber, dateFormat, csvDelimiter) -> Int

Import records (flat format), adding new records and updating existing ones.

Returns the number of records imported, as reported by REDCap. To get the record names
instead, use [`import_records_ids`](@ref).

# Keyword arguments
$IMPORT_RECORDS_KWARGS_DOC

$BATCH_DOC With `forceAutoNumber=true`, the record names in `data` are only used for
grouping. The batched result is the sum of the batches' counts.

A single (unbatched) request is all-or-nothing: if any row is invalid, nothing is
imported.
"""
function import_records(
        project::REDCapProject;
        data, format = nothing, forceAutoNumber = nothing, dateFormat = nothing, csvDelimiter = nothing,
        batchsize = nothing, recordIdField = nothing,
    )
    return api_call(
        :import_records, project; data, format, forceAutoNumber, dateFormat, csvDelimiter, batchsize, recordIdField,
    )
end

"""
    import_records_ids(project; data, format, forceAutoNumber, dateFormat, csvDelimiter) -> Vector{String}

Import records like [`import_records`](@ref), but return the names of the records
imported instead of their count.

TODO(verify): with `forceAutoNumber=true`, whether REDCap returns the new names or the
names sent.

# Keyword arguments
$IMPORT_RECORDS_KWARGS_DOC

$BATCH_DOC The batched result joins the batches' lists in order.
"""
function import_records_ids(
        project::REDCapProject;
        data, format = nothing, forceAutoNumber = nothing, dateFormat = nothing, csvDelimiter = nothing,
        batchsize = nothing, recordIdField = nothing,
    )
    return api_call(
        :import_records_ids, project; data, format, forceAutoNumber, dateFormat, csvDelimiter, batchsize, recordIdField,
    )
end

"""
$DESTRUCTIVE_WARNING
    Blank values in `data` **erase** the existing values of those fields.

```julia
overwrite_records(project; data, format, forceAutoNumber, dateFormat, csvDelimiter) -> Int
```

Import records with REDCap's `overwriteBehavior=overwrite`: like
[`import_records`](@ref), except that blank values replace existing data.

Returns the number of records imported.

# Keyword arguments
$IMPORT_DATA_DOC: `:csv`, `:json`, `:xml` or `:odm`
- `forceAutoNumber`, `dateFormat`, `csvDelimiter`, `batchsize`, `recordIdField`: as for
  [`import_records`](@ref)

$BATCH_DOC
"""
function overwrite_records(
        project::REDCapProject;
        data, format = nothing, forceAutoNumber = nothing, dateFormat = nothing, csvDelimiter = nothing,
        batchsize = nothing, recordIdField = nothing,
    )
    return api_call(
        :overwrite_records, project; data, format, forceAutoNumber, dateFormat, csvDelimiter, batchsize, recordIdField,
    )
end

"""
$DESTRUCTIVE_WARNING
    Deletes records, or parts of records, permanently.

```julia
delete_records(project; records, arm, instrument, event, repeat_instance, delete_logging) -> Int
```

Delete records. Returns the number of records deleted, as reported by REDCap.

# Keyword arguments
- `records` (required): record names (scalar or vector)
- `arm`: only delete the records from this arm number
- `instrument`: only delete the data of this instrument
- `event`: only delete the data of this unique event name
- `repeat_instance`: only delete this repeat instance (with `instrument` and/or `event`)
- `delete_logging`: also delete the records' logging (`Bool`; REDCap only allows this if
  enabled for the project)
- `batchsize`: delete in batches of this many records

$BATCH_DOC The batched result is the sum of the batches' counts.
"""
function delete_records(
        project::REDCapProject;
        records, arm = nothing, instrument = nothing, event = nothing, repeat_instance = nothing,
        delete_logging = nothing, batchsize = nothing,
    )
    return api_call(:delete_records, project; batchsize, records, arm, instrument, event, repeat_instance, delete_logging)
end

"""
    rename_record(project; record, new_record_name, arm) -> nothing

Rename a record. With `arm`, only the record in that arm number is renamed.
"""
function rename_record(project::REDCapProject; record, new_record_name, arm = nothing)
    return api_call(:rename_record, project; record, new_record_name, arm)
end

"""
    generate_next_record_name(project) -> String

The next record name REDCap would assign with auto-numbering, as a `String`.
"""
generate_next_record_name(project::REDCapProject) = api_call(:generate_next_record_name, project)
