"""
	Config

Struct to hold api url and key eg APIConfigObj = Config("http...","ABCD...")
"""
struct Config
	url::String
	key::String
	#basic validation - checks that the url starts and ends 'properly', and then checks the length of the api-key
	Config(url, key) = (((typeof(url)==String && isequal(url[end-3:end], "api/")) && isequal(url[1:4], "http")) ? 
						(length(key)<32 ? error("Invalid Key: must be 32 characters long") : new(url, key)) : error("Invalid URL: Must be in format of http://<redcap-hosting-url>/api/"))
end