#
# The shared machinery behind every public function: build, send, handle.
#

function send_logged(client::AbstractREDCapClient, req::REDCapRequest)
    @debug "REDCap request" method = req.method url = string(req.url) fields = redacted_fields(req)
    resp = send_request(client.transport, req)
    @debug "REDCap response" method = req.method status = resp.status bytes = length(resp.body)
    return resp
end

function check_batch_kwargs(spec::MethodSpec, batchsize, recordIdField)
    batchsize === nothing && recordIdField === nothing && return false
    spec.batchable || throw(ArgumentError("$(spec.name) does not support batching"))
    batchsize === nothing && throw(ArgumentError("`recordIdField` is only used together with `batchsize`"))
    return true
end

"""
    api_call(name, client; data=NoData(), format=nothing, file=nothing, filename=nothing,
             batchsize=nothing, recordIdField=nothing, params...)

Run the API function `name`: build the request from its spec, send it with the client's
transport and convert the response to the declared return type. With `batchsize`, run it
as a sequence of batches (see `batched_call`).
"""
function api_call(
        name::Symbol, client::AbstractREDCapClient;
        data = NoData(), format = nothing, file = nothing, filename = nothing,
        batchsize = nothing, recordIdField = nothing, params...,
    )
    spec = method_spec(name)
    if check_batch_kwargs(spec, batchsize, recordIdField)
        return batched_call(spec, client, batchsize; data, format, recordIdField, params...)
    end
    req = build_request(client, spec, NamedTuple(params); data, format, file, filename)
    return handle_response(spec, client, send_logged(client, req))
end

"""
    api_call_io(name, client, io; format=nothing, batchsize=nothing, params...)

Like `api_call`, but write the raw response body to `io` and return `nothing`.
"""
function api_call_io(name::Symbol, client::AbstractREDCapClient, io::IO; format = nothing, batchsize = nothing, params...)
    spec = method_spec(name)
    if check_batch_kwargs(spec, batchsize, nothing)
        return batched_export(spec, client, batchsize; io, format, params...)
    end
    req = build_request(client, spec, NamedTuple(params); format, io = true)
    resp = send_logged(client, req)
    check_status(spec, client, resp)
    write(io, resp.body)
    return nothing
end
