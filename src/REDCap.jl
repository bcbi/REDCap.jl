"""
	REDCap - 

Julia frontend for the REDCap API. Handles exporting, importing, and generation of records.
"""

module REDCap

using JSON
using LightXML
using HTTP
using Requests
using DataStructures
using CSV

#include essentially splats the code into this doc and pretends its there
include("Config.jl")
include("Export.jl")
include("Import.jl")

include("../test/runtests.jl")

#export to make them simply usable as toplevel funcs
#export importRecord, Config, exportRecord, runTest
export run_test

end