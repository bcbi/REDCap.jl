# A tiny in-memory imitation of a longitudinal REDCap project, for batching tests. It
# implements just enough of metadata export and record export/import/delete.

using JSON

mutable struct FakeREDCap
    fields::Vector{String}               # data dictionary; the first is the record ID field
    rows::Vector{Dict{String, String}}   # one per record and event
    fail_at::Int                         # fail the n-th record request (0: never)
    record_requests::Int
end

FakeREDCap(fields, rows) = FakeREDCap(fields, rows, 0, 0)

const EVENT = "redcap_event_name"

idfield(fake::FakeREDCap) = first(fake.fields)
columns(fake::FakeREDCap, fields) = [idfield(fake); EVENT; [f for f in fake.fields[2:end] if fields === nothing || f in fields]]

function indexed(req, name)
    values = String[]
    i = 0
    while (v = field(req, "$name[$i]")) !== nothing
        push!(values, v)
        i += 1
    end
    return isempty(values) ? nothing : values
end

function json_rows(cols, rows)
    return "[" * join(("{" * join(("$(JSON.json(c)):$(JSON.json(get(r, c, "")))" for c in cols), ",") * "}" for r in rows), ",") * "]"
end

csv_rows(cols, rows) = join([join(cols, ","); [join((get(r, c, "") for c in cols), ",") for r in rows]], "\n") * "\n"

function matches_filter(row, logic)
    logic === nothing && return true
    m = match(r"^\[(\w+)\] = '(.*)'$", logic)
    m === nothing && error("FakeREDCap: unsupported filterLogic $logic")
    return get(row, m[1], "") == m[2]
end

function (fake::FakeREDCap)(req::REDCapRequest)
    content = field(req, "content")
    content == "metadata" && return ok(json_rows(["field_name"], [Dict("field_name" => f) for f in fake.fields]))
    content == "record" || error("FakeREDCap: unsupported content $content")
    fake.record_requests += 1
    fake.record_requests == fake.fail_at && return REDCapResponse(500, """{"error":"simulated failure"}""")
    action = field(req, "action")
    if action == "delete"
        ids = indexed(req, "records")
        n = length(unique(r[idfield(fake)] for r in fake.rows if r[idfield(fake)] in ids))
        filter!(r -> !(r[idfield(fake)] in ids), fake.rows)
        return ok(string(n))
    elseif (data = field(req, "data")) !== nothing
        incoming = [Dict{String, String}(k => string(v) for (k, v) in row) for row in JSON.parse(data)]
        any(r -> get(r, "age", "") == "invalid", incoming) &&
            return REDCapResponse(400, """{"error":"invalid value for age"}""")
        for row in incoming
            key = (row[idfield(fake)], get(row, EVENT, ""))
            i = findfirst(r -> (r[idfield(fake)], get(r, EVENT, "")) == key, fake.rows)
            i === nothing ? push!(fake.rows, row) : merge!(fake.rows[i], row)
        end
        ids = unique(r[idfield(fake)] for r in incoming)
        return ok(field(req, "returnContent") == "ids" ? JSON.json(ids) : """{"count": $(length(ids))}""")
    else
        ids = indexed(req, "records")
        events = indexed(req, "events")
        rows = filter(fake.rows) do r
            (ids === nothing || r[idfield(fake)] in ids) &&
                (events === nothing || r[EVENT] in events) &&
                matches_filter(r, field(req, "filterLogic"))
        end
        cols = columns(fake, indexed(req, "fields"))
        return ok(field(req, "format") == "csv" ? csv_rows(cols, rows) : json_rows(cols, rows))
    end
end

"A fake project with `n` records, each with a baseline and a follow-up event."
function fake_project_data(n)
    rows = Dict{String, String}[]
    for i in 1:n, event in ("baseline_arm_1", "followup_arm_1")
        push!(rows, Dict("record_id" => string(i), EVENT => event, "age" => string(20 + i), "group" => isodd(i) ? "a" : "b"))
    end
    return FakeREDCap(["record_id", "age", "group"], rows)
end
