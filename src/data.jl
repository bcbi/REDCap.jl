#
# Data input for imports. Tables and rows are serialized to JSON here; raw input (an IO
# or a REDCapFile) is sent unchanged with the format the user names. A plain String is
# never accepted, so file contents are sent only when the user explicitly asks for it.
#

"""
    REDCapFile(path)

Marks `path` as a file whose contents should be sent unchanged as an import's `data`,
together with an explicit `format`. A plain `String` is never treated as a file name.
"""
struct REDCapFile
    path::String
    REDCapFile(path::AbstractString) = new(String(path))
end

"A row to import: column names and values in order."
const Row = Vector{Pair{String, Any}}

"""
    RawData(format, payload)

Pre-formatted import data, sent as is.
"""
struct RawData
    format::String
    payload::String
end

"""
    TableData(rows)

Import data normalized to rows, serialized to JSON when the request is built.
"""
struct TableData
    rows::Vector{Row}
end

const STRING_DATA_ERROR =
    "a String is not accepted as `data`; pass a table or rows, " *
    "or wrap pre-formatted data as `IOBuffer(str)` or a file as `REDCapFile(path)`, together with `format`"

"""
    normalize_data(data, format, allowed_formats) -> Union{TableData,RawData}

Validate import data and the `format` keyword. Table input must not have a `format`;
raw input (`IO` or `REDCapFile`) must have one.
"""
function normalize_data(data::TableData, format, allowed_formats::Vector{Symbol})
    format === nothing || throw(ArgumentError("`format` is not accepted with table data"))
    isempty(data.rows) && throw(ArgumentError("`data` contains no rows"))
    return data
end

function normalize_data(data, format, allowed_formats::Vector{Symbol})
    if data isa IO || data isa REDCapFile
        format === nothing &&
            throw(ArgumentError("`format` is required when `data` is an IO or REDCapFile (one of $(join(repr.(allowed_formats), ", ")))"))
        fmt = format isa Union{Symbol, AbstractString} ? Symbol(format) : nothing
        fmt in allowed_formats ||
            throw(ArgumentError("invalid `format` $(repr(format)) for this method; expected one of $(join(repr.(allowed_formats), ", "))"))
        payload = data isa REDCapFile ? read(data.path, String) : read(data, String)
        return RawData(String(fmt), payload)
    end
    format === nothing ||
        throw(ArgumentError("`format` is only accepted with IO or REDCapFile data; tables and rows are always sent as JSON"))
    rows = normalize_rows(data)
    isempty(rows) && throw(ArgumentError("`data` contains no rows"))
    return TableData(rows)
end

normalize_rows(::AbstractString) = throw(ArgumentError(STRING_DATA_ERROR))
# A NamedTuple or Dict whose values are all vectors is a column table; otherwise it is a row.
function normalize_rows(x::Union{NamedTuple, AbstractDict})
    is_column_table(x) && return column_rows(x)
    return [as_row(x)]
end

is_column_table(x) = !isempty(x) && all(v -> v isa AbstractVector, values(x))

"""
    column_rows(columns) -> Vector{Row}

Split `columns`, a `NamedTuple` or `AbstractDict` of equal-length vectors, into rows.
Unlike `Tables.rows`, this accepts any key and value types, e.g. a `Dict{String,Any}`.
"""
function column_rows(columns)
    names = [string(k) for k in keys(columns)]
    cols = collect(values(columns))
    n = length(first(cols))
    all(c -> length(c) == n, cols) || throw(ArgumentError(
        "the column vectors in `data` must all have the same length; got lengths " *
        join((string(name, " => ", length(c)) for (name, c) in zip(names, cols)), ", ")))
    return Row[Row([name => v for (name, v) in zip(names, vals)]) for vals in zip(cols...)]
end

function normalize_rows(v::AbstractVector)
    all(x -> x isa Union{NamedTuple, AbstractDict}, v) && return Row[as_row(x) for x in v]
    Tables.istable(v) && return table_rows(v)
    throw(ArgumentError("`data` vector must contain rows (NamedTuples or Dicts)"))
end

function normalize_rows(x)
    Tables.istable(x) && return table_rows(x)
    throw(ArgumentError("unsupported `data` of type $(typeof(x)); pass a Tables.jl table, a row (NamedTuple or Dict), a vector of rows, an IO, or a REDCapFile"))
end

as_row(d::AbstractDict) = Row([string(k) => v for (k, v) in pairs(d)])
as_row(nt::NamedTuple) = Row([String(k) => v for (k, v) in pairs(nt)])

function table_rows(table)
    rows = Row[]
    for r in Tables.rows(table)
        push!(rows, Row([String(n) => Tables.getcolumn(r, n) for n in Tables.columnnames(r)]))
    end
    return rows
end

"""
Layouts of `Date` values for each `dateFormat`. REDCap expects dashes with the default
`YMD`, and forward slashes with `MDY` and `DMY`.
"""
const DATE_LAYOUTS = Dict(
    "YMD" => dateformat"yyyy-mm-dd",
    "MDY" => dateformat"mm/dd/yyyy",
    "DMY" => dateformat"dd/mm/yyyy",
)

const DEFAULT_DATE_LAYOUT = DATE_LAYOUTS["YMD"]

"""
    rows_to_json(rows, dates=DEFAULT_DATE_LAYOUT) -> String

Serialize rows as a JSON array of objects, keeping column order. `Date` values are
written with the layout `dates` (see `DATE_LAYOUTS`).
"""
function rows_to_json(rows::AbstractVector{Row}, dates::DateFormat = DEFAULT_DATE_LAYOUT)
    io = IOBuffer()
    print(io, '[')
    for (i, row) in enumerate(rows)
        i > 1 && print(io, ',')
        write_row(io, row, dates)
    end
    print(io, ']')
    return String(take!(io))
end

"""
    row_to_json(row, dates=DEFAULT_DATE_LAYOUT) -> String

Serialize one row as a JSON object, keeping column order. `Date` values are written with
the layout `dates`.
"""
row_to_json(row::Row, dates::DateFormat = DEFAULT_DATE_LAYOUT) = sprint(write_row, row, dates)

function write_row(io::IO, row::Row, dates::DateFormat)
    print(io, '{')
    for (j, (k, v)) in enumerate(row)
        j > 1 && print(io, ',')
        JSON.json(io, k)
        print(io, ':')
        write_value(io, k, v, dates)
    end
    return print(io, '}')
end

# Values are sent as JSON strings, as REDCap itself exports them. Nested dicts and vectors
# (e.g. user rights `forms`) are written as JSON objects and arrays.
write_value(io, k, v::AbstractString, dates) = JSON.json(io, String(v))
write_value(io, k, v::Symbol, dates) = JSON.json(io, String(v))
write_value(io, k, v::Bool, dates) = JSON.json(io, v ? "1" : "0")
write_value(io, k, v::Integer, dates) = JSON.json(io, string(v))
write_value(io, k, v::AbstractFloat, dates) =
    isfinite(v) ? JSON.json(io, decimal_string(v)) : throw(ArgumentError("value of `$k` is not finite: $v"))
write_value(io, k, ::Union{Missing, Nothing}, dates) = JSON.json(io, "")
write_value(io, k, v::Date, dates) = JSON.json(io, Dates.format(v, dates))

function write_value(io, k, v::AbstractDict, dates)
    print(io, '{')
    for (j, (kk, vv)) in enumerate(pairs(v))
        j > 1 && print(io, ',')
        JSON.json(io, string(kk))
        print(io, ':')
        write_value(io, kk, vv, dates)
    end
    return print(io, '}')
end

function write_value(io, k, v::AbstractVector, dates)
    print(io, '[')
    for (j, vv) in enumerate(v)
        j > 1 && print(io, ',')
        write_value(io, k, vv, dates)
    end
    return print(io, ']')
end

"""
    decimal_string(x::AbstractFloat) -> String

Format a finite `x` in plain decimal notation, as REDCap's number validation expects: the
shortest digits that round-trip, with no exponent and no trailing `.0` (`1e-5` becomes
`"0.00001"`, `30.0` becomes `"30"`, and `-0.0` becomes `"0"`).
"""
function decimal_string(x::AbstractFloat)
    s = string(x)
    m = match(r"^(-?)(\d+)(?:\.(\d*))?(?:[eEf]([+-]?\d+))?$", s)
    m === nothing && throw(ArgumentError("cannot write $(repr(x)) ($(typeof(x))) in decimal notation"))
    intpart, fracpart = m[2], something(m[3], "")
    mantissa = intpart * fracpart
    point = length(intpart) + (m[4] === nothing ? 0 : parse(Int, m[4]))  # digits before the point
    first_nonzero = findfirst(!=('0'), mantissa)
    first_nonzero === nothing && return "0"
    mantissa = rstrip(mantissa[first_nonzero:end], '0')
    point -= first_nonzero - 1
    body = if point <= 0
        "0." * "0"^(-point) * mantissa
    elseif point >= length(mantissa)
        mantissa * "0"^(point - length(mantissa))
    else
        mantissa[1:point] * "." * mantissa[(point + 1):end]
    end
    return m[1] * body
end

write_value(io, k, v, dates) = throw(
    ArgumentError(
        "unsupported value for `$k`: $(repr(v)) ($(typeof(v))). " *
            "Convert it to a String in the format REDCap expects (e.g. DateTime values)",
    ),
)
