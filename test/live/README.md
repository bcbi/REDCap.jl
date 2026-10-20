# Live tests

These tests run REDCap.jl against a real REDCap server. They are **manual and local
only**: CI never runs them, and `Pkg.test()` doesn't either.

> [!WARNING]
> The live tests **delete every record** in the project they run against, at the start
> and end of each run, and re-import its arms, mappings, repeating setup and data
> dictionary. Only ever point them at a dedicated sandbox project.

## 1. Build the sandbox project

REDCap projects can be created through the API but never deleted, so the tests use one
long-lived sandbox project that you build once in the REDCap web interface. Create a new
project (purpose "Practice / Just for fun", **left in Development status**) with:

**Project setup**
- Longitudinal data collection: **enabled**
- Surveys: **enabled**
- Record auto-numbering: **disabled**

**Instruments and fields** (field names must match exactly)

| Instrument | Field | Type | Notes |
|---|---|---|---|
| `demographics` | `record_id` | Text | Must be the **first** field (the record ID field) |
| | `age` | Text, validation *Integer* | |
| | `sex` | Radio | Choices `1, Female \| 2, Male` |
| | `consent_file` | File Upload | |
| `visits` | `visit_date` | Text, validation *Date (Y-M-D)* | |
| | `visit_note` | Text | |
| `survey_form` | `rating` | Text, validation *Integer* | Enable this instrument as a survey, with "Save & Return Later" on |

**Arms and events**

| Arm | Events (unique names) |
|---|---|
| Arm 1 | `baseline_arm_1`, `followup_arm_1` |
| Arm 2 | `baseline_arm_2` |

**Designate instruments for events**
- `demographics`: `baseline_arm_1` and `baseline_arm_2`
- `visits`: `followup_arm_1`
- `survey_form`: `baseline_arm_1`

**Repeating instruments and events**
- `visits` repeats in `followup_arm_1`

**Other**
- At least one Data Access Group (e.g. "Site A"). Your API user should *not* be assigned
  to a DAG, so it can see all records.
- Optional: enable the survey queue (for `export_survey_queue_link`).
- Optional: a report, whose ID you pass as `REDCAP_TEST_REPORT_ID`.

**Your user rights** in the sandbox: API Export and API Import, Create / Rename / Delete
Records, Data Access Groups, Logging, File Repository, Project Design and Setup, and
(only for `REDCAP_TEST_USERS`) User Rights. Then request an API token for the project.

Once the project works with the tests, export it (*Other Functionality → Download
metadata only (XML)*) and commit the file as `test/live/sandbox.REDCap.xml`, so the sandbox
can be rebuilt with "Create a project from a REDCap XML file".

## 2. Run the tests

```sh
export REDCAP_TEST_URL="https://redcap.example.org/api/"
export REDCAP_TEST_TOKEN="<the sandbox project's 32-character token>"
julia test/live/runtests.jl
```

The script activates `test/live/` as its environment and develops REDCap.jl from this
checkout, so no other setup is needed.

The test variables are deliberately different from `REDCAP_API_URL` and
`REDCAP_API_TOKEN`, so the token you use every day is never used for these destructive
tests. The suite refuses to run without them, and stops if the project is in production.

### Optional parts

| Variable | Enables |
|---|---|
| `REDCAP_TEST_SURVEYS=1` | survey links, codes, queue link and participant list (needs the survey setup above) |
| `REDCAP_TEST_USERS=1` | exports users, creates and deletes a temporary user role |
| `REDCAP_TEST_FILE_REPOSITORY=1` | uploads, exports and deletes a file in a new folder. **Folders can't be deleted through the API: each run leaves one behind.** |
| `REDCAP_TEST_REPORT_ID=<id>` | report exports |
| `REDCAP_TEST_SUPER_TOKEN=<token>` | `create_project`. **Each run creates a project that can't be deleted.** |
| `REDCAP_TEST_ALLOW_INSECURE=1` | a plain `http://` URL, e.g. a local development server |
| `REDCAP_TEST_RECORD=1` | records fixtures (see below) |

## 3. Record fixtures

With `REDCAP_TEST_RECORD=1`, every request and response is saved through
`RecordingTransport` to `test/fixtures/recorded/<timestamp>/`. The CI test suite replays
everything under `test/fixtures/` to check that real REDCap output parses correctly.

Tokens are removed automatically: the request token is dropped and replaced wherever it
appears, and the token returned by `create_project` is replaced with zeros.

> [!IMPORTANT]
> **Review recorded fixtures for personal data before committing them.** They contain
> the full requests and responses: record values, usernames, email addresses (from user
> exports), logging details and file contents. The sandbox should only ever hold made-up
> data, but check anyway, and delete any fixture you aren't sure about.

Commit the fixtures you want to keep; the CI suite picks them up automatically.

## What the tests confirm

Besides checking each method against a real server, a run confirms behaviour that is
marked `TODO(verify)` in the code. In particular, the "import is all-or-nothing" test
checks that a single import request containing an invalid row imports nothing, and
prints a confirmation when it passes.
