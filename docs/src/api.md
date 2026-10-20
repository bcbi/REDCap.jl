```@meta
CurrentModule = REDCap
```

# API reference

## Clients and transports

```@docs
AbstractREDCapClient
REDCapProject
REDCapSuperUser
AbstractTransport
HTTPTransport
MockTransport
RecordingTransport
```

## Data, results and errors

```@docs
REDCapTable
REDCapFile
REDCapDownload
REDCapError
REDCapBatchError
```

## Records

```@docs
export_records
export_records_eav
import_records
import_records_ids
overwrite_records
delete_records
rename_record
generate_next_record_name
```

## Metadata, fields and instruments

```@docs
export_metadata
import_metadata
export_field_names
export_instruments
export_PDF
export_PDF_all_records
export_instrument_event_mappings
import_instrument_event_mappings
export_repeating_instruments_and_events
import_repeating_instruments_and_events
```

## Arms and events

```@docs
export_arms
import_arms
replace_arms
delete_arms
export_events
import_events
replace_events
delete_events
```

## Files and the File Repository

```@docs
export_file
import_file
delete_file
create_file_repository_folder
export_file_repository_list
export_file_from_file_repository
import_file_into_file_repository
delete_file_from_file_repository
```

## Projects

```@docs
create_project
export_project_info
import_project_info
export_project_XML
export_version
```

## Reports, logging and surveys

```@docs
export_reports
export_logging
export_survey_link
export_survey_access_code
export_survey_return_code
export_survey_queue_link
export_survey_participants
```

## Users, roles and Data Access Groups

```@docs
export_users
import_users
delete_users
export_user_roles
import_user_roles
delete_user_roles
export_user_role_assignments
import_user_role_assignments
export_DAGs
import_DAGs
delete_DAGs
switch_DAG
export_user_DAG_assignment
import_user_DAG_assignment
```
