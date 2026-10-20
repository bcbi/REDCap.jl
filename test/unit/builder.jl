using REDCap: build_request, encode_body, NoData

@testset "fields come from the spec" begin
    spec = method_spec(:export_records)
    req = build_request(project(), spec, (fields = [:age], rawOrLabel = :label, records = nothing))
    @test req.method === :export_records
    @test req.url == REDCap.URI(URL)
    @test req.file === nothing
    @test req.fields == [
        "token" => TOKEN, "content" => "record", "returnFormat" => "json", "format" => "json",
        "type" => "flat", "fields[0]" => "age", "rawOrLabel" => "label",
    ]
    req = build_request(project(), method_spec(:delete_records), (records = [1, 2],))
    @test field(req, "action") == "delete"
end

@testset "validation" begin
    p = project()
    spec = method_spec(:export_records)
    @test_throws ArgumentError build_request(p, spec, (nonsense = 1,))
    # fixed parameters can't be set by the user
    @test_throws ArgumentError build_request(p, spec, (type = :eav,))
    @test_throws ArgumentError build_request(p, spec, (format = :csv,))
    # IO-only parameters
    @test_throws ArgumentError build_request(p, spec, (csvDelimiter = :tab,))
    @test build_request(p, spec, (csvDelimiter = :tab,); format = :csv, io = true) isa REDCapRequest
    # required parameters
    @test_throws ArgumentError build_request(p, method_spec(:delete_records), NamedTuple())
    @test_throws ArgumentError build_request(p, method_spec(:delete_records), (records = nothing,))
    # data
    @test_throws ArgumentError build_request(p, spec, NamedTuple(); data = [EXAMPLE_ROW])
    @test_throws ArgumentError build_request(p, method_spec(:import_records), NamedTuple())
    # format outside IO methods
    @test_throws ArgumentError build_request(p, spec, NamedTuple(); format = :csv)
    @test_throws ArgumentError build_request(p, spec, NamedTuple(); io = true)
    @test_throws ArgumentError build_request(p, spec, NamedTuple(); format = :yaml, io = true)
    @test_throws ArgumentError build_request(p, method_spec(:generate_next_record_name), NamedTuple(); format = :csv, io = true)
    # client type
    @test_throws ArgumentError build_request(superuser(), spec, NamedTuple())
    @test build_request(superuser(), method_spec(:export_version), NamedTuple()) isa REDCapRequest
end

@testset "IO format replaces the fixed json format" begin
    req = build_request(project(), method_spec(:export_records), NamedTuple(); format = :csv, io = true)
    @test count(p -> first(p) == "format", req.fields) == 1
    @test field(req, "format") == "csv"
    @test field(req, "returnFormat") == "json"
end

@testset "body encoding" begin
    req = REDCapRequest(:x, REDCap.URI(URL), ["token" => "T", "fields[0]" => "a b&c", "data" => "[{\"x\":\"é\"}]"], nothing)
    ctype, body = encode_body(req)
    @test ctype == "application/x-www-form-urlencoded"
    @test String(body) == "token=T&fields%5B0%5D=a%20b%26c&data=%5B%7B%22x%22%3A%22%C3%A9%22%7D%5D"

    upload = REDCap.REDCapUpload("file", "scan \"1\".pdf", UInt8[0x25, 0x50, 0x00, 0xff], "application/pdf")
    req = REDCapRequest(:x, REDCap.URI(URL), ["token" => "T", "record" => "1"], upload)
    ctype, body = encode_body(req; boundary = "BOUNDARY")
    @test ctype == "multipart/form-data; boundary=BOUNDARY"
    expected = Vector{UInt8}(
        codeunits(
            "--BOUNDARY\r\nContent-Disposition: form-data; name=\"token\"\r\n\r\nT\r\n" *
                "--BOUNDARY\r\nContent-Disposition: form-data; name=\"record\"\r\n\r\n1\r\n" *
                "--BOUNDARY\r\nContent-Disposition: form-data; name=\"file\"; filename=\"scan %221%22.pdf\"\r\n" *
                "Content-Type: application/pdf\r\n\r\n",
        ),
    )
    append!(expected, UInt8[0x25, 0x50, 0x00, 0xff])
    append!(expected, codeunits("\r\n--BOUNDARY--\r\n"))
    @test body == expected
end

@testset "requests are shown without the token" begin
    req = build_request(project(; token = MARKED_TOKEN), method_spec(:export_version), NamedTuple())
    @test !occursin(MARKED_TOKEN, sprint(show, req))
    @test occursin("<redacted>", sprint(show, req))
end

@testset "uploads" begin
    t = always(ok(""))
    p = project(t)
    @test import_file(p; record = 1, field = :consent, file = IOBuffer("abc"), filename = "c.txt") === nothing
    req = only(t.requests)
    @test req.file.field == "file"
    @test req.file.filename == "c.txt"
    @test req.file.content == Vector{UInt8}("abc")
    @test field(req, "file") === nothing
    mktempdir() do dir
        path = joinpath(dir, "scan.pdf")
        write(path, "PDF")
        import_file_into_file_repository(p; file = REDCapFile(path), folder_id = 2)
        @test last(t.requests).file.filename == "scan.pdf"
        @test last(t.requests).file.content == Vector{UInt8}("PDF")
        import_file_into_file_repository(p; file = REDCapFile(path), filename = "renamed.pdf")
        @test last(t.requests).file.filename == "renamed.pdf"
    end
    n = length(t.requests)
    @test_throws ArgumentError import_file(p; record = 1, field = :f, file = IOBuffer("abc"))
    @test_throws ArgumentError import_file(p; record = 1, field = :f, file = "/some/file")
    @test_throws ArgumentError import_file(p; record = 1, field = :f, file = IOBuffer("x"), filename = "")
    @test_throws ArgumentError import_file(p; record = 1, field = :f, file = 123, filename = "x")
    @test length(t.requests) == n
    @test_throws ArgumentError build_request(p, method_spec(:export_version), NamedTuple(); file = IOBuffer("x"))
end

@testset "IO methods without format" begin
    @test_throws ArgumentError build_request(project(), method_spec(:export_project_XML), NamedTuple(); format = :csv, io = true)
    req = build_request(project(), method_spec(:export_file), (record = 1, field = :f); io = true)
    @test field(req, "format") === nothing
end
