#
# Batching: a layer above single requests. Planning (record IDs, grouping rows, splitting
# into batches) is pure; every batch goes through the normal builder, transport and
# response handling. Batches run one at a time and stop at the first failure.
#

function check_batchsize(batchsize)
    (batchsize isa Integer && !(batchsize isa Bool) && batchsize >= 1) ||
        throw(ArgumentError("`batchsize` must be a positive Integer, got $(repr(batchsize))"))
    return Int(batchsize)
end

"Split `items` into consecutive chunks of at most `n`."
chunk(items::AbstractVector, n::Int) = [items[i:min(i + n - 1, end)] for i in 1:n:length(items)]

"Record names as REDCap receives them, validated like the `records` parameter."
record_strings(records) = String[last(p) for p in encode_param(ArrayParam(), :records, records)]

"""
    group_rows(rows, idfield) -> Vector{Pair{String,Vector{Row}}}

Group rows by record ID, in order of first appearance, so that all rows of one record
(events, repeat instances) stay together.
"""
function group_rows(rows::AbstractVector{Row}, idfield::AbstractString)
    order = String[]
    groups = Dict{String, Vector{Row}}()
    for (i, row) in enumerate(rows)
        j = findfirst(p -> first(p) == idfield, row)
        j === nothing && throw(ArgumentError("row $i has no `$idfield` column (the record ID field)"))
        value = last(row[j])
        (value === missing || value === nothing || value == "") &&
            throw(ArgumentError("row $i has an empty record ID in `$idfield`"))
        id = string(value)
        if !haskey(groups, id)
            push!(order, id)
            groups[id] = Row[]
        end
        push!(groups[id], row)
    end
    return [id => groups[id] for id in order]
end

"""
    plan_import_batches(rows, idfield, batchsize) -> Vector{Pair{Vector{String},Vector{Row}}}

Pack whole records into batches of at most `batchsize` records.
"""
function plan_import_batches(rows::AbstractVector{Row}, idfield::AbstractString, batchsize::Int)
    return [first.(b) => reduce(vcat, last.(b)) for b in chunk(group_rows(rows, idfield), batchsize)]
end

"""
    run_batches(f, id_batches) -> Vector

Call `f(k)` for each batch `k` in turn. If a batch throws a `REDCapError`, stop and throw a
`REDCapBatchError` describing the progress so far.
"""
function run_batches(f, id_batches::AbstractVector{<:AbstractVector{String}})
    results = Any[]
    done = String[]
    for (k, ids) in enumerate(id_batches)
        result = try
            f(k)
        catch e
            e isa REDCapError || rethrow()
            throw(REDCapBatchError(k - 1, copy(done), collect(String, ids), e))
        end
        push!(results, result)
        append!(done, ids)
    end
    return results
end

"The name of the project's record ID field: the first field of the data dictionary."
function record_id_field(client::REDCapProject)
    metadata = api_call(:export_metadata, client)
    (isempty(metadata) || !(:field_name in Tables.columnnames(metadata))) &&
        throw(REDCapError(200, "could not determine the record ID field from the data dictionary", :export_metadata))
    return String(first(metadata[:field_name]))
end

"""
    lookup_record_ids(client, params) -> Vector{String}

Export only the record ID field, with the user's `filterLogic`, date range and `events`
filters, and return the unique record IDs.
"""
function lookup_record_ids(client::REDCapProject, params::NamedTuple)
    idfield = record_id_field(client)
    t = api_call(
        :export_records, client; fields = [idfield],
        filterLogic = get(params, :filterLogic, nothing),
        dateRangeBegin = get(params, :dateRangeBegin, nothing),
        dateRangeEnd = get(params, :dateRangeEnd, nothing),
        events = get(params, :events, nothing),
    )
    isempty(t) && return String[]
    return unique(String.(t[Symbol(idfield)]))
end

"""
    batched_call(spec, client, batchsize; data, format, recordIdField, params...)

Run a batchable function in batches of `batchsize` records.
"""
function batched_call(spec::MethodSpec, client::AbstractREDCapClient, batchsize; data, format, recordIdField, params...)
    if spec.data == :required
        return batched_import(spec, client, batchsize; data, format, recordIdField, params...)
    end
    data isa NoData || throw(ArgumentError("$(spec.name) does not accept `data`"))
    recordIdField === nothing || throw(ArgumentError("$(spec.name) does not accept `recordIdField`"))
    spec.action === :delete && return batched_delete(spec, client, batchsize; format, params...)
    return batched_export(spec, client, batchsize; io = nothing, format, params...)
end

function batched_export(spec::MethodSpec, client::AbstractREDCapClient, batchsize; io, format, params...)
    n = check_batchsize(batchsize)
    params = NamedTuple(params)
    # Validate everything before any I/O.
    build_request(client, spec, merge(params, (records = ["1"],)); format, io = io !== nothing)
    if io !== nothing
        Symbol(format) in (:csv, :json) ||
            throw(ArgumentError("batched export to an IO supports only format=:csv or :json, not $(repr(format))"))
    end
    records = get(params, :records, nothing)
    ids = records === nothing ? lookup_record_ids(client, params) : unique(record_strings(records))
    id_batches = chunk(ids, n)
    if io === nothing
        tables = run_batches(k -> api_call(spec.name, client; params..., records = id_batches[k]), id_batches)
        return vcat_tables(REDCapTable[t for t in tables])
    end
    merger = Symbol(format) === :csv ? CSVMerger(io) : JSONMerger(io)
    run_batches(id_batches) do k
        buf = IOBuffer()
        api_call_io(spec.name, client, buf; format, params..., records = id_batches[k])
        add_part!(merger, take!(buf))
    end
    finish!(merger)
    return nothing
end

function batched_import(spec::MethodSpec, client::AbstractREDCapClient, batchsize; data, format, recordIdField, params...)
    n = check_batchsize(batchsize)
    data isa NoData && throw(ArgumentError("$(spec.name) requires `data`"))
    (data isa IO || data isa REDCapFile) &&
        throw(ArgumentError("`batchsize` works only with table data, not with IO or REDCapFile data"))
    recordIdField === nothing || recordIdField isa Union{AbstractString, Symbol} ||
        throw(ArgumentError("`recordIdField` must be a String or Symbol"))
    table = normalize_data(data, format, spec.data_formats)::TableData
    params = NamedTuple(params)
    # Validate the parameters before any I/O.
    build_request(client, spec, params; data = TableData(table.rows[1:1]))
    idfield = recordIdField === nothing ? record_id_field(client) : String(recordIdField)
    batches = plan_import_batches(table.rows, idfield, n)
    results = run_batches(k -> api_call(spec.name, client; params..., data = TableData(last(batches[k]))), first.(batches))
    return spec.returns === :ids ? reduce(vcat, results; init = String[]) : sum(results; init = 0)
end

function batched_delete(spec::MethodSpec, client::AbstractREDCapClient, batchsize; format, params...)
    n = check_batchsize(batchsize)
    params = NamedTuple(params)
    build_request(client, spec, params; format)
    id_batches = chunk(unique(record_strings(params.records)), n)
    results = run_batches(k -> api_call(spec.name, client; params..., records = id_batches[k]), id_batches)
    return sum(results; init = 0)
end

#
# Merging raw batch output into one CSV file or JSON array.
#

mutable struct CSVMerger
    io::IO
    first::Bool
end
CSVMerger(io::IO) = CSVMerger(io, true)

# Field names never contain newlines, so the header is exactly the first line.
function add_part!(m::CSVMerger, body::Vector{UInt8})
    if m.first
        write(m.io, body)
        m.first = false
    else
        i = findfirst(==(UInt8('\n')), body)
        i === nothing || write(m.io, @view body[(i + 1):end])
    end
    return nothing
end
finish!(::CSVMerger) = nothing

mutable struct JSONMerger
    io::IO
    count::Int
end
JSONMerger(io::IO) = (print(io, '['); JSONMerger(io, 0))

function add_part!(m::JSONMerger, body::Vector{UInt8})
    text = strip(String(body))
    (startswith(text, '[') && endswith(text, ']')) ||
        throw(REDCapError(200, "unexpected response in batched JSON export (expected a JSON array)", :export_records))
    inner = strip(text[2:prevind(text, lastindex(text))])
    isempty(inner) && return nothing
    m.count > 0 && print(m.io, ',')
    print(m.io, inner)
    m.count += 1
    return nothing
end
finish!(m::JSONMerger) = (print(m.io, ']'); nothing)
