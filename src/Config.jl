"""
	REDCap.Config(url::String, key::String; ssl::Bool = true)

Struct to hold api url and key/superkey.
`APIConfigObj = Config("http...","ABCD...")`

This will be passed to all function calls to both orient and authorize the api_pusher() function. The REDCap API cannot
be accessed without this config object properly set-up. Always test your config object before automating a project. 

#### NOTE: SSL should always be on by default.
If for whatever reason, your project will not SSL verify AND you must use it, disable ssl verification with `ssl=false`
Leaving SSL verification disabled leaves you open for Man-in-the-Middle attacks and is generally just bad practice.

#### Parameters:
* `url` - The url of the REDCap instance.
* `key` - Either the standard or super API key.
* `ssl` - Flag to enable ssl verification
"""
struct Config
	url::String
	key::String
	ssl::Bool
	function Config(url::String, key::String; ssl::Bool = true)
		#TODO: What's the proper datatype? Hexadecimal? A new string literal?
		is_valid_redcap_token(x) = occursin(r"^[0-9A-F]{32}([0-9A-F]{32})?$", x)
		is_valid_redcap_url(x) = occursin(r"^https:\/\/.*\/api\/?$", x)

		if is_valid_redcap_token(key) && is_valid_redcap_url(url)
			new(url, key, ssl)
		else
			@error("Invalid REDCap credentials")
			new("", "", ssl)
		end
	end
end

get_redcap_user_config() = Config(get(ENV, "REDCAP_API_URL", ""), get(ENV, "REDCAP_API_TOKEN", ""))
get_redcap_superuser_config() = Config(get(ENV, "REDCAP_API_URL", ""), get(ENV, "REDCAP_API_SUPER_TOKEN", ""))
