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

Request an API token for the project and ensure that you have the following privileges: API Export, API Import, Create Records, Rename
Records, Delete Records, Data Access Groups, Logging, File
Repository, Project Design and Setup, and User Rights.

**Enable** the following settings under **Main project settings**:

- "Use surveys in this project?"
- "Use longitudinal data collected with defined events?"

**Disable** the following setting under **Enable optional modules and customizations**:

- "Auto-numbering for records"

**Instruments.** Under **Design your data collection instruments & enable your surveys**, go to the Online Designer. Create the following instruments in order, then delete the default instrument that was already present. Afterwards, populate the instruments with the following field names:

| Instrument | Field type | Variable name | Validation | Notes |
|---|---|---|---|---|
| `demographics` | Text Box | `record_id` | | Should already exist |
| `demographics` | Text Box | `age` | Integer | |
| `demographics` | Multiple Choice (Radio Buttons) | `contact_method` | | Choices: `1, Phone` and `2, Email` |
| `demographics`  | File Upload | `consent_file` | | |
| `visits` | Text Box | `visit_date` | Date (Y-M-D) | |
| `visits`  | Text Box | `visit_note` | | |
| `survey_form` | Text Box | `rating` | Integer | |

Enable `survey_form` as a survey, with "Allow 'Save & Return Later; option for respondents?" set to "Yes", and save changes.

Under **Design your data collection instruments & enable your surveys**, define the events `baseline` and `followup`, and delete any default event that already existed.
Add a new arm named "Arm 2" (Arm 1 will already exist), and create only a `baseline` event for this arm.

Under the **Designate Instrument for My Events** tab, for Arm 1, check `demographics` and `survey_form` under `baseline` and `visits` under `followup` and save. For Arm 2, check only `demographics`.

Back in the Project Setup tab, enable **Repeating instruments and events**
- In `followup_arm_1`, choose *Repeat Instruments (repeat independently of each other)*, and select `visits` for the Instrument name.

Finally, on the sidebar, click DAG (under Applications). Create a new group (any name), but do not assign yourself to it.

**For the optional tests** (see [Optional parts](#optional-parts))
- In the Online Designer, under Survey Options, activate `survey_form`. For "Display survey in the Survey Queue when...", check "When the following logic becomes true:" and use the logic `[record_id] <> ""`.
- Under **Data Exports, Reports, and Stats** in the sidebar, click "Create New Report". Create a new report with any name and the default options. Its ID is shown in the report list, and in the report's URL as `report_id=`.

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

The script prints each testset as it starts (`▶ records`) and ends, with its time and any
failures and errors (`✔ records (12.3 s)` or `✘ records (12.3 s, 1 failed or errored)`),
followed by the usual test summary. With `REDCAP_TEST_VERBOSE=1`, it also prints one line
per request, with the method, HTTP status, response size and time.

### Optional parts

| Variable | Enables |
|---|---|
| `REDCAP_TEST_SURVEYS=1` | survey link, return code, queue link and participant list (needs the survey and survey queue setup above) |
| `REDCAP_TEST_USERS=1` | exports users, creates and deletes a temporary user role (needs the User Rights right) |
| `REDCAP_TEST_FILE_REPOSITORY=1` | uploads, exports and deletes a file in a new folder. **Folders can't be deleted through the API; each run leaves one behind.** |
| `REDCAP_TEST_REPORT_ID=<id>` | report exports |
| `REDCAP_TEST_SUPER_TOKEN=<token>` | `create_project`. **Projects can't be deleted through the API; each run leaves one behind.** |
| `REDCAP_TEST_ALLOW_INSECURE=1` | a plain `http://` URL, e.g. a local development server |
| `REDCAP_TEST_RECORD=1` | records fixtures (see below) |
| `REDCAP_TEST_VERBOSE=1` | prints a line for each request (method, HTTP status, response size, time) |

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
the package relies on but might not be documented, such as:

- a single import request containing an invalid row imports nothing (the "import is
  all-or-nothing" test)
- project settings are only applied when sent as a single JSON object, not an array (the
  `project_notes` round trip)
- importing instrument-event mappings replaces all mappings, in every arm, and importing
  the repeating setup replaces the whole setup ("structure imports: add or replace")
- data dictionary rows are read by column position, not by name, even as JSON (the EAV
  check's temporary checkbox field)
- a CSV export that matches no records is a bare newline, without a header (the batched
  CSV export with an empty first batch)
- `type=eav` exports ignore `exportCheckboxLabel` and `rawOrLabelHeaders`
- with `forceAutoNumber=true`, `import_records_ids` returns the names REDCap created
