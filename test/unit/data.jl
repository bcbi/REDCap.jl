using REDCap: normalize_data, rows_to_json, TableData, RawData
using JSON

const FORMATS = [:csv, :json, :xml]

sent_json(data) = rows_to_json(normalize_data(data, nothing, FORMATS).rows)

"A minimal Tables.jl row table that is neither a NamedTuple nor a vector of rows."
struct TestTable
    names::Vector{Symbol}
    cols::Vector{Vector{Any}}
end
Tables.istable(::Type{TestTable}) = true
Tables.columnaccess(::Type{TestTable}) = true
Tables.columns(t::TestTable) = t
Tables.columnnames(t::TestTable) = t.names
Tables.getcolumn(t::TestTable, i::Int) = t.cols[i]
Tables.getcolumn(t::TestTable, n::Symbol) = t.cols[findfirst(==(n), t.names)]

const EXPECTED = """[{"record_id":"1","age":"63"},{"record_id":"2","age":""}]"""

@testset "accepted table inputs" begin
    # vector of NamedTuples
    @test sent_json([(record_id = "1", age = "63"), (record_id = "2", age = "")]) == EXPECTED
    # vector of Dicts (keys may be Symbols or Strings)
    rows = [Dict(:record_id => "1"), Dict("record_id" => "2")]
    @test sent_json(rows) == """[{"record_id":"1"},{"record_id":"2"}]"""
    # NamedTuple of vectors (column table)
    @test sent_json((record_id = ["1", "2"], age = ["63", ""])) == EXPECTED
    # any Tables.jl table
    @test sent_json(TestTable([:record_id, :age], [Any["1", "2"], Any["63", missing]])) == EXPECTED
    # a REDCapTable round-trips
    t = REDCap.REDCapTable([:record_id, :age], [["1", "2"], ["63", ""]])
    @test sent_json(t) == EXPECTED
    # a single row
    @test sent_json((record_id = "1", age = "63")) == """[{"record_id":"1","age":"63"}]"""
    @test sent_json(Dict(:record_id => "1")) == """[{"record_id":"1"}]"""
end

@testset "value serialization" begin
    row = (a = 1, b = 1.5, c = true, d = false, e = missing, f = nothing, g = :sym, h = Date(2024, 1, 2), i = "x\"y")
    @test JSON.parse(sent_json(row))[1] == Dict(
        "a" => "1", "b" => "1.5", "c" => "1", "d" => "0", "e" => "", "f" => "", "g" => "sym",
        "h" => "2024-01-02", "i" => "x\"y",
    )
    nested = (username = "u", forms = Dict("demo" => 1), list = ["a", 2])
    @test JSON.parse(sent_json(nested))[1] == Dict("username" => "u", "forms" => Dict("demo" => "1"), "list" => ["a", "2"])
    @test_throws ArgumentError sent_json((a = DateTime(2024),))
    @test_throws ArgumentError sent_json((a = NaN,))
    @test_throws ArgumentError sent_json((a = 1 + 2im,))
end

@testset "rejected inputs" begin
    err = try
        normalize_data("record_id\n1", nothing, FORMATS)
    catch e
        e
    end
    @test err isa ArgumentError
    @test occursin("String is not accepted", err.msg)
    # even when the string is the name of an existing file
    mktempdir() do dir
        path = joinpath(dir, "data.csv")
        write(path, "record_id\n1\n")
        @test_throws ArgumentError normalize_data(path, :csv, FORMATS)
        @test_throws ArgumentError normalize_data(path, nothing, FORMATS)
    end
    @test_throws ArgumentError normalize_data(NamedTuple[], nothing, FORMATS)
    @test_throws ArgumentError normalize_data([1, 2], nothing, FORMATS)
    @test_throws ArgumentError normalize_data(63, nothing, FORMATS)
    # format is not allowed with table data
    @test_throws ArgumentError normalize_data(EXAMPLE_ROW, :json, FORMATS)
end

@testset "raw inputs" begin
    raw = normalize_data(IOBuffer("record_id\n1\n"), :csv, FORMATS)
    @test raw isa RawData
    @test raw.format == "csv" && raw.payload == "record_id\n1\n"
    mktempdir() do dir
        path = joinpath(dir, "data.json")
        write(path, """[{"record_id":"1"}]""")
        raw = normalize_data(REDCapFile(path), "json", FORMATS)
        @test raw.format == "json" && raw.payload == """[{"record_id":"1"}]"""
    end
    # format is required and must be allowed
    @test_throws ArgumentError normalize_data(IOBuffer("x"), nothing, FORMATS)
    @test_throws ArgumentError normalize_data(IOBuffer("x"), :odm, FORMATS)
    @test_throws ArgumentError normalize_data(IOBuffer("x"), :yaml, FORMATS)
    @test_throws ArgumentError normalize_data(IOBuffer("x"), 1, FORMATS)
    @test normalize_data(IOBuffer("x"), :odm, [:odm]).format == "odm"
end

@testset "import requests" begin
    t = always(ok("1"))
    p = project(t)
    @test import_records(p; data = [EXAMPLE_ROW]) == 1
    req = last(t.requests)
    @test field(req, "format") == "json"
    @test field(req, "data") == """[{"record_id":"1","age":"63"}]"""
    @test import_records(p; data = IOBuffer("record_id,age\n1,63\n"), format = :csv) == 1
    req = last(t.requests)
    @test field(req, "format") == "csv"
    @test field(req, "data") == "record_id,age\n1,63\n"
    @test count(p -> first(p) == "format", req.fields) == 1
    n = length(t.requests)
    @test_throws ArgumentError import_records(p; data = "record_id,age\n1,63\n", format = :csv)
    @test_throws ArgumentError import_metadata(p; data = IOBuffer("x"), format = :odm)
    @test length(t.requests) == n
end
