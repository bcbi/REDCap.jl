"""
    REDCapError <: Exception

Thrown when REDCap answers a request with a non-2xx HTTP status, or with a
response that can't be converted to the method's declared return type.

# Fields
- `status::Int`: the HTTP status code
- `message::String`: REDCap's error message, taken from its `{"error": "..."}` JSON body
  when present, otherwise the raw body text
- `method::Symbol`: the name of the REDCap.jl function that made the request

The API token never appears in a `REDCapError`.
"""
struct REDCapError <: Exception
    status::Int
    message::String
    method::Symbol
end

function Base.showerror(io::IO, e::REDCapError)
    return print(io, "REDCapError: ", e.method, " failed (HTTP ", e.status, "): ", e.message)
end

"""
    REDCapBatchError <: Exception

Thrown when one batch of a batched call (`batchsize=...`) fails. Batched calls are **not
atomic**: the batches before the failed one stay applied.

# Fields
- `completed_batches::Int`: the number of batches that succeeded
- `processed_records::Vector{String}`: the record names in those batches
- `failed_records::Vector{String}`: the record names in the batch that failed
- `error::REDCapError`: the failed batch's error
"""
struct REDCapBatchError <: Exception
    completed_batches::Int
    processed_records::Vector{String}
    failed_records::Vector{String}
    error::REDCapError
end

function Base.showerror(io::IO, e::REDCapBatchError)
    print(io, "REDCapBatchError: batch ", e.completed_batches + 1, " failed after ", e.completed_batches)
    print(io, " completed batch(es) (", length(e.processed_records), " records processed, ")
    print(io, length(e.failed_records), " records in the failed batch). Earlier batches remain applied.\n")
    return showerror(io, e.error)
end

const REDACTED = "<redacted>"

redact_token(text::AbstractString, token::AbstractString) =
    isempty(token) ? String(text) : replace(String(text), token => REDACTED)

token_suffix(token::AbstractString) = "…" * last(token, 4)
