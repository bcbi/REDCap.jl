"""
	Config

Struct to hold api url and key eg APIConfigObj = Config("http...","ABCD...")
"""
struct Config
	url::String
	key::String
end

"""
	SuperConfig

Struct to hold api url and super-key eg APIConfigObj = Config("http...", "ABCDEF...")
NOTE: Super API key only used in project creation.
"""
struct SuperConfig
	url::String
	key::String
end