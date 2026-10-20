# Tiers 1-3 of the test suite. No ENV variables and no network access are needed.
# The live tests (Tier 4) are in test/live/ and are never run from here.

include("helpers.jl")

@testset verbose = true "REDCap.jl" begin
    @testset "clients" include("unit/clients.jl")
    @testset "parameters" include("unit/params.jl")
    @testset "data" include("unit/data.jl")
    @testset "request builder" include("unit/builder.jl")
    @testset "responses" include("unit/responses.jl")
    @testset "table" include("unit/table.jl")
    @testset "transports" include("unit/transports.jl")
    @testset "batching" include("unit/batching.jl")
    @testset "spec consistency" include("consistency.jl")
    @testset "fixtures" include("fixtures.jl")
    @testset "Aqua" include("aqua.jl")
end
