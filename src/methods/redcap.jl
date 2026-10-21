"""
    export_version(client) -> VersionNumber

The REDCap version of the server. Accepts a project or a super user client.
"""
export_version(client::AbstractREDCapClient) = api_call(:export_version, client)
