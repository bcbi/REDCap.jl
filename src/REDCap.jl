"""
	REDCap - 

Julia frontend for the REDCap API. Handles exporting, importing, and generation of records.
"""

module REDCap

using JSON
using LightXML
using HTTP
using CSV

using DataStructures
using DataFrames

#include essentially splats the code into this doc and pretends its there
include("Config.jl")
include("Export.jl")
include("Import.jl")
include("Delete.jl")
include("Utils.jl")


#export to make them simply usable as toplevel funcs
#export importRecord, Config, exportRecord
#cheat and include this
include("../test/myTests.jl")
export run_test
#REMOVE ASAP

end