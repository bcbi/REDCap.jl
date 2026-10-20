using REDCap: chunk, group_rows, plan_import_batches, run_batches, Row, REDCapBatchError

include(joinpath(@__DIR__, "..", "fake_redcap.jl"))

"A project client backed by a FakeREDCap, plus the transport recording its requests."
function fake_client(fake)
    t = MockTransport(fake)
    return project(t), t
end

record_requests(t) = filter(r -> field(r, "content") == "record", t.requests)

@testset "planning" begin
    @test chunk(collect(1:5), 2) == [[1, 2], [3, 4], [5]]
    @test chunk(Int[], 2) == Vector{Int}[]
    rows = [Row(["id" => "2", "e" => "a"]), Row(["id" => 1, "e" => "a"]), Row(["id" => "2", "e" => "b"])]
    groups = group_rows(rows, "id")
    @test first.(groups) == ["2", "1"]
    @test length(last(groups[1])) == 2
    @test_throws ArgumentError group_rows([Row(["x" => "1"])], "id")
    @test_throws ArgumentError group_rows([Row(["id" => ""])], "id")
    @test_throws ArgumentError group_rows([Row(["id" => missing])], "id")
    batches = plan_import_batches(rows, "id", 1)
    @test first.(batches) == [["2"], ["1"]]
    @test length(last(batches[1])) == 2
    for bad in (0, -1, 1.5, true, "2")
        @test_throws ArgumentError REDCap.check_batchsize(bad)
    end
end

@testset "run_batches" begin
    err = REDCapError(500, "an error message", :x)
    calls = Int[]
    e = try
        run_batches([["1", "2"], ["3"], ["4"]]) do k
            push!(calls, k)
            k == 2 && throw(err)
            k
        end
    catch e
        e
    end
    @test e isa REDCapBatchError
    @test calls == [1, 2]  # stops at the first failure
    @test e.completed_batches == 1
    @test e.processed_records == ["1", "2"]
    @test e.failed_records == ["3"]
    @test e.error === err
    @test occursin("not", sprint(showerror, e)) || occursin("remain applied", sprint(showerror, e))
    # other exceptions propagate unchanged
    @test_throws ErrorException run_batches(k -> error("x"), [["1"]])
end

@testset "export: record ID lookup" begin
    fake = fake_project_data(5)
    p, t = fake_client(fake)
    result = export_records(p; batchsize = 2, filterLogic = "[group] = 'a'", rawOrLabel = :label, fields = [:age])
    # metadata, ID lookup, then 2 batches (records 1, 3, 5)
    @test [field(r, "content") for r in t.requests] == ["metadata", "record", "record", "record"]
    lookup = t.requests[2]
    @test field(lookup, "fields[0]") == "record_id"
    @test field(lookup, "fields[1]") === nothing
    @test field(lookup, "filterLogic") == "[group] = 'a'"
    @test field(lookup, "rawOrLabel") === nothing
    batches = t.requests[3:4]
    @test indexed(batches[1], "records") == ["1", "3"]
    @test indexed(batches[2], "records") == ["5"]
    for b in batches  # user parameters go to every batch
        @test field(b, "filterLogic") == "[group] = 'a'"
        @test field(b, "rawOrLabel") == "label"
        @test field(b, "fields[0]") == "age"
        @test field(b, "type") == "flat"
    end
    @test result[:record_id] == ["1", "1", "3", "3", "5", "5"]
end

"The rows of a table, sorted, to compare tables whose row order may differ."
sorted_rows(t) = sort(Tables.rowtable(t); by = r -> Tuple(values(r)))

@testset "export: batched equals unbatched" begin
    for n in (1, 2, 3, 7, 100)
        fake = fake_project_data(7)
        p, t = fake_client(fake)
        @test export_records(p; batchsize = n) == export_records(p)
        @test export_records(p; batchsize = n, events = "followup_arm_1") == export_records(p; events = "followup_arm_1")
        # Batches follow the order of `records`; within a batch, REDCap's order.
        @test sorted_rows(export_records(p; batchsize = n, records = [7, 2, 2, 5])) ==
            sorted_rows(export_records(p; records = [7, 2, 5]))
    end
    # every ID in exactly one batch
    fake = fake_project_data(7)
    p, t = fake_client(fake)
    export_records(p; batchsize = 3)
    sent = reduce(vcat, [indexed(r, "records") for r in record_requests(t)[2:end]])
    @test sort(sent) == string.(1:7) && allunique(sent)
    # no records: no batch requests, empty table
    p, t = fake_client(fake_project_data(0))
    @test isempty(export_records(p; batchsize = 2))
    @test length(record_requests(t)) == 1
end

@testset "export: column mismatch" begin
    t = mock(ok("""[{"record_id":"1","a":"x"}]"""), ok("""[{"record_id":"2","b":"y"}]"""))
    @test_throws ArgumentError export_records(project(t); records = [1, 2], batchsize = 1)
end

@testset "export: raw IO merging" begin
    for n in (1, 2, 4)
        fake = fake_project_data(5)
        p, _ = fake_client(fake)
        whole, batched = IOBuffer(), IOBuffer()
        export_records(p, whole; format = :csv)
        export_records(p, batched; format = :csv, batchsize = n)
        @test String(take!(batched)) == String(take!(whole))

        export_records(p, whole; format = :json)
        export_records(p, batched; format = :json, batchsize = n)
        merged = String(take!(batched))
        @test JSON.parse(merged) == JSON.parse(String(take!(whole)))
        @test startswith(merged, "[{") && endswith(merged, "}]")
    end
    p, _ = fake_client(fake_project_data(0))
    buf = IOBuffer()
    export_records(p, buf; format = :json, batchsize = 2)
    @test String(take!(buf)) == "[]"
    for fmt in (:xml, :odm)
        t = always(ok("[]"))
        @test_throws ArgumentError export_records(project(t), IOBuffer(); format = fmt, batchsize = 2)
        @test isempty(t.requests)
    end
end

@testset "import: records stay whole" begin
    fake = fake_project_data(0)
    p, t = fake_client(fake)
    data = [
        (record_id = "1", redcap_event_name = "baseline_arm_1", age = "30"),
        (record_id = "2", redcap_event_name = "baseline_arm_1", age = "31"),
        (record_id = "1", redcap_event_name = "followup_arm_1", age = "32"),
        (record_id = "3", redcap_event_name = "baseline_arm_1", age = "33"),
        (record_id = "2", redcap_event_name = "followup_arm_1", age = "34"),
    ]
    @test import_records(p; data, batchsize = 2, dateFormat = :DMY) == 3
    @test field(t.requests[1], "content") == "metadata"  # record ID field lookup
    imports = record_requests(t)
    @test length(imports) == 2
    sent = [JSON.parse(field(r, "data")) for r in imports]
    @test [unique(r["record_id"] for r in b) for b in sent] == [["1", "2"], ["3"]]
    @test length(sent[1]) == 4  # both events of records 1 and 2
    for r in imports
        @test field(r, "dateFormat") == "DMY"
        @test field(r, "overwriteBehavior") == "normal"
    end
    @test length(fake.rows) == 5

    # explicit recordIdField: no metadata request
    p, t = fake_client(fake_project_data(0))
    @test import_records(p; data, batchsize = 1, recordIdField = :record_id) == 3
    @test all(r -> field(r, "content") == "record", t.requests)
    @test length(t.requests) == 3
    @test_throws ArgumentError import_records(p; data, batchsize = 1, recordIdField = :nope)
end

@testset "import: batched equals unbatched" begin
    data = Tables.rowtable(export_records(project(MockTransport(fake_project_data(9)))))
    for n in (1, 4, 20)
        a, b = fake_project_data(0), fake_project_data(0)
        pa, _ = fake_client(a)
        pb, _ = fake_client(b)
        @test import_records(pa; data, batchsize = n) == import_records(pb; data)
        @test a.rows == b.rows
        a, b = fake_project_data(0), fake_project_data(0)
        pa, _ = fake_client(a)
        pb, _ = fake_client(b)
        @test import_records_ids(pa; data, batchsize = n) == import_records_ids(pb; data)
        @test overwrite_records(pa; data, batchsize = n) == overwrite_records(pb; data)
    end
    # forceAutoNumber: temporary IDs are only used for grouping
    p, t = fake_client(fake_project_data(0))
    rows = [(record_id = "tmp$i", age = "1") for i in 1:3]
    @test import_records(p; data = rows, forceAutoNumber = true, batchsize = 2, recordIdField = "record_id") == 3
    @test all(r -> field(r, "forceAutoNumber") == "true", t.requests)
end

@testset "import: rejected before any request" begin
    t = always(ok("1"))
    p = project(t)
    @test_throws ArgumentError import_records(p; data = IOBuffer("record_id\n1\n"), format = :csv, batchsize = 2)
    mktempdir() do dir
        path = joinpath(dir, "d.csv")
        write(path, "record_id\n1\n")
        @test_throws ArgumentError import_records(p; data = REDCapFile(path), format = :csv, batchsize = 2)
    end
    @test_throws ArgumentError import_records(p; data = EXAMPLE_ROW, batchsize = 0)
    @test_throws ArgumentError import_records(p; data = EXAMPLE_ROW, recordIdField = "record_id")
    @test_throws ArgumentError import_records(p; data = EXAMPLE_ROW, batchsize = 2, dateFormat = :bad)
    @test_throws ArgumentError export_records(p; batchsize = 2, rawOrLabel = :bad)
    @test_throws ArgumentError delete_records(p; records = [1.5], batchsize = 2)
    @test isempty(t.requests)
end

@testset "delete" begin
    for n in (1, 2, 10)
        a, b = fake_project_data(6), fake_project_data(6)
        pa, ta = fake_client(a)
        pb, _ = fake_client(b)
        @test delete_records(pa; records = 1:5, batchsize = n, arm = 1) == delete_records(pb; records = 1:5, arm = 1) == 5
        @test a.rows == b.rows
        @test length(ta.requests) == cld(5, n)
        @test all(r -> field(r, "arm") == "1", ta.requests)
        @test all(r -> field(r, "data") === nothing, ta.requests)
    end
end

@testset "failure in batch k" begin
    fake = fake_project_data(0)
    fake.fail_at = 3
    p, t = fake_client(fake)
    data = [(record_id = string(i), age = "1") for i in 1:7]
    e = try
        import_records(p; data, batchsize = 2, recordIdField = :record_id)
    catch e
        e
    end
    @test e isa REDCapBatchError
    @test e.completed_batches == 2
    @test e.processed_records == ["1", "2", "3", "4"]
    @test e.failed_records == ["5", "6"]
    @test e.error.status == 500 && e.error.message == "simulated failure"
    @test length(t.requests) == 3  # nothing after the failure
    @test sort(unique(r["record_id"] for r in fake.rows)) == ["1", "2", "3", "4"]  # not atomic

    fake = fake_project_data(5)
    fake.fail_at = 2  # the first record batch (after the ID lookup)
    p, _ = fake_client(fake)
    e = try
        export_records(p; batchsize = 2)
    catch e
        e
    end
    @test e isa REDCapBatchError && e.completed_batches == 0 && e.failed_records == ["1", "2"]

    fake = fake_project_data(5)
    fake.fail_at = 2
    p, _ = fake_client(fake)
    e = try
        delete_records(p; records = 1:5, batchsize = 2)
    catch e
        e
    end
    @test e isa REDCapBatchError && e.processed_records == ["1", "2"] && e.failed_records == ["3", "4"]
end
