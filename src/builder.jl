#
# Request builder: client + spec + user arguments -> REDCapRequest. Pure, no I/O
# (except reading a REDCapFile the user explicitly passed). Validates everything.
#

"Marks that no `data` argument was given."
struct NoData end

"""
    build_request(client, spec, params; data=NoData(), format=nothing, io=false,
                  file=nothing, filename=nothing) -> REDCapRequest

Build and validate the request for `spec`. `params` holds the user's REDCap parameters;
entries whose value is `nothing` are treated as not given. For imports, `data` and
`format` describe the import data; for IO exports (`io=true`), `format` is the output
format. For uploads, `file` (an `IO` or `REDCapFile`) and `filename` describe the file.

Throws `ArgumentError` for a wrong client type, unknown, missing or invalid parameters, or
`data` that the method doesn't take or requires.
"""
function build_request(
        client::AbstractREDCapClient, spec::MethodSpec, params::NamedTuple;
        data = NoData(), format = nothing, io::Bool = false, file = nothing, filename = nothing,
    )
    client isa spec.client ||
        throw(ArgumentError("$(spec.name) requires a $(spec.client), got a $(typeof(client))"))
    io && !spec.raw_io && throw(ArgumentError("$(spec.name) has no IO method"))

    allowed = Set{Symbol}(vcat(spec.required, spec.optional))
    io && union!(allowed, spec.io_optional)
    given = Pair{Symbol, Any}[k => v for (k, v) in pairs(params) if v !== nothing]
    for (k, _) in given
        k in allowed || throw(ArgumentError("$(spec.name) does not accept the parameter `$k`"))
    end
    for k in spec.required
        any(p -> first(p) == k, given) || throw(ArgumentError("$(spec.name) requires the parameter `$k`"))
    end

    fixed = copy(spec.fixed)
    payload = nothing
    if spec.data == :required
        data isa NoData && throw(ArgumentError("$(spec.name) requires `data`"))
        normalized = normalize_data(data, format, spec.data_formats)
        if spec.single_row && normalized isa TableData && length(normalized.rows) != 1
            throw(ArgumentError("$(spec.name) requires `data` with exactly one row, got $(length(normalized.rows))"))
        end
        if normalized isa RawData
            push!(fixed, :format => normalized.format)
            payload = normalized.payload
        else
            push!(fixed, :format => :json)
            payload = rows_to_json(normalized.rows)
        end
    else
        data isa NoData || throw(ArgumentError("$(spec.name) does not accept `data`"))
        if io && isempty(spec.io_formats)
            format === nothing || throw(ArgumentError("$(spec.name) does not accept `format`"))
        elseif io
            format === nothing && throw(ArgumentError("$(spec.name) to an IO requires `format`"))
            (format isa Union{Symbol, AbstractString} && Symbol(format) in spec.io_formats) ||
                throw(ArgumentError("invalid `format` $(repr(format)) for $(spec.name); expected one of $(join(repr.(spec.io_formats), ", "))"))
            filter!(p -> first(p) != :format, fixed)
            push!(fixed, :format => Symbol(format))
        else
            format === nothing || throw(ArgumentError("$(spec.name) accepts `format` only when writing to an IO"))
        end
    end

    upload = spec.upload ? build_upload(spec, file, filename) : nothing
    if !spec.upload && (file !== nothing || filename !== nothing)
        throw(ArgumentError("$(spec.name) does not upload a file"))
    end

    fields = Pair{String, String}["token" => client.token, "content" => String(spec.content)]
    spec.action === nothing || push!(fields, "action" => String(spec.action))
    for (k, v) in fixed
        append!(fields, encode_param(param_kind(spec.overrides, k), k, v))
    end
    for (k, v) in given
        append!(fields, encode_param(param_kind(spec.overrides, k), k, v))
    end
    payload === nothing || push!(fields, "data" => payload)
    return REDCapRequest(spec.name, client.url, fields, upload)
end

function build_upload(spec::MethodSpec, file, filename)
    file === nothing && throw(ArgumentError("$(spec.name) requires `file`"))
    filename === nothing || filename isa AbstractString ||
        throw(ArgumentError("`filename` must be a String"))
    if file isa REDCapFile
        name = something(filename, basename(file.path))
        content = read(file.path)
    elseif file isa IO
        filename === nothing && throw(ArgumentError("`filename` is required when `file` is an IO"))
        name = filename
        content = read(file)
    elseif file isa AbstractString
        throw(ArgumentError("a String is not accepted as `file`; pass `REDCapFile(path)` or an IO with `filename`"))
    else
        throw(ArgumentError("`file` must be a REDCapFile or an IO, got $(typeof(file))"))
    end
    isempty(name) && throw(ArgumentError("`filename` must not be empty"))
    return REDCapUpload("file", String(name), content, "application/octet-stream")
end
