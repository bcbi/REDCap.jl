""" exportPDF(config::Config; record::Int=1, event::Int=1, instrument::Int=1, allRecords::Bool=false) 

This method allows you to export a PDF file for any of the following: 
1) a single data collection instrument (blank), 2) all instruments (blank), 
3) a single instrument (with data from a single record), 4) all instruments (with data from a single record), 
or 5) all instruments (with data from ALL records). 
This is the exact same PDF file that is downloadable from a project's data entry 
form in the web interface, and additionally, the user's privileges with regard to 
data exports will be applied here just like they are when downloading the PDF in 
the web interface (e.g., if they have de-identified data export rights, then it 
will remove data from certain fields in the PDF). If the user has 'No Access' data 
export rights, they will not be able to use this method, and an error will be returned."""

function exportPDF(config::Config; record::Int=1, event::Int=1, instrument::Int=1, allRecords::Bool=false)
	if allRecords==true
		fields = Dict("token" => config.key, 
					  "content" => "pdf",
					  "allRecords" => true) #take opt fields
	else
		fields = Dict("token" => config.key, 
					  "content" => "pdf",
					  "record" => record,
					  "event" => event,
					  "instrument" => instrument)
	end
	print("POSTing")
	output = HTTP.post(config.url; body=fields)
	print("POSTd")
	return String(output.body)
end