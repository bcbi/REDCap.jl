using REDCap
using REDCap: REDCapResponse, REDCapRequest, METHOD_SPECS, method_spec
using Dates
using Logging
using Tables
using Test

const URL = "https://example.test/api/"
const TOKEN = "0"^32
const SUPER_TOKEN = "0"^64
# A token with a recognizable suffix, for redaction tests
const MARKED_TOKEN = "0"^28 * "ABCD"

ok(body::AbstractString) = REDCapResponse(200, body)
ok(body::Vector{UInt8}) = REDCapResponse(200, Pair{String, String}[], body)

mock(responses::REDCapResponse...) = MockTransport(responses...)
project(transport = MockTransport(); token = TOKEN) = REDCapProject(; url = URL, token, transport)
superuser(transport = MockTransport()) = REDCapSuperUser(; url = URL, token = SUPER_TOKEN, transport)

"A MockTransport that answers every request with the same response."
always(resp::REDCapResponse) = MockTransport(_ -> resp)

fields(req::REDCapRequest) = Dict(req.fields)
field(req::REDCapRequest, name) = REDCap.field_value(req, name)

"""
The keyword argument names of a method. `Base.kwarg_decl` is internal, so its use is
isolated here.
"""
kwarg_names(m::Method) = Set{Symbol}(Base.kwarg_decl(m))

"An example valid value for a parameter kind."
example_value(::REDCap.StringParam) = "x"
example_value(::REDCap.IntParam) = 1
example_value(k::REDCap.BoolParam) = true
example_value(::REDCap.DateTimeParam) = DateTime(2024, 1, 2, 3, 4, 5)
example_value(::REDCap.ArrayParam) = ["x"]
example_value(k::REDCap.EnumParam) = Symbol(first(k.values))

example_param(spec, name) = example_value(REDCap.param_kind(spec.overrides, name))

"A plausible successful response body for a return kind."
function fake_body(kind::Symbol)
    kind === :table && return """[{"record_id":"1"}]"""
    kind === :dict && return """{"project_id":"1"}"""
    kind === :ids && return """["1"]"""
    kind === :int && return "1"
    kind === :version && return "15.0.1"
    kind === :string && return "x"
    kind === :xml && return "<ODM/>"
    kind === :nothing && return "1"
    kind === :file && return "%PDF-fake"
    kind === :client && return "ABCDEF0123456789"^2
    kind === :folder && return """[{"folder_id":"5"}]"""
    error("no fake body for $kind")
end

"The client a spec's function is called with."
client_for(spec, transport) = spec.client === REDCapSuperUser ? superuser(transport) : project(transport)

"Minimal valid keyword arguments for a spec's function (without data)."
function minimal_kwargs(spec)
    kwargs = NamedTuple(k => example_param(spec, k) for k in spec.required)
    spec.upload && (kwargs = merge(kwargs, (file = IOBuffer("contents"), filename = "x.txt")))
    return kwargs
end

"Keyword arguments for calling a spec's IO method."
io_kwargs(spec) = isempty(spec.io_formats) ? minimal_kwargs(spec) : merge(minimal_kwargs(spec), (format = first(spec.io_formats),))

const EXAMPLE_ROW = (record_id = "1", age = "63")

api_function(spec) = getfield(REDCap, spec.name)

function capture_debug_logs(f)
    logger = Test.TestLogger(min_level = Logging.Debug)
    with_logger(f, logger)
    return logger.logs
end
