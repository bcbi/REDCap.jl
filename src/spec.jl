#
# Method spec table: one entry per public API function. This is the single source of truth
# for what each function sends. The request builder takes `content`, `action` and the fixed
# parameters from here, never from the function body.
#

"""
    MethodSpec

Describes one public API function.

- `name`: the Julia function name
- `content`, `action`: REDCap's `content` and `action` parameters (`action` may be `nothing`)
- `client`: the client type the function accepts
- `data`: `:required` for imports, `:none` otherwise
- `required`, `optional`: REDCap parameters the user passes as keywords (besides `data`)
- `returns`: the return kind (see `RETURN_KINDS`)
- `destructive`: the call erases or replaces existing data
- `raw_io`: a method taking an `IO` second argument exists, which writes the raw response
- `io_optional`: extra parameters accepted only by the IO method
- `io_formats`: allowed `format` values for the IO method; empty when the response has
  only one format (XML, binary files), in which case the IO method has no `format`
- `data_formats`: allowed `format` values for raw (`IO`/`REDCapFile`) import data
- `single_row`: `data` must contain exactly one row
- `json_object`: table data is sent as a single JSON object instead of an array of one
  (requires `single_row`)
- `upload`: the function uploads a file (keywords `file` and `filename`)
- `fixed`: parameters this function always sends, which the user can't set
- `batchable`: the function accepts `batchsize`
- `overrides`: per-method parameter kinds, where REDCap is inconsistent
"""
struct MethodSpec
    name::Symbol
    content::Symbol
    action::Union{Symbol, Nothing}
    client::Type
    data::Symbol
    required::Vector{Symbol}
    optional::Vector{Symbol}
    returns::Symbol
    destructive::Bool
    raw_io::Bool
    io_optional::Vector{Symbol}
    io_formats::Vector{Symbol}
    data_formats::Vector{Symbol}
    single_row::Bool
    json_object::Bool
    upload::Bool
    fixed::Vector{Pair{Symbol, Any}}
    batchable::Bool
    overrides::Dict{Symbol, ParamKind}
end

const RETURN_KINDS = (:table, :dict, :string, :version, :int, :ids, :file, :xml, :client, :folder, :nothing)

# Kinds whose response is JSON, so the request asks for `format=json`.
const JSON_KINDS = (:table, :dict, :ids, :folder)

function MethodSpec(
        name::Symbol;
        content::Symbol,
        action::Union{Symbol, Nothing} = nothing,
        client::Type = REDCapProject,
        data::Symbol = :none,
        required::Vector{Symbol} = Symbol[],
        optional::Vector{Symbol} = Symbol[],
        returns::Symbol,
        destructive::Bool = false,
        raw_io::Bool = false,
        io_optional::Vector{Symbol} = Symbol[],
        io_formats::Vector{Symbol} = Symbol[],
        data_formats::Vector{Symbol} = Symbol[],
        single_row::Bool = false,
        json_object::Bool = false,
        upload::Bool = false,
        fixed::Vector{<:Pair{Symbol}} = Pair{Symbol, Any}[],
        batchable::Bool = false,
        overrides::Dict{Symbol, <:ParamKind} = Dict{Symbol, ParamKind}(),
    )
    client <: AbstractREDCapClient || throw(ArgumentError("$name: invalid client type $client"))
    data in (:required, :none) || throw(ArgumentError("$name: data must be :required or :none"))
    returns in RETURN_KINDS || throw(ArgumentError("$name: unknown return kind $returns"))
    raw_io || isempty(io_formats) || throw(ArgumentError("$name: io_formats without raw_io"))
    raw_io || isempty(io_optional) || throw(ArgumentError("$name: io_optional without raw_io"))
    (data == :required) == !isempty(data_formats) || throw(ArgumentError("$name: data and data_formats disagree"))
    !single_row || data == :required || throw(ArgumentError("$name: single_row without data"))
    !json_object || single_row || throw(ArgumentError("$name: json_object without single_row"))
    !batchable || returns in (:table, :int, :ids) || throw(ArgumentError("$name: unsupported batchable return kind"))
    # Every request asks for JSON responses (and JSON errors). Imports set `format` from
    # the data, so only exports fix it.
    all_fixed = Pair{Symbol, Any}[:returnFormat => :json]
    data == :none && returns in JSON_KINDS && push!(all_fixed, :format => :json)
    append!(all_fixed, fixed)
    names = vcat(required, optional, io_optional, first.(all_fixed))
    allunique(names) || throw(ArgumentError("$name: a parameter is listed twice"))
    for p in names
        haskey(overrides, p) || haskey(PARAMETERS, p) || throw(ArgumentError("$name: parameter $p is not in the registry"))
    end
    return MethodSpec(
        name, content, action, client, data, required, optional, returns, destructive, raw_io,
        io_optional, io_formats, data_formats, single_row, json_object, upload, all_fixed, batchable, Dict{Symbol, ParamKind}(overrides),
    )
end

"""
    user_kwargs(spec; io=false) -> Set{Symbol}

The keyword arguments the public function (or its IO method) must accept.
"""
function user_kwargs(spec::MethodSpec; io::Bool = false)
    names = Set{Symbol}(vcat(spec.required, spec.optional))
    io && union!(names, spec.io_optional)
    io && !isempty(spec.io_formats) && push!(names, :format)
    spec.data == :required && union!(names, [:data, :format])
    spec.upload && union!(names, [:file, :filename])
    if spec.batchable
        push!(names, :batchsize)
        spec.data == :required && push!(names, :recordIdField)
    end
    return names
end

const RECORD_FORMATS = [:csv, :json, :xml, :odm]
const CSV_JSON_XML = [:csv, :json, :xml]

const EXPORT_RECORDS_PARAMS = [
    :records, :fields, :forms, :events, :rawOrLabel, :exportCheckboxLabel, :exportSurveyFields,
    :exportDataAccessGroups, :filterLogic, :dateRangeBegin, :dateRangeEnd, :decimalCharacter,
    :exportBlankForGrayFormStatus,
]

const IMPORT_RECORDS_PARAMS = [:forceAutoNumber, :dateFormat, :csvDelimiter]

const SURVEY_PARAMS = (required = [:record, :instrument], optional = [:event, :repeat_instance])

"A table export with a raw IO method in CSV, JSON or XML."
table_export(name; kwargs...) =
    MethodSpec(name; returns = :table, raw_io = true, io_formats = CSV_JSON_XML, kwargs...)

"An import of table data that reports a count."
count_import(name; kwargs...) =
    MethodSpec(name; data = :required, data_formats = CSV_JSON_XML, returns = :int, kwargs...)

# TODO(verify): whether `type=eav` exports honor `exportCheckboxLabel` and `rawOrLabelHeaders`.

const METHOD_SPECS = MethodSpec[
    # Arms
    table_export(:export_arms; content = :arm, optional = [:arms]),
    count_import(:import_arms; content = :arm, action = :import, fixed = [:override => false]),
    count_import(:replace_arms; content = :arm, action = :import, fixed = [:override => true], destructive = true),
    MethodSpec(:delete_arms; content = :arm, action = :delete, required = [:arms], returns = :int, destructive = true),

    # Data Access Groups
    table_export(:export_DAGs; content = :dag),
    count_import(:import_DAGs; content = :dag, action = :import),
    MethodSpec(:delete_DAGs; content = :dag, action = :delete, required = [:dags], returns = :int, destructive = true),
    MethodSpec(:switch_DAG; content = :dag, action = :switch, required = [:dag], returns = :nothing),
    table_export(:export_user_DAG_assignment; content = :userDagMapping),
    count_import(:import_user_DAG_assignment; content = :userDagMapping, action = :import),

    # Events
    table_export(:export_events; content = :event, optional = [:arms]),
    count_import(:import_events; content = :event, action = :import, fixed = [:override => false]),
    count_import(:replace_events; content = :event, action = :import, fixed = [:override => true], destructive = true),
    MethodSpec(:delete_events; content = :event, action = :delete, required = [:events], returns = :int, destructive = true),

    # Field names
    table_export(:export_field_names; content = :exportFieldNames, optional = [:field]),

    # Files in records
    MethodSpec(
        :export_file; content = :file, action = :export, required = [:record, :field],
        optional = [:event, :repeat_instance], returns = :file, raw_io = true,
    ),
    MethodSpec(
        :import_file; content = :file, action = :import, required = [:record, :field],
        optional = [:event, :repeat_instance], upload = true, returns = :nothing, destructive = true,
    ),
    MethodSpec(
        :delete_file; content = :file, action = :delete, required = [:record, :field],
        optional = [:event, :repeat_instance], returns = :nothing, destructive = true,
    ),

    # File repository
    MethodSpec(
        :create_file_repository_folder; content = :fileRepository, action = :createFolder,
        required = [:name], optional = [:folder_id, :dag_id, :role_id], returns = :folder,
    ),
    table_export(:export_file_repository_list; content = :fileRepository, action = :list, optional = [:folder_id]),
    MethodSpec(
        :export_file_from_file_repository; content = :fileRepository, action = :export,
        required = [:doc_id], returns = :file, raw_io = true,
    ),
    MethodSpec(
        :import_file_into_file_repository; content = :fileRepository, action = :import,
        optional = [:folder_id], upload = true, returns = :nothing,
    ),
    MethodSpec(
        :delete_file_from_file_repository; content = :fileRepository, action = :delete,
        required = [:doc_id], returns = :nothing, destructive = true,
    ),

    # Instruments
    table_export(:export_instruments; content = :instrument),
    MethodSpec(
        :export_PDF; content = :pdf, optional = [:record, :event, :instrument, :repeat_instance, :compactDisplay],
        returns = :file, raw_io = true,
    ),
    MethodSpec(
        :export_PDF_all_records; content = :pdf, optional = [:compactDisplay], fixed = [:allRecords => true],
        returns = :file, raw_io = true,
    ),
    table_export(:export_instrument_event_mappings; content = :formEventMapping, optional = [:arms]),
    # TODO(verify): whether importing mappings replaces all existing mappings of the arms in `data`.
    count_import(:import_instrument_event_mappings; content = :formEventMapping, action = :import, destructive = true),

    # Logging
    table_export(:export_logging; content = :log, optional = [:logtype, :user, :record, :dag, :beginTime, :endTime]),

    # Metadata
    table_export(:export_metadata; content = :metadata, optional = [:fields, :forms]),
    count_import(:import_metadata; content = :metadata, destructive = true),

    # Projects
    MethodSpec(
        :create_project; content = :project, client = REDCapSuperUser, data = :required,
        data_formats = CSV_JSON_XML, single_row = true, optional = [:odm], returns = :client,
    ),
    MethodSpec(:export_project_info; content = :project, returns = :dict),
    # REDCap ignores project settings sent as a JSON array (confirmed against a live server).
    count_import(:import_project_info; content = :project_settings, single_row = true, json_object = true),
    MethodSpec(
        :export_project_XML; content = :project_xml, returns = :xml, raw_io = true,
        optional = [
            :returnMetadataOnly, :records, :fields, :events, :exportSurveyFields,
            :exportDataAccessGroups, :filterLogic, :exportFiles,
        ],
    ),

    # Records
    MethodSpec(
        :export_records; content = :record, optional = EXPORT_RECORDS_PARAMS, returns = :table,
        raw_io = true, io_formats = RECORD_FORMATS, io_optional = [:rawOrLabelHeaders, :csvDelimiter],
        fixed = [:type => :flat], batchable = true,
    ),
    MethodSpec(
        :export_records_eav; content = :record, optional = EXPORT_RECORDS_PARAMS, returns = :table,
        raw_io = true, io_formats = RECORD_FORMATS, io_optional = [:csvDelimiter],
        fixed = [:type => :eav],
    ),
    MethodSpec(
        :import_records; content = :record, data = :required, data_formats = RECORD_FORMATS,
        optional = IMPORT_RECORDS_PARAMS, returns = :int, batchable = true,
        fixed = [:type => :flat, :overwriteBehavior => :normal, :returnContent => :count],
    ),
    MethodSpec(
        :import_records_ids; content = :record, data = :required, data_formats = RECORD_FORMATS,
        optional = IMPORT_RECORDS_PARAMS, returns = :ids, batchable = true,
        fixed = [:type => :flat, :overwriteBehavior => :normal, :returnContent => :ids],
    ),
    MethodSpec(
        :overwrite_records; content = :record, data = :required, data_formats = RECORD_FORMATS,
        optional = IMPORT_RECORDS_PARAMS, returns = :int, destructive = true, batchable = true,
        fixed = [:type => :flat, :overwriteBehavior => :overwrite, :returnContent => :count],
    ),
    MethodSpec(
        :delete_records; content = :record, action = :delete, required = [:records],
        optional = [:arm, :instrument, :event, :repeat_instance, :delete_logging],
        returns = :int, destructive = true, batchable = true,
    ),
    MethodSpec(
        :rename_record; content = :record, action = :rename, required = [:record, :new_record_name],
        optional = [:arm], returns = :nothing,
    ),
    MethodSpec(:generate_next_record_name; content = :generateNextRecordName, returns = :string),

    # Repeating instruments and events
    table_export(:export_repeating_instruments_and_events; content = :repeatingFormsEvents),
    # TODO(verify): that an import replaces the whole repeating setup.
    count_import(:import_repeating_instruments_and_events; content = :repeatingFormsEvents, destructive = true),

    # Reports
    MethodSpec(
        :export_reports; content = :report, required = [:report_id],
        optional = [:rawOrLabel, :exportCheckboxLabel, :decimalCharacter], returns = :table,
        raw_io = true, io_formats = CSV_JSON_XML, io_optional = [:rawOrLabelHeaders, :csvDelimiter],
    ),

    # REDCap
    MethodSpec(:export_version; content = :version, client = AbstractREDCapClient, returns = :version),

    # Surveys
    MethodSpec(:export_survey_link; content = :surveyLink, SURVEY_PARAMS..., returns = :string),
    MethodSpec(:export_survey_return_code; content = :surveyReturnCode, SURVEY_PARAMS..., returns = :string),
    MethodSpec(:export_survey_queue_link; content = :surveyQueueLink, required = [:record], returns = :string),
    table_export(:export_survey_participants; content = :participantList, required = [:instrument], optional = [:event]),

    # Users
    table_export(:export_users; content = :user),
    count_import(:import_users; content = :user),
    MethodSpec(:delete_users; content = :user, action = :delete, required = [:users], returns = :int, destructive = true),

    # User roles
    table_export(:export_user_roles; content = :userRole),
    count_import(:import_user_roles; content = :userRole),
    MethodSpec(:delete_user_roles; content = :userRole, action = :delete, required = [:roles], returns = :int, destructive = true),
    table_export(:export_user_role_assignments; content = :userRoleMapping),
    count_import(:import_user_role_assignments; content = :userRoleMapping),
]

const SPECS_BY_NAME = Dict{Symbol, MethodSpec}(s.name => s for s in METHOD_SPECS)

method_spec(name::Symbol) = SPECS_BY_NAME[name]

# Every destructive function's docstring starts with this admonition.
const DESTRUCTIVE_WARNING = "!!! warning \"Destructive\""
