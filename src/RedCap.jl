""" RedCap-

Desc. """

module RedCap

using JSON
using HTTP
using Requests

#include essentially splats the code into this doc and pretends its there
include("config.jl")
include("ImportRecord.jl")
include("ExportRecord.jl")
include("test.jl")
#export to make them simply usable as toplevel funcs
export importRecord, Config, exportRecord, testImport, testExport


end