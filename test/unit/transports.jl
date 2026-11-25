@testset "MockTransport" begin
    t = mock(ok("1"), ok("2"))
    p = project(t)
    @test delete_records(p; records = 1) == 1
    @test delete_records(p; records = 2) == 2
    @test length(t.requests) == 2
    @test field(t.requests[2], "records[0]") == "2"
    @test_throws ErrorException delete_records(p; records = 3)

    t = MockTransport(req -> ok(field(req, "content") == "version" ? "15.1.0" : "[]"))
    @test export_version(project(t)) == v"15.1.0"
    @test sprint(show, t) == "MockTransport(1 requests)"
end

@testset "HTTPTransport" begin
    t = HTTPTransport(; connect_timeout = 5)
    @test t.options == (connect_timeout = 5,)
    @test sprint(show, t) == "HTTPTransport()"
end
