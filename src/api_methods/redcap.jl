"""
	function export_version(; url=get_url(), token=get_token(),)

Export the REDCap version

# Named arguments
- `url`: (read from `ENV["REDCAP_API_URL"]` by default)
- `token`: an API token specific to the REDCap project and username (read from `ENV["REDCAP_API_TOKEN"]` by default)

"""
function export_version(; url=get_url(), token=get_token(),)
	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (; token=REDCap_token(token), content=:version,),
	)
end
