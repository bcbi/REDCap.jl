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
normalize_rows(row::AbstractDict) = [as_row(row)]

function normalize_rows(nt::NamedTuple)
    if !isempty(nt) && all(v -> v isa AbstractVector, values(nt))
        return table_rows(nt)  # a NamedTuple of vectors is a column table
    end
    return [as_row(nt)]
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
    rows_to_json(rows) -> String

Serialize rows as a JSON array of objects, keeping column order.
"""
function rows_to_json(rows::AbstractVector{Row})
    io = IOBuffer()
    print(io, '[')
    for (i, row) in enumerate(rows)
        i > 1 && print(io, ',')
        write_row(io, row)
    end
    print(io, ']')
    return String(take!(io))
end

"""
    row_to_json(row) -> String

Serialize one row as a JSON object, keeping column order.
"""
row_to_json(row::Row) = sprint(write_row, row)

function write_row(io::IO, row::Row)
    print(io, '{')
    for (j, (k, v)) in enumerate(row)
        j > 1 && print(io, ',')
        JSON.json(io, k)
        print(io, ':')
        write_value(io, k, v)
    end
    return print(io, '}')
end

# Values are sent as JSON strings, as REDCap itself exports them. Nested dicts and vectors
# (e.g. user rights `forms`) are written as JSON objects and arrays.
write_value(io, k, v::AbstractString) = JSON.json(io, String(v))
write_value(io, k, v::Symbol) = JSON.json(io, String(v))
write_value(io, k, v::Bool) = JSON.json(io, v ? "1" : "0")
write_value(io, k, v::Integer) = JSON.json(io, string(v))
write_value(io, k, v::AbstractFloat) =
    isfinite(v) ? JSON.json(io, string(v)) : throw(ArgumentError("value of `$k` is not finite: $v"))
write_value(io, k, ::Union{Missing, Nothing}) = JSON.json(io, "")
write_value(io, k, v::Date) = JSON.json(io, Dates.format(v, dateformat"yyyy-mm-dd"))

function write_value(io, k, v::AbstractDict)
    print(io, '{')
    for (j, (kk, vv)) in enumerate(pairs(v))
        j > 1 && print(io, ',')
        JSON.json(io, string(kk))
        print(io, ':')
        write_value(io, kk, vv)
    end
    return print(io, '}')
end

function write_value(io, k, v::AbstractVector)
    print(io, '[')
    for (j, vv) in enumerate(v)
        j > 1 && print(io, ',')
        write_value(io, k, vv)
    end
    return print(io, ']')
end

write_value(io, k, v) = throw(
    ArgumentError(
        "unsupported value for `$k`: $(repr(v)) ($(typeof(v))). " *
            "Convert it to a String in the format REDCap expects (e.g. DateTime values)",
    ),
)
