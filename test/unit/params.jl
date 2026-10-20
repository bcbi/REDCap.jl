using REDCap: encode_param, StringParam, IntParam, BoolParam, DateTimeParam, ArrayParam, EnumParam

@testset "string" begin
    @test encode_param(StringParam(), :record, "a b") == ["record" => "a b"]
    @test encode_param(StringParam(), :record, :abc) == ["record" => "abc"]
    @test encode_param(StringParam(), :record, 12) == ["record" => "12"]
    @test_throws ArgumentError encode_param(StringParam(), :record, true)
    @test_throws ArgumentError encode_param(StringParam(), :record, 1.5)
    @test_throws ArgumentError encode_param(StringParam(), :record, ["a"])
end

@testset "int" begin
    @test encode_param(IntParam(), :arm, 2) == ["arm" => "2"]
    @test encode_param(IntParam(), :arm, UInt8(2)) == ["arm" => "2"]
    @test_throws ArgumentError encode_param(IntParam(), :arm, "2")
    @test_throws ArgumentError encode_param(IntParam(), :arm, true)
    @test_throws ArgumentError encode_param(IntParam(), :arm, 2.0)
end

@testset "bool" begin
    @test encode_param(REDCap.TRUE_FALSE, :exportSurveyFields, true) == ["exportSurveyFields" => "true"]
    @test encode_param(REDCap.TRUE_FALSE, :exportSurveyFields, false) == ["exportSurveyFields" => "false"]
    @test encode_param(REDCap.ONE_ZERO, :delete_logging, true) == ["delete_logging" => "1"]
    @test encode_param(REDCap.ONE_ZERO, :delete_logging, false) == ["delete_logging" => "0"]
    @test_throws ArgumentError encode_param(REDCap.TRUE_FALSE, :exportSurveyFields, 1)
    @test_throws ArgumentError encode_param(REDCap.TRUE_FALSE, :exportSurveyFields, "true")
end

@testset "datetime" begin
    @test encode_param(DateTimeParam(), :dateRangeBegin, DateTime(2024, 2, 3, 4, 5, 6)) ==
        ["dateRangeBegin" => "2024-02-03 04:05:06"]
    @test encode_param(DateTimeParam(), :dateRangeBegin, Date(2024, 2, 3)) ==
        ["dateRangeBegin" => "2024-02-03 00:00:00"]
    @test_throws ArgumentError encode_param(DateTimeParam(), :dateRangeBegin, "2024-02-03")
end

@testset "array" begin
    @test encode_param(ArrayParam(), :fields, [:a, "b"]) == ["fields[0]" => "a", "fields[1]" => "b"]
    @test encode_param(ArrayParam(), :records, 1:3) == ["records[0]" => "1", "records[1]" => "2", "records[2]" => "3"]
    @test encode_param(ArrayParam(), :records, (1, "x")) == ["records[0]" => "1", "records[1]" => "x"]
    # a scalar is encoded as name[0]
    @test encode_param(ArrayParam(), :fields, :age) == ["fields[0]" => "age"]
    @test encode_param(ArrayParam(), :records, 7) == ["records[0]" => "7"]
    @test_throws ArgumentError encode_param(ArrayParam(), :fields, String[])
    @test_throws ArgumentError encode_param(ArrayParam(), :fields, [1.5])
    @test_throws ArgumentError encode_param(ArrayParam(), :fields, [true])
end

@testset "enum" begin
    k = EnumParam("raw", "label")
    @test encode_param(k, :rawOrLabel, :label) == ["rawOrLabel" => "label"]
    @test encode_param(k, :rawOrLabel, "raw") == ["rawOrLabel" => "raw"]
    @test_throws ArgumentError encode_param(k, :rawOrLabel, :Label)
    @test_throws ArgumentError encode_param(k, :rawOrLabel, 1)
    d = REDCap.PARAMETERS[:csvDelimiter]
    @test encode_param(d, :csvDelimiter, ',') == ["csvDelimiter" => ","]
    @test encode_param(d, :csvDelimiter, :tab) == ["csvDelimiter" => "tab"]
end

@testset "registry" begin
    @test_throws ArgumentError REDCap.param_kind(Dict{Symbol, REDCap.ParamKind}(), :nonsense)
    overrides = Dict{Symbol, REDCap.ParamKind}(:arm => StringParam())
    @test REDCap.param_kind(overrides, :arm) isa StringParam
    @test REDCap.param_kind(Dict{Symbol, REDCap.ParamKind}(), :arm) isa IntParam
end

@testset "invalid values are rejected before any request" begin
    t = always(ok("[]"))
    p = project(t)
    @test_throws ArgumentError export_records(p; rawOrLabel = :nope)
    @test_throws ArgumentError export_records(p; exportSurveyFields = "yes")
    @test_throws ArgumentError export_records(p; dateRangeBegin = "2024-01-01")
    @test_throws ArgumentError export_records(p; fields = Symbol[])
    @test_throws ArgumentError delete_records(p; records = [1.5])
    @test_throws ArgumentError rename_record(p; record = "1", new_record_name = "2", arm = "1")
    @test isempty(t.requests)
end
