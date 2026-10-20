@testset "construction and validation" begin
    p = project()
    @test p.url == REDCap.URI(URL)
    @test p.token == TOKEN
    @test p.transport isa MockTransport
    @test REDCapProject(; url = URL, token = TOKEN).transport isa HTTPTransport

    s = superuser()
    @test s isa REDCapSuperUser
    @test s isa AbstractREDCapClient

    # URL must be https://…/api/
    for bad in ["https://example.test/api", "https://example.test/", "example.test/api/", "ftp://example.test/api/", "https://example.test/api/x/", ""]
        @test_throws ArgumentError REDCapProject(; url = bad, token = TOKEN)
    end
    @test REDCapProject(; url = "https://example.test/redcap/api/", token = TOKEN).url == REDCap.URI("https://example.test/redcap/api/")
    @test_throws ArgumentError REDCapProject(; url = "http://example.test/api/", token = TOKEN)
    @test REDCapProject(; url = "http://example.test/api/", token = TOKEN, allow_insecure = true).url ==
        REDCap.URI("http://example.test/api/")

    # Tokens: uppercase hex, right length
    for bad in ["0"^31, "0"^33, "a"^32, "G"^32, "0"^64, ""]
        @test_throws ArgumentError REDCapProject(; url = URL, token = bad)
    end
    for bad in ["0"^32, "0"^63, "f"^64]
        @test_throws ArgumentError REDCapSuperUser(; url = URL, token = bad)
    end

    # The inner constructor validates too
    @test_throws ArgumentError REDCapProject(URL, "bad", MockTransport())
end

@testset "ENV fallback" begin
    withenv("REDCAP_API_URL" => URL, "REDCAP_API_TOKEN" => TOKEN, "REDCAP_API_SUPER_TOKEN" => SUPER_TOKEN) do
        @test REDCapProject().token == TOKEN
        @test REDCapSuperUser().token == SUPER_TOKEN
        # URL and token fall back independently
        @test REDCapProject(; token = MARKED_TOKEN).token == MARKED_TOKEN
        @test REDCapProject(; url = "https://other.test/api/").url == REDCap.URI("https://other.test/api/")
    end
    withenv("REDCAP_API_URL" => nothing, "REDCAP_API_TOKEN" => TOKEN) do
        err = try
            REDCapProject()
        catch e
            e
        end
        @test err isa ArgumentError
        @test occursin("REDCAP_API_URL", err.msg)
        @test REDCapProject(; url = URL).token == TOKEN
    end
    withenv("REDCAP_API_URL" => URL, "REDCAP_API_TOKEN" => nothing, "REDCAP_API_SUPER_TOKEN" => nothing) do
        err = try
            REDCapProject()
        catch e
            e
        end
        @test occursin("REDCAP_API_TOKEN", err.msg)
        err = try
            REDCapSuperUser()
        catch e
            e
        end
        @test occursin("REDCAP_API_SUPER_TOKEN", err.msg)
    end
    # ENV is read only at construction time
    p = withenv(() -> REDCapProject(), "REDCAP_API_URL" => URL, "REDCAP_API_TOKEN" => TOKEN)
    withenv("REDCAP_API_TOKEN" => MARKED_TOKEN) do
        @test p.token == TOKEN
    end
end

@testset "token redaction in show" begin
    p = project(; token = MARKED_TOKEN)
    for s in (sprint(show, p), sprint(show, MIME"text/plain"(), p), string(p), repr([p]))
        @test !occursin(MARKED_TOKEN, s)
        @test occursin("…ABCD", s)
    end
    @test sprint(show, p) == "REDCapProject(https://example.test/api/, token=…ABCD)"
    s = REDCapSuperUser(; url = URL, token = "0"^60 * "ABCD", transport = MockTransport())
    @test sprint(show, s) == "REDCapSuperUser(https://example.test/api/, token=…ABCD)"
end

@testset "token redaction in requests, errors and logs" begin
    t = always(REDCapResponse(400, """{"error":"bad token $(MARKED_TOKEN)"}"""))
    p = project(t; token = MARKED_TOKEN)
    logs = capture_debug_logs() do
        @test_throws REDCapError export_records(p)
    end
    @test !isempty(logs)
    for l in logs
        @test !occursin(MARKED_TOKEN, sprint(show, l.message) * sprint(show, l.kwargs))
    end
    err = try
        export_records(p)
    catch e
        e
    end
    @test !occursin(MARKED_TOKEN, err.message)
    @test !occursin(MARKED_TOKEN, sprint(showerror, err))
    @test !occursin(MARKED_TOKEN, sprint(show, first(t.requests)))
    # The request itself carries the real token
    @test field(first(t.requests), "token") == MARKED_TOKEN
end
