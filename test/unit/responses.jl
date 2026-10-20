call_with(resp, f, args...; kwargs...) = f(project(always(resp)), args...; kwargs...)

@testset "table" begin
    t = call_with(ok("""[{"record_id":"1","age":""},{"record_id":"2","age":"7"}]"""), export_records)
    @test t isa REDCapTable
    @test Tables.columnnames(t) == [:record_id, :age]
    @test t[:age] == ["", "7"]          # empty strings stay strings
    @test t[:age] isa Vector{String}
    @test size(t) == (2, 2)
    # an empty export
    t = call_with(ok("[]"), export_records)
    @test size(t) == (0, 0)
    # nested JSON becomes Dict cells; missing keys become missing
    t = call_with(ok("""[{"a":"1","forms":{"demo":"1"}},{"a":"2"}]"""), export_metadata)
    @test t[:forms][1] == Dict("demo" => "1")
    @test t[:forms][1] isa Dict{String, Any}
    @test ismissing(t[:forms][2])
    @test_throws REDCapError call_with(ok("""{"a":"1"}"""), export_records)
    @test_throws REDCapError call_with(ok("not json"), export_records)
end

@testset "int" begin
    @test call_with(ok("3"), delete_records; records = 1) === 3
    @test call_with(ok(" 3\n"), delete_records; records = 1) === 3
    @test call_with(ok("""{"count": 4}"""), import_records; data = EXAMPLE_ROW) === 4
    @test call_with(ok("""{"count": "5"}"""), import_records; data = EXAMPLE_ROW) === 5
    @test_throws REDCapError call_with(ok("""{"count": "x"}"""), import_records; data = EXAMPLE_ROW)
    @test_throws REDCapError call_with(ok("ok"), import_metadata; data = EXAMPLE_ROW)
end

@testset "ids" begin
    @test call_with(ok("""["1","2"]"""), import_records_ids; data = EXAMPLE_ROW) == ["1", "2"]
    @test call_with(ok("""[1, 2]"""), import_records_ids; data = EXAMPLE_ROW) == ["1", "2"]
    @test_throws REDCapError call_with(ok("""{"count":1}"""), import_records_ids; data = EXAMPLE_ROW)
end

@testset "string, version, nothing" begin
    @test call_with(ok("101\n"), generate_next_record_name) == "101"
    @test call_with(ok("15.0.1"), export_version) == v"15.0.1"
    @test export_version(superuser(always(ok("15.0.1")))) == v"15.0.1"
    @test_throws REDCapError call_with(ok("<html>"), export_version)
    @test call_with(ok("1"), rename_record; record = 1, new_record_name = 2) === nothing
end

@testset "errors" begin
    for status in (400, 401, 403, 404, 500)
        err = try
            call_with(REDCapResponse(status, """{"error":"You do not have permissions"}"""), export_records)
        catch e
            e
        end
        @test err isa REDCapError
        @test err.status == status
        @test err.message == "You do not have permissions"
        @test err.method === :export_records
        @test occursin("HTTP $status", sprint(showerror, err))
    end
    # non-JSON error bodies are kept as text
    err = try
        call_with(REDCapResponse(502, "<html>Bad gateway</html>"), export_version)
    catch e
        e
    end
    @test err.message == "<html>Bad gateway</html>"
    err = try
        call_with(REDCapResponse(500, ""), export_version)
    catch e
        e
    end
    @test err.status == 500
    # an error object with a 200 status is still an error
    @test_throws REDCapError call_with(ok("""{"error":"oops"}"""), export_records)
end

@testset "raw IO methods" begin
    csv = "record_id,age\n1,15\n"
    t = always(ok(csv))
    io = IOBuffer()
    @test export_records(project(t), io; format = :csv, fields = :age, rawOrLabelHeaders = :label) === nothing
    @test String(take!(io)) == csv
    req = last(t.requests)
    @test field(req, "format") == "csv"
    @test field(req, "rawOrLabelHeaders") == "label"
    @test field(req, "fields[0]") == "age"

    io = IOBuffer()
    @test export_metadata(project(always(ok("<xml/>"))), io; format = :xml) === nothing
    @test String(take!(io)) == "<xml/>"

    # errors are thrown, not written
    io = IOBuffer()
    @test_throws REDCapError export_records(project(always(REDCapResponse(403, """{"error":"no"}"""))), io; format = :csv)
    @test isempty(take!(io))
    @test_throws ArgumentError export_metadata(project(), IOBuffer(); format = :odm)
    @test_throws UndefKeywordError export_records(project(), IOBuffer())
end

@testset "binary files" begin
    pdf = UInt8[0x25, 0x50, 0x44, 0x46, 0x00, 0xff]
    resp = REDCapResponse(200, ["content-type" => "application/pdf; name=\"scan 1.pdf\";charset=UTF-8"], pdf)
    d = export_file(project(always(resp)); record = 1, field = :consent)
    @test d isa REDCapDownload
    @test d.filename == "scan 1.pdf"
    @test d.mime == "application/pdf"
    @test d.data == pdf
    @test occursin("6 bytes", sprint(show, d))
    # filename from Content-Disposition; missing headers
    resp = REDCapResponse(200, ["Content-Disposition" => "attachment; filename=\"a.txt\""], UInt8[0x41])
    @test export_file_from_file_repository(project(always(resp)); doc_id = 3).filename == "a.txt"
    d = export_PDF(project(always(ok(pdf))))
    @test d.filename == "" && d.mime == "application/octet-stream"
    # IO method writes the bytes
    io = IOBuffer()
    @test export_PDF_all_records(project(always(ok(pdf))), io) === nothing
    @test take!(io) == pdf
    @test_throws REDCapError export_file(project(always(REDCapResponse(404, """{"error":"no file"}"""))); record = 1, field = :f)
end

@testset "create_project returns a client" begin
    new_token = "ABCDEF0123456789"^2
    t = always(ok(new_token * "\n"))
    s = superuser(t)
    p = create_project(s; data = (project_title = "Test", purpose = 0))
    @test p isa REDCapProject
    @test p.token == new_token
    @test p.url == s.url
    @test p.transport === t
    req = only(t.requests)
    @test field(req, "token") == SUPER_TOKEN
    @test field(req, "data") == """[{"project_title":"Test","purpose":"0"}]"""
    # the response body is never echoed into the error
    err = try
        create_project(superuser(always(ok("not a token " * MARKED_TOKEN))); data = (project_title = "x",))
    catch e
        e
    end
    @test err isa REDCapError && !occursin(MARKED_TOKEN, err.message)
    # exactly one row
    @test_throws ArgumentError create_project(s; data = [(project_title = "a",), (project_title = "b",)])
    @test_throws MethodError create_project(project(); data = (project_title = "x",))
    # odm comes from an IO or REDCapFile, never a String
    create_project(s; data = (project_title = "Test",), odm = IOBuffer("<ODM/>"))
    @test field(last(t.requests), "odm") == "<ODM/>"
    @test_throws ArgumentError create_project(s; data = (project_title = "Test",), odm = "<ODM/>")
end

@testset "folder IDs" begin
    @test create_file_repository_folder(project(always(ok("""[{"folder_id":"12"}]"""))); name = "x") === 12
    @test create_file_repository_folder(project(always(ok("""[{"folder_id":7}]"""))); name = "x") === 7
    @test_throws REDCapError create_file_repository_folder(project(always(ok("[]"))); name = "x")
end

@testset "project info and XML" begin
    info = export_project_info(project(always(ok("""{"project_id":"1","project_title":"T","nested":{"a":"b"}}"""))))
    @test info isa Dict{String, Any}
    @test info["project_title"] == "T" && info["nested"] == Dict("a" => "b")
    @test_throws REDCapError export_project_info(project(always(ok("[]"))))
    xml = """<?xml version="1.0"?><ODM></ODM>"""
    @test export_project_XML(project(always(ok(xml)))) == xml
    io = IOBuffer()
    t = always(ok(xml))
    export_project_XML(project(t), io; returnMetadataOnly = true)
    @test String(take!(io)) == xml
    @test field(only(t.requests), "returnMetadataOnly") == "true"
    @test field(only(t.requests), "format") === nothing
    @test_throws ArgumentError import_project_info(project(); data = [(a = "1",), (a = "2",)])
end
