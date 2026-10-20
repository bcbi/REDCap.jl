"""
    REDCapTable

The column table returned by every table-valued export. It implements the Tables.jl
interface, so it can be passed to any Tables.jl sink, e.g. `DataFrame(t)`.

Values are kept exactly as REDCap sends them: usually `String`s (empty strings stay
empty strings), with nested JSON objects as `Dict{String,Any}` cells. A cell is `missing`
only when REDCap omitted that key from a row entirely.

Access a column with `t[:name]` or `Tables.getcolumn(t, :name)`.
"""
struct REDCapTable
    names::Vector{Symbol}
    columns::Vector{AbstractVector}
    index::Dict{Symbol, Int}
    function REDCapTable(names::Vector{Symbol}, columns::Vector{<:AbstractVector})
        length(names) == length(columns) || throw(ArgumentError("number of names and columns differ"))
        allunique(names) || throw(ArgumentError("column names must be unique"))
        isempty(columns) || allequal(length.(columns)) || throw(ArgumentError("columns must have equal lengths"))
        return new(names, AbstractVector[c for c in columns], Dict(n => i for (i, n) in enumerate(names)))
    end
end

REDCapTable() = REDCapTable(Symbol[], AbstractVector[])

Tables.istable(::Type{REDCapTable}) = true
Tables.columnaccess(::Type{REDCapTable}) = true
Tables.columns(t::REDCapTable) = t
Tables.columnnames(t::REDCapTable) = getfield(t, :names)
Tables.getcolumn(t::REDCapTable, i::Int) = getfield(t, :columns)[i]
Tables.getcolumn(t::REDCapTable, name::Symbol) = getfield(t, :columns)[getfield(t, :index)[name]]
Tables.schema(t::REDCapTable) = Tables.Schema(getfield(t, :names), map(eltype, getfield(t, :columns)))

nrows(t::REDCapTable) = isempty(getfield(t, :columns)) ? 0 : length(first(getfield(t, :columns)))

Base.size(t::REDCapTable) = (nrows(t), length(getfield(t, :names)))
Base.size(t::REDCapTable, d::Integer) = d == 1 ? nrows(t) : d == 2 ? length(getfield(t, :names)) : d >= 3 ? 1 : throw(ArgumentError("dimension must be ≥ 1"))
Base.getindex(t::REDCapTable, name::Symbol) = Tables.getcolumn(t, name)
Base.isempty(t::REDCapTable) = nrows(t) == 0
Base.:(==)(a::REDCapTable, b::REDCapTable) =
    getfield(a, :names) == getfield(b, :names) && isequal(getfield(a, :columns), getfield(b, :columns))

function Base.show(io::IO, t::REDCapTable)
    n, m = size(t)
    return print(io, "REDCapTable(", n, " rows × ", m, " columns)")
end

function Base.show(io::IO, ::MIME"text/plain", t::REDCapTable)
    show(io, t)
    names = getfield(t, :names)
    isempty(names) && return
    shown = first(names, 10)
    print(io, "\n  columns: ", join(shown, ", "), length(names) > 10 ? ", …" : "")
    return nothing
end

"""
    table_from_rows(rows) -> REDCapTable

Build a table from parsed JSON objects (one per row). Column order is the order in which
keys first appear. Columns are narrowed to `Vector{String}` when every value is a string.
"""
function table_from_rows(rows::AbstractVector)
    names = String[]
    seen = Set{String}()
    for row in rows
        for k in keys(row)
            k in seen || (push!(seen, k); push!(names, k))
        end
    end
    columns = AbstractVector[]
    for name in names
        col = Any[haskey(row, name) ? plain_json(row[name]) : missing for row in rows]
        push!(columns, narrow(col))
    end
    return REDCapTable(Symbol.(names), columns)
end

function narrow(col::Vector{Any})
    all(x -> x isa String, col) && return convert(Vector{String}, col)
    all(x -> x isa String || x === missing, col) && return convert(Vector{Union{Missing, String}}, col)
    return col
end

"""
    plain_json(x)

Convert parsed JSON into plain Julia values: objects become `Dict{String,Any}`,
arrays `Vector{Any}`, strings `String`.
"""
plain_json(x::AbstractDict) = Dict{String, Any}(String(k) => plain_json(v) for (k, v) in x)
plain_json(x::AbstractVector) = Any[plain_json(v) for v in x]
plain_json(x::AbstractString) = String(x)
plain_json(x) = x

"""
    vcat_tables(tables) -> REDCapTable

Concatenate tables row-wise. Tables with no columns (REDCap's `[]`) are skipped.
Throws `ArgumentError` if the remaining tables' column names differ.
"""
function vcat_tables(tables::AbstractVector{REDCapTable})
    tables = filter(t -> !isempty(getfield(t, :names)), tables)
    isempty(tables) && return REDCapTable()
    names = getfield(first(tables), :names)
    for t in tables
        getfield(t, :names) == names ||
            throw(ArgumentError("cannot combine tables with different columns: $(names) vs $(getfield(t, :names))"))
    end
    columns = AbstractVector[narrow(Any[x for t in tables for x in Tables.getcolumn(t, i)]) for i in eachindex(names)]
    return REDCapTable(copy(names), columns)
end
