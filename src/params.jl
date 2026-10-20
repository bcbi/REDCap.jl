#
# Parameter registry: REDCap parameters with the same name behave the same way across
# methods, so each name maps to one kind, which validates and encodes its values.
#

abstract type ParamKind end

"A string. Symbols and integers are accepted and converted with `string`."
struct StringParam <: ParamKind end

"An integer (not a `Bool`)."
struct IntParam <: ParamKind end

"A `Bool`, encoded with the strings REDCap expects for this parameter."
struct BoolParam <: ParamKind
    yes::String
    no::String
end

"A `DateTime` or `Date`, encoded as `yyyy-mm-dd HH:MM:SS`."
struct DateTimeParam <: ParamKind end

"An array, encoded as `name[0]`, `name[1]`, …; a scalar is encoded as `name[0]`."
struct ArrayParam <: ParamKind end

"One of a fixed set of values, given as a `Symbol` or `String`."
struct EnumParam <: ParamKind
    values::Vector{String}
end
EnumParam(values::AbstractString...) = EnumParam(collect(String, values))

"""
The contents of an `IO` or [`REDCapFile`](@ref), sent as text. A plain `String` is not
accepted, so file contents are only sent when the user explicitly asks for it.
"""
struct RawTextParam <: ParamKind end

const TRUE_FALSE = BoolParam("true", "false")
const ONE_ZERO = BoolParam("1", "0")

const PARAMETERS = Dict{Symbol, ParamKind}(
    # Output and input formats. Only the request builder sets these.
    :format => EnumParam("csv", "json", "xml", "odm"),
    :returnFormat => EnumParam("csv", "json", "xml"),
    :type => EnumParam("flat", "eav"),

    # Record selection
    :records => ArrayParam(),
    :fields => ArrayParam(),
    :forms => ArrayParam(),
    :events => ArrayParam(),
    :arms => ArrayParam(),
    :record => StringParam(),
    :new_record_name => StringParam(),
    :arm => IntParam(),
    :instrument => StringParam(),
    :event => StringParam(),
    :repeat_instance => IntParam(),
    :filterLogic => StringParam(),
    :dateRangeBegin => DateTimeParam(),
    :dateRangeEnd => DateTimeParam(),

    # Export options
    :rawOrLabel => EnumParam("raw", "label"),
    :rawOrLabelHeaders => EnumParam("raw", "label"),
    :exportCheckboxLabel => TRUE_FALSE,
    :exportSurveyFields => TRUE_FALSE,
    :exportDataAccessGroups => TRUE_FALSE,
    :exportBlankForGrayFormStatus => TRUE_FALSE,
    :csvDelimiter => EnumParam(",", "tab", ";", "|", "^"),
    :decimalCharacter => EnumParam(",", "."),

    # Import options
    :overwriteBehavior => EnumParam("normal", "overwrite"),
    :forceAutoNumber => TRUE_FALSE,
    :dateFormat => EnumParam("MDY", "DMY", "YMD"),
    :returnContent => EnumParam("count", "ids", "auto_ids", "nothing"),

    # Delete options
    :delete_logging => ONE_ZERO,

    # Arms and events
    :override => ONE_ZERO,

    # Data Access Groups, users and roles
    :dags => ArrayParam(),
    :dag => StringParam(),
    :users => ArrayParam(),
    :user => StringParam(),
    :roles => ArrayParam(),

    # Fields and files
    :field => StringParam(),
    :name => StringParam(),
    :folder_id => IntParam(),
    :dag_id => IntParam(),
    :role_id => IntParam(),
    :doc_id => IntParam(),

    # PDFs. REDCap ignores the value of `allRecords`: any value exports all records.
    :compactDisplay => TRUE_FALSE,  # TODO(verify): true/false rather than 1/0
    :allRecords => ONE_ZERO,

    # Logging
    :logtype => EnumParam(
        "export", "manage", "user", "record", "record_add", "record_edit", "record_delete",
        "lock_record", "page_view",
    ),
    :beginTime => DateTimeParam(),
    :endTime => DateTimeParam(),

    # Reports
    :report_id => IntParam(),

    # Projects
    :returnMetadataOnly => TRUE_FALSE,
    :exportFiles => TRUE_FALSE,
    :odm => RawTextParam(),
)

"""
    param_kind(overrides, name) -> ParamKind

The kind of parameter `name`: the method's override if it has one, otherwise the
registry entry.
"""
function param_kind(overrides::AbstractDict{Symbol, ParamKind}, name::Symbol)
    haskey(overrides, name) && return overrides[name]
    haskey(PARAMETERS, name) && return PARAMETERS[name]
    throw(ArgumentError("unknown REDCap parameter `$name`"))
end

"""
    encode_param(kind, name, value) -> Vector{Pair{String,String}}

Validate `value` for a parameter of the given kind and encode it as form fields.
Throws `ArgumentError` for invalid values.
"""
function encode_param end

invalid(name, value, expected) =
    throw(ArgumentError("invalid value for `$name`: got $(repr(value)) ($(typeof(value))), expected $expected"))

scalar_string(name, x::AbstractString, expected) = String(x)
scalar_string(name, x::Symbol, expected) = String(x)
scalar_string(name, x::Bool, expected) = invalid(name, x, expected)
scalar_string(name, x::Integer, expected) = string(x)
scalar_string(name, x, expected) = invalid(name, x, expected)

function encode_param(::StringParam, name::Symbol, value)
    s = scalar_string(name, value, "a String, Symbol or Integer")
    return [String(name) => s]
end

function encode_param(::IntParam, name::Symbol, value)
    (value isa Integer && !(value isa Bool)) || invalid(name, value, "an Integer")
    return [String(name) => string(value)]
end

function encode_param(kind::BoolParam, name::Symbol, value)
    value isa Bool || invalid(name, value, "a Bool")
    return [String(name) => (value ? kind.yes : kind.no)]
end

function encode_param(::DateTimeParam, name::Symbol, value)
    value isa Union{Date, DateTime} || invalid(name, value, "a DateTime or Date")
    return [String(name) => Dates.format(DateTime(value), dateformat"yyyy-mm-dd HH:MM:SS")]
end

function encode_param(::ArrayParam, name::Symbol, value)
    expected = "a String, Symbol, Integer, or a vector of these"
    items = value isa Union{AbstractVector, Tuple} ? collect(value) : [value]
    isempty(items) && throw(ArgumentError("`$name` must not be empty; omit it instead"))
    return [string(name, '[', i - 1, ']') => scalar_string(name, x, expected) for (i, x) in enumerate(items)]
end

function encode_param(kind::EnumParam, name::Symbol, value)
    expected = "one of " * join(repr.(Symbol.(kind.values)), ", ")
    value isa Union{Symbol, AbstractString, AbstractChar} || invalid(name, value, expected)
    s = string(value)
    s in kind.values || invalid(name, value, expected)
    return [String(name) => s]
end

function encode_param(::RawTextParam, name::Symbol, value)
    value isa AbstractString && throw(
        ArgumentError("a String is not accepted for `$name`; pass an IO, or a file as `REDCapFile(path)`"),
    )
    value isa REDCapFile && return [String(name) => read(value.path, String)]
    value isa IO && return [String(name) => read(value, String)]
    return invalid(name, value, "an IO or REDCapFile")
end
