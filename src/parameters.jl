macro action(arg)
	if arg in ["delete","export","import"]
		kwarg = Expr(:kw, :action, arg)
		return esc( :( $(kwarg) ) )
	else
		error("Unsupported REDCap API parameter")
		throw(ArgumentError)
	end
end
