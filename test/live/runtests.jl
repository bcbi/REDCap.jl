# Tier 4: live tests against a real REDCap sandbox project. Manual and local only; never
# run from test/runtests.jl or CI. See test/live/README.md before running:
#
#     julia test/live/runtests.jl
#
# This tests the REDCap.jl checkout that contains this file (its working tree, including
# uncommitted changes), in a temporary environment so the checkout isn't modified.

const REQUIRED = ("REDCAP_TEST_URL", "REDCAP_TEST_TOKEN")
missing_vars = filter(v -> isempty(get(ENV, v, "")), REQUIRED)
if !isempty(missing_vars)
    println(stderr, "Refusing to run the live tests: set ", join(missing_vars, " and "), ".")
    println(stderr, "These must point to a dedicated sandbox project (see test/live/README.md).")
    exit(1)
end

using Pkg
Pkg.activate(; temp = true, io = devnull)
Pkg.develop(PackageSpec(path = joinpath(@__DIR__, "..", "..")); io = devnull)
# Dates and Test are standard libraries, so only Tables needs adding.
Pkg.add("Tables"; io = devnull)

using REDCap
using Dates
using Tables
using Test

enabled(var) = get(ENV, var, "") in ("1", "true", "yes")

const RECORD_DIR = joinpath(@__DIR__, "..", "fixtures", "recorded", Dates.format(now(), "yyyymmdd-HHMMSS"))
transport() = enabled("REDCAP_TEST_RECORD") ? RecordingTransport(HTTPTransport(), RECORD_DIR) : HTTPTransport()

const P = REDCapProject(;
    url = ENV["REDCAP_TEST_URL"], token = ENV["REDCAP_TEST_TOKEN"], transport = transport(),
    allow_insecure = enabled("REDCAP_TEST_ALLOW_INSECURE"),
)

# The sandbox described in README.md
const ID = "record_id"
const ARM1 = ("baseline_arm_1", "followup_arm_1")
const ARM2 = "baseline_arm_2"

sorted_rows(t) = sort(Tables.rowtable(t); by = r -> Tuple(string.(values(r))))

# With no records, REDCap returns `[]`, which gives a table with no columns.
function all_ids()
    t = export_records(P; fields = ID)
    return isempty(t) ? String[] : unique(t[Symbol(ID)])
end

function reset_records!()
    ids = all_ids()
    isempty(ids) || delete_records(P; records = ids)
    @assert isempty(all_ids()) "could not delete the sandbox's records"
    return nothing
end

"Rows for `n` records over both arms, with repeating visits for arm 1 records."
function sample_rows(n; offset = 0)
    rows = Dict{String, String}[]
    for i in (1:n) .+ offset
        id = string(i)
        if isodd(i)
            push!(rows, Dict(ID => id, "redcap_event_name" => ARM1[1], "age" => string(20 + i), "sex" => "1"))
            for instance in 1:2
                push!(
                    rows, Dict(
                        ID => id, "redcap_event_name" => ARM1[2], "redcap_repeat_instrument" => "visits",
                        "redcap_repeat_instance" => string(instance), "visit_date" => "2026-01-0$instance",
                    ),
                )
            end
        else
            push!(rows, Dict(ID => id, "redcap_event_name" => ARM2, "age" => string(20 + i), "sex" => "2"))
        end
    end
    return rows
end

println("REDCap.jl live tests against ", P)

# Safety check before anything destructive: never touch a production project.
# REDCap sends `in_production` as a number, not a string.
let info = export_project_info(P), status = get(info, "in_production", nothing)
    if string(status) != "0"
        println(
            stderr, "Refusing to run: project \"", get(info, "project_title", "?"),
            "\" is not in Development status (in_production = ", repr(status), ").",
        )
        exit(1)
    end
end
enabled("REDCAP_TEST_RECORD") && println("Recording fixtures to ", RECORD_DIR)

@testset verbose = true "REDCap.jl live" begin
    @testset "server and project" begin
        @test export_version(P) isa VersionNumber
        info = export_project_info(P)
        @test info isa Dict{String, Any}
        @test string(info["is_longitudinal"]) == "1"
        metadata = export_metadata(P)
        @test metadata[:field_name][1] == ID
        for f in ("age", "sex", "consent_file", "visit_date")
            @test f in metadata[:field_name]
        end
        io = IOBuffer()
        export_metadata(P, io; format = :csv)
        @test startswith(String(take!(io)), "field_name")
    end

    reset_records!()

    @testset "structure exports" begin
        @test string.(export_arms(P)[:arm_num]) == ["1", "2"]
        @test [ARM1..., ARM2] ⊆ export_events(P)[:unique_event_name]
        @test "visits" in export_instruments(P)[:instrument_name]
        @test "visits" in export_instrument_event_mappings(P)[:form]
        @test "visits" in export_repeating_instruments_and_events(P)[:form_name]
        @test export_field_names(P; field = "sex")[:export_field_name] == ["sex"]
        @test export_DAGs(P) isa REDCapTable
        @test export_user_DAG_assignment(P) isa REDCapTable
        @test export_logging(P; beginTime = now() - Hour(1)) isa REDCapTable
    end

    @testset "round-trip structure imports" begin
        # Re-importing the exported structure must leave it unchanged.
        arms = export_arms(P)
        @test import_arms(P; data = arms) == size(arms, 1)
        @test export_arms(P) == arms
        mappings = export_instrument_event_mappings(P)
        @test import_instrument_event_mappings(P; data = mappings) == size(mappings, 1)
        @test sorted_rows(export_instrument_event_mappings(P)) == sorted_rows(mappings)
        repeating = export_repeating_instruments_and_events(P)
        @test import_repeating_instruments_and_events(P; data = repeating) == size(repeating, 1)
        @test sorted_rows(export_repeating_instruments_and_events(P)) == sorted_rows(repeating)
        metadata = export_metadata(P)
        @test import_metadata(P; data = metadata) == size(metadata, 1)
        @test export_metadata(P) == metadata
        notes = "REDCap.jl live test $(now())"
        @test import_project_info(P; data = (project_notes = notes,)) >= 1
        @test export_project_info(P)["project_notes"] == notes
    end

    @testset "records" begin
        rows = sample_rows(6)
        @test import_records(P; data = rows) == 6
        exported = export_records(P)
        @test sort(unique(exported[Symbol(ID)])) == string.(1:6)
        @test size(exported, 1) == length(rows)
        @test export_records(P; records = 2, fields = [ID, "age"])[:age] == ["22"]
        @test export_records(P; filterLogic = "[age] > 24", fields = ID)[Symbol(ID)] |> unique |> sort == ["5", "6"]
        @test export_records_eav(P; records = 2) isa REDCapTable
        @test import_records_ids(P; data = [Dict(ID => "7", "redcap_event_name" => ARM2, "age" => "30")]) == ["7"]
        # blanks are ignored by import_records, and erase with overwrite_records
        import_records(P; data = [Dict(ID => "7", "redcap_event_name" => ARM2, "age" => "")])
        @test export_records(P; records = 7, fields = [ID, "age"])[:age] == ["30"]
        overwrite_records(P; data = [Dict(ID => "7", "redcap_event_name" => ARM2, "age" => "")])
        @test export_records(P; records = 7, fields = [ID, "age"])[:age] == [""]
        @test rename_record(P; record = 7, new_record_name = "renamed") === nothing
        @test "renamed" in all_ids()
        @test generate_next_record_name(P) isa String
        @test delete_records(P; records = ["renamed"]) == 1
        for fmt in (:csv, :json, :xml, :odm)
            io = IOBuffer()
            export_records(P, io; format = fmt, records = 1)
            @test !isempty(take!(io))
        end
    end

    @testset "import is all-or-nothing (single request)" begin
        reset_records!()
        bad = [
            Dict(ID => "10", "redcap_event_name" => ARM2, "age" => "40"),
            Dict(ID => "11", "redcap_event_name" => ARM2, "age" => "not a number"),
        ]
        @test_throws REDCapError import_records(P; data = bad)
        @test isempty(all_ids())
    end

    @testset "batching (batchsize=2)" begin
        reset_records!()
        rows = sample_rows(7)
        @test import_records(P; data = rows) == 7
        unbatched = export_records(P)
        unbatched_csv = sprint(io -> export_records(P, io; format = :csv))
        reset_records!()
        @test import_records(P; data = rows, batchsize = 2) == 7
        @test sorted_rows(export_records(P; batchsize = 2)) == sorted_rows(unbatched)
        @test sorted_rows(export_records(P)) == sorted_rows(unbatched)
        batched_csv = sprint(io -> export_records(P, io; format = :csv, batchsize = 2))
        @test sort(split(batched_csv, '\n')) == sort(split(unbatched_csv, '\n'))
        @test sorted_rows(export_records(P; batchsize = 2, filterLogic = "[age] > 24")) ==
            sorted_rows(export_records(P; filterLogic = "[age] > 24"))
        @test import_records_ids(P; data = rows, batchsize = 2) == string.(1:7)
        @test delete_records(P; records = string.(1:7), batchsize = 2) == 7
        @test isempty(all_ids())
    end

    @testset "files and PDFs" begin
        reset_records!()
        import_records(P; data = [Dict(ID => "1", "redcap_event_name" => ARM1[1], "age" => "30")])
        content = "REDCap.jl live test file\n"
        @test import_file(
            P; record = 1, field = "consent_file", event = ARM1[1], file = IOBuffer(content), filename = "consent.txt",
        ) === nothing
        d = export_file(P; record = 1, field = "consent_file", event = ARM1[1])
        @test String(d.data) == content
        @test d.filename == "consent.txt"
        @test delete_file(P; record = 1, field = "consent_file", event = ARM1[1]) === nothing
        @test_throws REDCapError export_file(P; record = 1, field = "consent_file", event = ARM1[1])
        pdf = export_PDF(P; record = 1, event = ARM1[1], instrument = "demographics")
        @test startswith(String(pdf.data[1:4]), "%PDF")
        @test startswith(String(export_PDF_all_records(P; compactDisplay = true).data[1:4]), "%PDF")
        @test startswith(export_project_XML(P; returnMetadataOnly = true), "<?xml")
    end

    @testset "Data Access Groups" begin
        before = export_DAGs(P)
        @test import_DAGs(P; data = [(data_access_group_name = "REDCap.jl live test", unique_group_name = "")]) == 1
        after = export_DAGs(P)
        new = setdiff(after[:unique_group_name], before[:unique_group_name])
        @test length(new) == 1
        @test delete_DAGs(P; dags = new) == 1
        @test sorted_rows(export_DAGs(P)) == sorted_rows(before)
    end

    if haskey(ENV, "REDCAP_TEST_REPORT_ID")
        @testset "reports" begin
            id = parse(Int, ENV["REDCAP_TEST_REPORT_ID"])
            @test export_reports(P; report_id = id) isa REDCapTable
            @test !isempty(sprint(io -> export_reports(P, io; report_id = id, format = :csv)))
        end
    end

    if enabled("REDCAP_TEST_SURVEYS")
        @testset "surveys" begin
            import_records(P; data = [Dict(ID => "1", "redcap_event_name" => ARM1[1], "age" => "30")])
            args = (record = 1, instrument = "survey_form", event = ARM1[1])
            @test startswith(export_survey_link(P; args...), "http")
            @test export_survey_access_code(P; args...) isa String
            @test export_survey_return_code(P; args...) isa String
            @test startswith(export_survey_queue_link(P; record = 1), "http")
            @test export_survey_participants(P; instrument = "survey_form", event = ARM1[1]) isa REDCapTable
        end
    end

    if enabled("REDCAP_TEST_USERS")
        @testset "users and roles" begin
            @test size(export_users(P), 1) >= 1
            @test export_user_role_assignments(P) isa REDCapTable
            before = export_user_roles(P)
            @test import_user_roles(P; data = [(unique_role_name = "", role_label = "REDCap.jl live test role")]) == 1
            after = export_user_roles(P)
            new = setdiff(after[:unique_role_name], isempty(before) ? String[] : before[:unique_role_name])
            @test length(new) == 1
            @test delete_user_roles(P; roles = new) == 1
        end
    end

    if enabled("REDCAP_TEST_FILE_REPOSITORY")
        @testset "file repository" begin
            # Folders can't be deleted through the API: each run leaves one behind.
            folder = create_file_repository_folder(P; name = "REDCap.jl live test $(now())")
            @test folder isa Int
            @test import_file_into_file_repository(P; file = IOBuffer("hello"), filename = "hello.txt", folder_id = folder) === nothing
            listing = export_file_repository_list(P; folder_id = folder)
            @test "hello.txt" in listing[:name]
            doc_id = parse(Int, string(listing[:doc_id][findfirst(==("hello.txt"), listing[:name])]))
            @test String(export_file_from_file_repository(P; doc_id).data) == "hello"
            @test delete_file_from_file_repository(P; doc_id) === nothing
        end
    end

    if haskey(ENV, "REDCAP_TEST_SUPER_TOKEN")
        @testset "create_project" begin
            @warn "Creating a REDCap project. Projects can't be deleted through the API; this one stays behind."
            s = REDCapSuperUser(;
                url = ENV["REDCAP_TEST_URL"], token = ENV["REDCAP_TEST_SUPER_TOKEN"], transport = transport(),
                allow_insecure = enabled("REDCAP_TEST_ALLOW_INSECURE"),
            )
            @test export_version(s) isa VersionNumber
            title = "REDCap.jl live test $(now())"
            new = create_project(s; data = (project_title = title, purpose = 0))
            @test new isa REDCapProject
            @test export_project_info(new)["project_title"] == title
        end
    end

    reset_records!()
end
