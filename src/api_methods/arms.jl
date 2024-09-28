"""
	function delete_arms(; url=get_url(), token=get_token(), arms,)

# Description
Delete study arms from a REDCap project

# Requirements
Requires API Import/Update and Project Design/Setup priveleges.
Project must be in "Development" status.

# Notes
If no value is provided for `arms`, all study arms are returned.
Deleting a study arm deletes any included records and data.

# Named arguments
- `url`: (read from `ENV["REDCap_url"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCap_token"]` by default)
- `arms`: names of study arms (can be scalar or vector)

"""
function delete_arms(; url=get_url(), token=get_token(), arms,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;token=REDCap_token(token), content=:arm, action=:import, arms,),
	)
end

"""
	function export_arms(; url=get_url(), token=get_token(), format=nothing, returnFormat=nothing, arms=nothing,)

# Description
Export a REDCap project's study arms

# Requirements
Requires API Export priveleges

# Notes
If no value is provided for `arms`, all study arms are returned.

# Named arguments
- `url`: (read from `ENV["REDCap_url"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCap_token"]` by default)
- `format`: the desired output format: `:csv`, `:json`, or `:xml` (default)
- `arms`: names of study arms (can be scalar or vector)

"""
function export_arms(; url=get_url(), token=get_token(), format=nothing, arms=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:arm, format=REDCap_format(format), arms,),
	)
end

"""
	function import_arms(; url=get_url(), token=get_token(), format=nothing, data=nothing, returnFormat=nothing, override=nothing,)

# Description
Import new study arms to a REDCap project, or rename existing arms

# Requirements
Requires API Import/Update and Project Design/Setup priveleges.
Project must be in "Development" status.

# Notes
Deleting a study arm deletes any included records and data.

# Named arguments
- `url`: (read from `ENV["REDCap_url"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCap_token"]` by default)
- `arms`: names of study arms (can be scalar or vector)
- `override`: if true, all existing arms are erased; if false (default), existing arms can only be renamed
- `data`: Contains attributes `arm_num` and `name`

"""
function import_arms(; url=get_url(), token=get_token(), format=nothing, data=nothing, returnFormat=nothing, override=nothing,)
	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="arms"),
		kwargs = (; token=REDCap_token(token), content=:arm, override, action=:import, format=REDCap_format(format), returnFormat=REDCap_format(returnFormat),),
	)
end
