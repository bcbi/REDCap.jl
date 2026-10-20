using REDCap: table_from_rows, vcat_tables
using JSON

@testset "Tables.jl interface" begin
    t = REDCapTable([:a, :b], [["1", "2"], ["x", "y"]])
    @test Tables.istable(t)
    @test Tables.columnaccess(t)
    @test Tables.columnnames(t) == [:a, :b]
    @test Tables.getcolumn(t, 2) == ["x", "y"]
    @test Tables.getcolumn(t, :a) == ["1", "2"]
    @test Tables.schema(t) == Tables.Schema([:a, :b], [String, String])
    @test Tables.columntable(t) == (a = ["1", "2"], b = ["x", "y"])
    @test Tables.rowtable(t) == [(a = "1", b = "x"), (a = "2", b = "y")]
    @test size(t, 1) == 2 && size(t, 2) == 2
    @test sprint(show, t) == "REDCapTable(2 rows × 2 columns)"
    @test occursin("columns: a, b", sprint(show, MIME"text/plain"(), t))
    @test_throws ArgumentError REDCapTable([:a, :a], [["1"], ["2"]])
    @test_throws ArgumentError REDCapTable([:a, :b], [["1"], ["2", "3"]])
end

@testset "wide tables" begin
    names = [Symbol("field_", i) for i in 1:2000]
    row = "{" * join(("\"$n\":\"v\"" for n in names), ",") * "}"
    t = table_from_rows(JSON.parse("[$row,$row]"))
    @test size(t) == (2, 2000)
    @test Tables.schema(t).names[1:2] == (:field_1, :field_2)  # order of first appearance
end

@testset "column order follows the JSON" begin
    rows = JSON.parse("""[{"z":"1","a":"2"},{"a":"3","z":"4","m":"5"}]""")
    t = table_from_rows(rows)
    @test Tables.columnnames(t) == [:z, :a, :m]
    @test isequal(t[:m], [missing, "5"])
end

@testset "vcat" begin
    a = REDCapTable([:id, :x], [["1"], ["a"]])
    b = REDCapTable([:id, :x], [["2", "3"], ["b", "c"]])
    @test vcat_tables([a, b]) == REDCapTable([:id, :x], [["1", "2", "3"], ["a", "b", "c"]])
    @test vcat_tables([a, REDCapTable(), b]) == vcat_tables([a, b])
    @test vcat_tables(REDCapTable[]) == REDCapTable()
    @test_throws ArgumentError vcat_tables([a, REDCapTable([:id, :y], [["2"], ["b"]])])
end
