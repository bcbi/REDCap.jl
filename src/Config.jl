"""
	Config

Struct to hold api url and key/superkey 
`APIConfigObj = Config("http...","ABCD...")`

##Fields:
* `url` - the url of the REDCap instance
* `key` - either the standard or super API key
"""

struct Config
	url::String
	key::String
	#basic validation - checks that the url starts and ends 'properly', and then checks the key length
	#modify by checking if hyperlink? should I get regex-y?
	#/or/, try to setup a really quick HTTP status 200 check, and hinge validation on that.
	Config(url, key) = (((isa(url,String) && isequal(url[end-4:end], "/api/")) && 
						(isequal(url[1:7], "http://") || isequal(url[1:8], "https://"))) ? 
						((length(key)!=32 && length(key)!=64) ? 
						error("Invalid Key: must be 32 characters long for a standard key, 
							or 64 characters long for a super key.") : 
						new(url, key)) : 
						error("Invalid URL: Must be in format of http(s)://<redcap-hosting-url>/api/"))
end