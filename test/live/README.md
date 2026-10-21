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

**Instruments.** Create the three instruments first (*Designer → Online Designer*), then
add their fields. The unique instrument names must be exactly `demographics`, `visits` and
`survey_form`; REDCap derives them from the name you give each instrument ("Demographics",
"Visits", "Survey Form"), and the Codebook shows them. A new project starts with one
instrument holding `record_id`: in the finished project, `demographics` must be the first
instrument and `record_id` its first field.

**Fields** (field names must match exactly)

| Instrument | Field type | Field name | Validation | Notes |
|---|---|---|---|---|
| `demographics` | Text Box | `record_id` | | Must be the **first** field (the record ID field) |
|  `demographics` | Text Box | `age` | Integer | |
|  `demographics` | Radio Buttons | `sex` | | Choices: `1, Female` and `2, Male` |
| `demographics`  | File Upload | `consent_file` | | |
| `visits` | Text Box | `visit_date` | Date (Y-M-D) | |
| `visits`  | Text Box | `visit_note` | | |
| `survey_form` | Text Box | `rating` | Integer | |

Enable `survey_form` as a survey, with "Save & Return Later" on.

**Arms, events and instrument designations**

Label the events exactly `baseline` and `followup`. REDCap generates each unique event
name from the label by appending the arm (`_arm_1`, `_arm_2`), and the tests use these
unique names.

| Arm | Event label | Unique event name | Instruments |
|---|---|---|---|
| Arm 1 | `baseline` | `baseline_arm_1` | `demographics`, `survey_form` |
| Arm 1 | `followup` | `followup_arm_1` | `visits` |
| Arm 2 | `baseline` | `baseline_arm_2` | `demographics` |

**Repeating instruments and events**
- In `followup_arm_1`, choose *Repeat Instruments* and select `visits`. Don't choose
  *Repeat Entire Event*: the tests check that `visits` is listed as a repeating
  instrument, and import its rows with `redcap_repeat_instrument = "visits"`.

**Other**
- At least one Data Access Group (e.g. "Site A"). Your API user should *not* be assigned
  to a DAG, so it can see all records.
- Optional: enable the survey queue (for `export_survey_queue_link`).
- Optional: a report, whose ID you pass as `REDCAP_TEST_REPORT_ID`.

**Your user rights** in the sandbox: API Export and API Import, Create Records, Rename
Records and Delete Records (three separate rights), Data Access Groups, Logging, File
Repository, Project Design and Setup, and (only for `REDCAP_TEST_USERS`) User Rights.
Then request an API token for the project.

Once the project works with the tests, export it (*Other Functionality → Download
metadata only (XML)*) and commit the file as `test/live/sandbox.REDCap.xml`, so the sandbox
can be rebuilt with "Create a project from a REDCap XML file".

## 2. Run the tests

### Set the test variables

The suite reads the sandbox's URL and token from `REDCAP_TEST_URL` and
`REDCAP_TEST_TOKEN`. The simplest place for them is your Julia startup file,
`~/.julia/config/startup.jl`, which Julia runs before every session and script:

```julia
ENV["REDCAP_TEST_URL"] = "https://redcap.example.org/api/"
ENV["REDCAP_TEST_TOKEN"] = "<the sandbox project's 32-character token>"
```

The test variables are deliberately different from `REDCAP_API_URL` and
`REDCAP_API_TOKEN`, so the token you use every day is never used for these destructive
tests. The suite refuses to run without them, and stops if the project is in production.

### Run the script

```sh
julia test/live/runtests.jl
```

The script tests the REDCap.jl checkout that contains it (two directories up), using its
working tree, so uncommitted changes are included. To test another copy of REDCap.jl,
run that copy's `test/live/runtests.jl`. The script works in a temporary environment, so
it doesn't modify the checkout (except for fixtures recorded with `REDCAP_TEST_RECORD=1`).

### Optional parts

| Variable | Enables |
|---|---|
| `REDCAP_TEST_SURVEYS=1` | survey links, codes, queue link and participant list (needs the survey setup above) |
| `REDCAP_TEST_USERS=1` | exports users, creates and deletes a temporary user role |
| `REDCAP_TEST_FILE_REPOSITORY=1` | uploads, exports and deletes a file in a new folder. **Folders can't be deleted through the API; each run leaves one behind.** |
| `REDCAP_TEST_REPORT_ID=<id>` | report exports |
| `REDCAP_TEST_SUPER_TOKEN=<token>` | `create_project`. **Projects can't be deleted through the API; each run leaves one behind.** |
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

## What the tests confirm

Besides checking each method against a real server, the tests check REDCap behaviour that
the package relies on but REDCap doesn't document, such as:

- a single import request containing an invalid row imports nothing (the "import is
  all-or-nothing" test)
- project settings are only applied when sent as a single JSON object, not an array (the
  `project_notes` round trip)

Behaviour that hasn't been confirmed yet is marked `TODO(verify)` in the code.
