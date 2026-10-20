# Tier 2: spec consistency and guarantee tests. These loop over METHOD_SPECS, so every new
# method is covered automatically.

"Every method of an API function, split into the main method and the IO method."
function api_methods(f)
    ms = collect(methods(f))
    io = filter(m -> length(m.sig.parameters) >= 3 && m.sig.parameters[3] <: IO, ms)
    main = filter(m -> !(m in io), ms)
    return main, io
end

exported_functions() = Set(
    n for n in names(REDCap) if n !== :REDCap && !(getfield(REDCap, n) isa Type) && getfield(REDCap, n) isa Function
)

const CLIENT_TYPES = (REDCapProject, REDCapSuperUser)

@testset "exported API functions equal spec names" begin
    @test exported_functions() == Set(s.name for s in METHOD_SPECS)
    @test allunique(s.name for s in METHOD_SPECS)
end

@testset "$(spec.name)" for spec in METHOD_SPECS
    f = api_function(spec)
    main, io = api_methods(f)

    @testset "methods and keyword arguments" begin
        @test length(main) == 1
        @test length(io) == (spec.raw_io ? 1 : 0)
        @test kwarg_names(only(main)) == REDCap.user_kwargs(spec)
        if spec.raw_io
            @test kwarg_names(only(io)) == REDCap.user_kwargs(spec; io = true)
        end
        for m in vcat(main, io)
            @test !(:url in kwarg_names(m)) && !(:token in kwarg_names(m))
            @test (:batchsize in kwarg_names(m)) == spec.batchable
        end
    end

    @testset "dispatches only on the declared client type" begin
        for m in vcat(main, io)
            @test m.sig.parameters[2] === spec.client
        end
        for C in CLIENT_TYPES
            @test hasmethod(f, Tuple{C}) == (C <: spec.client)
        end
        if spec.client !== AbstractREDCapClient
            other = spec.client === REDCapProject ? superuser() : project()
            @test_throws MethodError f(other; minimal_kwargs(spec)...)
        end
    end

    @testset "sends exactly the spec's content, action and fixed parameters" begin
        t = always(ok(fake_body(spec.returns)))
        client = client_for(spec, t)
        kwargs = minimal_kwargs(spec)
        spec.data == :required ? f(client; kwargs..., data = EXAMPLE_ROW) : f(client; kwargs...)
        req = only(t.requests)
        @test req.method === spec.name
        @test field(req, "token") == client.token
        @test field(req, "content") == String(spec.content)
        @test field(req, "action") == (spec.action === nothing ? nothing : String(spec.action))
        for (k, v) in spec.fixed
            for (name, value) in REDCap.encode_param(REDCap.param_kind(spec.overrides, k), k, v)
                @test field(req, name) == value
            end
        end
        @test count(p -> first(p) == "format", req.fields) <= 1
        @test allunique(first.(req.fields))
        # only the spec's parameters, the minimal ones we passed, and data are sent
        allowed = Set(["token", "content", "action", "data", "format"])
        for (k, v) in spec.fixed, (name, _) in REDCap.encode_param(REDCap.param_kind(spec.overrides, k), k, v)
            push!(allowed, name)
        end
        for k in spec.required, (name, _) in REDCap.encode_param(REDCap.param_kind(spec.overrides, k), k, kwargs[k])
            push!(allowed, name)
        end
        @test all(first(p) in allowed for p in req.fields)
        @test (req.file !== nothing) == spec.upload

        if spec.raw_io
            t = always(ok("raw"))
            client = client_for(spec, t)
            buf = IOBuffer()
            @test f(client, buf; io_kwargs(spec)...) === nothing
            @test String(take!(buf)) == "raw"
            req = only(t.requests)
            @test field(req, "content") == String(spec.content)
            @test field(req, "action") == (spec.action === nothing ? nothing : String(spec.action))
            if isempty(spec.io_formats)
                @test_throws MethodError f(client, IOBuffer(); io_kwargs(spec)..., format = :csv)
            else
                @test field(req, "format") == String(first(spec.io_formats))
            end
            for (k, v) in spec.fixed
                k === :format && !isempty(spec.io_formats) && continue
                for (name, value) in REDCap.encode_param(REDCap.param_kind(spec.overrides, k), k, v)
                    @test field(req, name) == value
                end
            end
        end
    end

    @testset "data guarantees" begin
        t = always(ok(fake_body(spec.returns)))
        client = client_for(spec, t)
        kwargs = minimal_kwargs(spec)
        if spec.data == :required
            @test_throws UndefKeywordError f(client; kwargs...)
            @test_throws ArgumentError f(client; kwargs..., data = "a,b\n1,2")
        else
            @test_throws MethodError f(client; kwargs..., data = EXAMPLE_ROW)
            spec.raw_io && @test_throws MethodError f(client, IOBuffer(); io_kwargs(spec)..., data = EXAMPLE_ROW)
        end
        @test isempty(t.requests)
        if spec.action === :delete || startswith(String(spec.name), "delete_")
            @test spec.data == :none
            f(client; kwargs...)
            @test field(only(t.requests), "data") === nothing
        end
    end

    @testset "required parameters have no defaults" begin
        for k in spec.required
            partial = NamedTuple(kk => v for (kk, v) in pairs(minimal_kwargs(spec)) if kk !== k)
            spec.data == :required && (partial = merge(partial, (data = EXAMPLE_ROW,)))
            t = always(ok(fake_body(spec.returns)))
            @test_throws UndefKeywordError f(client_for(spec, t); partial...)
            @test isempty(t.requests)
        end
    end

    @testset "docstring" begin
        docs = Base.Docs.meta(REDCap)[Base.Docs.Binding(REDCap, spec.name)].docs
        @test !isempty(docs)
        texts = [join(string.(d.text)) for d in values(docs)]
        if spec.destructive
            @test all(startswith(strip(s), REDCap.DESTRUCTIVE_WARNING) for s in texts)
        else
            @test !any(occursin(REDCap.DESTRUCTIVE_WARNING, s) for s in texts)
        end
        @test any(occursin("->", s) for s in texts)  # states the return type
    end
end

@testset "spec sanity" begin
    for spec in METHOD_SPECS
        # anything that can delete data is marked destructive
        if startswith(String(spec.name), "delete_") || any(p -> last(p) === :overwrite || p == (:override => true), spec.fixed)
            @test spec.destructive
        end
        # backgroundProcess is never exposed
        @test !(:backgroundProcess in REDCap.user_kwargs(spec; io = spec.raw_io))
        # options that change what a call does or returns are always fixed
        @test !(:override in REDCap.user_kwargs(spec)) && !(:allRecords in REDCap.user_kwargs(spec))
        @test !(:overwriteBehavior in REDCap.user_kwargs(spec))
        # returnContent and type are always fixed, never user parameters
        @test !(:returnContent in REDCap.user_kwargs(spec)) && !(:type in REDCap.user_kwargs(spec))
    end
    batchable = Set(s.name for s in METHOD_SPECS if s.batchable)
    @test batchable == Set([:export_records, :import_records, :import_records_ids, :overwrite_records, :delete_records])
    @test !method_spec(:import_metadata).batchable
end
