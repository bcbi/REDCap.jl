redcap_action_parameter = Union{Symbol, Nothing}
redcap_content_parameter = Union{Symbol, Nothing}

redcap_data_parameter = Union{Dict, String} #TODO: this can be nothing in REDCap.request(), but must be mandatory wherever it is a method parameter. Otherwise, it changes the method behavior, which would contradict the guarantee of the function name
redcap_filterLogic_parameter = Union{String, Nothing}
redcap_odm_parameter = Union{String, Nothing}
redcap_token_parameter = Union{String, Nothing}
redcap_url_parameter = Union{String, Nothing}

redcap_array = Union{Array, Nothing}
redcap_bool = Union{Bool, Nothing}
redcap_formatter = Union{Symbol, Nothing}
redcap_symbol = Union{Symbol, Nothing}
redcap_timestamp = Union{DateTime, Nothing} #TODO: YYYY-MM-DD HH:MM

