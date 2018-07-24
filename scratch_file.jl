token = "B04744E28D52C226B2ABACBEC42D0E90"
url = "https://redcap.cis-dev.brown.edu/redcap/api/"

using HTTP
using HTTP.IOExtras
using JSON

query_str = "token=$token&content=record&type=flat&format=json"

query_dict = Dict("token"=>IOBuffer(token),
    "content"=>IOBuffer("record"),
    "records"=>IOBuffer("""1,2,3"""),
    "type"=>IOBuffer("flat"),
    "format"=>IOBuffer("json"))

res = HTTP.request(HTTP.DEFAULT_CLIENT,"POST",HTTP.URI(url),body=query_dict, verbose=3);

sleep(2)

records_to_delete=["1","2"]

query_dict = Dict("token"=>IOBuffer(token),
    "content"=>IOBuffer("record"),
    "action"=>IOBuffer("delete"))

for (i,rec) in enumerate(records_to_delete)
    query_dict["records[$(i-1)]"] = IOBuffer(rec)
end

res = HTTP.request(HTTP.DEFAULT_CLIENT,"POST",HTTP.URI(url),body=query_dict, verbose=3);

sleep(2)

query_dict = Dict("token"=>IOBuffer(token),
    "content"=>IOBuffer("record"),
    "records"=>IOBuffer("""1,2,3"""),
    "type"=>IOBuffer("flat"),
    "format"=>IOBuffer("json"))

res = HTTP.request(HTTP.DEFAULT_CLIENT,"POST",HTTP.URI(url),body=query_dict, verbose=3);
