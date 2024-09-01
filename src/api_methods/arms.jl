function delete_arms(;
	url=get_url(),
	token=get_token(),	
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
	kwargs = (;token=REDCap_token(token),
	       content=:arm,
	       action=REDCap_action(:import),
	       arms,),
	)
end

function export_arms(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	returnFormat=nothing,
	arms=nothing,
	)

	REDCap.request(;
		url=REDCap_url(url),
		kwargs = (;
		token=REDCap_token(token),
	       content=:arm,
		format=REDCap_format(format),
		arms=arms,
		returnFormat=REDCap_format(returnFormat),
		),
	)
end

#All examples use JSON
#TODO: what is the proper format for multi-item XML? I can't find this anywhere...
function import_arms(;
	url=get_url(),
	token=get_token(),	
	format=nothing,
	data=nothing, #TODO: is this required, given the action parameter?
	returnFormat=nothing,
	override=0,
	)

	REDCap.request(;
		url=REDCap_url(url),
		data=REDCap_data(data,REDCap_format(format),xml_tag="arms"),
		kwargs = (;
		token=REDCap_token(token),
	       content=:arm,
		override=override,
		action=REDCap_action(:import),
		format=REDCap_format(format),
		returnFormat=REDCap_format(returnFormat),
		),
	)
end
