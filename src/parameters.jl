macro action(arg)
	if arg in ["rename", "delete","export","import", "list", "switch"]
		kwarg = Expr(:kw, :action, arg)
		return esc( :( $(kwarg) ) )
	else
		error("Unsupported REDCap API parameter")
		throw(ArgumentError)
	end
end

macro content(arg)
	if arg in ["arm","dag","userDagMapping", "event", "exportFieldNames", "file", "fileRepository", "instrument", "pdf", "formEventMapping", "log", "metadata", "project", "projectSettings", "project_xml", "record", "generateNextRecordName", "repeatingFormsEvents", "report", "version", "surveyLink", "participantList", "surveyQueueLink", "surveyReturnCode", "user", "userRole", "userRoleMapping"]
		kwarg = Expr(:kw, :content, arg)
		return esc( :( $(kwarg) ) )
	else
		error("Unsupported REDCap API parameter")
		throw(ArgumentError)
	end
end

macro format(arg)
	if arg in ["csv","json","xml", "odm"]
		kwarg = Expr(:kw, :format, arg)
		return esc( :( $(kwarg) ) )
	else
		error("Unsupported REDCap API parameter")
		throw(ArgumentError)
	end
end

macro returnFormat(arg)
	if arg in ["csv","json","xml"]
		kwarg = Expr(:kw, :returnFormat, arg)
		return esc( :( $(kwarg) ) )
	else
		error("Unsupported REDCap API parameter")
		throw(ArgumentError)
	end
end
