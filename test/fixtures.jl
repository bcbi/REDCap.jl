# Tier 3: replay REDCap responses stored in test/fixtures/ (hand-written from the documented
# formats, or recorded with RecordingTransport during live runs) through MockTransport,
# and check that each converts to the method's declared return type.

using REDCap: load_fixture, handle_response, send_request

const FIXTURE_DIR = joinpath(@__DIR__, "fixtures")

const KIND_TYPES = Dict(
    :table => REDCapTable, :dict => Dict{String, Any}, :string => String, :version => VersionNumber,
    :int => Int, :ids => Vector{String}, :file => REDCapDownload, :xml => String,
    :client => REDCapProject, :folder => Int, :nothing => Nothing,
)

fixture_files() = sort([joinpath(root, f) for (root, _, files) in walkdir(FIXTURE_DIR) for f in files if endswith(f, ".json")])

@test !isempty(fixture_files())

@testset "$(relpath(path, FIXTURE_DIR))" for path in fixture_files()
    method, req, resp, fixture = load_fixture(path)
    @test haskey(REDCap.SPECS_BY_NAME, method)
    spec = method_spec(method)
    # the recorded request matches the spec
    @test field(req, "content") == String(spec.content)
    @test field(req, "action") == (spec.action === nothing ? nothing : String(spec.action))
    # no token was recorded
    @test !any(p -> first(p) == "token" && last(p) != "0"^32, req.fields)

    t = MockTransport(_ -> resp)
    client = spec.client === REDCapSuperUser ? superuser(t) : project(t)
    replayed = send_request(t, req)
    @test only(t.requests) === req
    expect = get(fixture, "expect", Dict{String, Any}())
    if !(200 <= replayed.status < 300)
        err = try
            handle_response(spec, client, replayed)
        catch e
            e
        end
        @test err isa REDCapError
        @test err.status == replayed.status
        haskey(expect, "message") && @test err.message == expect["message"]
        continue
    end
    result = handle_response(spec, client, replayed)
    @test result isa KIND_TYPES[spec.returns]
    haskey(expect, "type") && @test Symbol(expect["type"]) === spec.returns
    if result isa REDCapTable
        haskey(expect, "columns") && @test Tables.columnnames(result) == Symbol.(expect["columns"])
        haskey(expect, "nrows") && @test size(result, 1) == expect["nrows"]
        if haskey(expect, "cell")
            col, row, value = expect["cell"]
            @test result[Symbol(col)][row] == value
        end
        if haskey(expect, "dict_cell")
            col, row, key = expect["dict_cell"]
            @test result[Symbol(col)][row] isa Dict{String, Any}
            @test haskey(result[Symbol(col)][row], key)
        end
    elseif result isa Dict
        haskey(expect, "key") && @test result[expect["key"][1]] == expect["key"][2]
    elseif result isa REDCapDownload
        haskey(expect, "filename") && @test result.filename == expect["filename"]
        haskey(expect, "mime") && @test result.mime == expect["mime"]
        haskey(expect, "nbytes") && @test length(result.data) == expect["nbytes"]
    elseif result isa VersionNumber
        haskey(expect, "value") && @test result == VersionNumber(expect["value"])
    elseif haskey(expect, "value")
        @test result == expect["value"]
    end
end

@testset "recording round trip" begin
    dir = mktempdir()
    token = MARKED_TOKEN
    pdf = UInt8[0x25, 0x50, 0x00, 0xff]
    inner = MockTransport() do req
        field(req, "content") == "file" &&
            return REDCapResponse(200, ["Content-Type" => "application/pdf; name=\"a.pdf\"", "Set-Cookie" => "secret"], pdf)
        return ok("""[{"record_id":"1","note":"token was $token"}]""")
    end
    p = project(RecordingTransport(inner, dir); token)
    export_records(p; fields = :record_id)
    export_file(p; record = 1, field = :f)
    files = joinpath.(dir, ["export_records-001.json", "export_file-002.json"])
    @test sort(readdir(dir; join = true)) == sort(files)
    for f in files
        text = read(f, String)
        @test !occursin(token, text)
        @test !occursin("secret", text)
    end
    _, req, resp, fixture = load_fixture(files[1])
    @test fixture["source"] == "recorded"
    @test field(req, "fields[0]") == "record_id"
    @test occursin("<redacted>", String(copy(resp.body)))
    _, _, resp, _ = load_fixture(files[2])
    @test resp.body == pdf
    @test handle_response(method_spec(:export_file), p, resp).filename == "a.pdf"

    # create_project's new token is replaced
    dir = mktempdir()
    new_token = "ABCDEF0123456789"^2
    s = REDCapSuperUser(; url = URL, token = SUPER_TOKEN, transport = RecordingTransport(always(ok(new_token)), dir))
    @test create_project(s; data = (project_title = "x",)).token == new_token
    text = read(only(readdir(dir; join = true)), String)
    @test !occursin(new_token, text) && !occursin(SUPER_TOKEN, text)
end
