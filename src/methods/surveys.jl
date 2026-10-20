"""
    export_survey_link(project; record, instrument, event, repeat_instance) -> String

A record's unique link to a survey, as a `String`.

# Keyword arguments
$SURVEY_KWARGS_DOC
"""
export_survey_link(project::REDCapProject; record, instrument, event = nothing, repeat_instance = nothing) =
    api_call(:export_survey_link, project; record, instrument, event, repeat_instance)

"""
    export_survey_access_code(project; record, instrument, event, repeat_instance) -> String

A record's survey access code, as a `String`.

# Keyword arguments
$SURVEY_KWARGS_DOC
"""
export_survey_access_code(project::REDCapProject; record, instrument, event = nothing, repeat_instance = nothing) =
    api_call(:export_survey_access_code, project; record, instrument, event, repeat_instance)

"""
    export_survey_return_code(project; record, instrument, event, repeat_instance) -> String

A record's survey return code (for surveys with "Save & Return Later" enabled), as a
`String`.

# Keyword arguments
$SURVEY_KWARGS_DOC
"""
export_survey_return_code(project::REDCapProject; record, instrument, event = nothing, repeat_instance = nothing) =
    api_call(:export_survey_return_code, project; record, instrument, event, repeat_instance)

"""
    export_survey_queue_link(project; record) -> String

A record's survey queue link, as a `String`.

# Keyword arguments
- `record` (required): the record name
"""
export_survey_queue_link(project::REDCapProject; record) = api_call(:export_survey_queue_link, project; record)

"""
    export_survey_participants(project; instrument, event) -> REDCapTable
    export_survey_participants(project, io::IO; format, instrument, event) -> nothing

Export the participant list of a survey.

$IO_METHOD_DOC

# Keyword arguments
- `instrument` (required): the unique instrument name (must be enabled as a survey)
- `event`: the unique event name (longitudinal projects)
"""
export_survey_participants(project::REDCapProject; instrument, event = nothing) =
    api_call(:export_survey_participants, project; instrument, event)

export_survey_participants(project::REDCapProject, io::IO; format, instrument, event = nothing) =
    api_call_io(:export_survey_participants, project, io; format, instrument, event)
