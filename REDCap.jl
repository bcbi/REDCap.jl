""" RedCap-

Desc. """

module REDCap

using JSON
using LightXML
using HTTP
using Requests

#include essentially splats the code into this doc and pretends its there
include("config.jl")
include("ExportRecords.jl")
include("ExportFieldNames.jl")
include("ExportArms.jl")
include("ExportEvents.jl")
include("ExportFile.jl")
include("ExportInstrumentEventMappings.jl")
include("ExportInstruments.jl")
include("ExportMetadata.jl")
include("ExportPDF.jl")
include("ExportProject.jl")
include("ExportProjectInformation.jl")
include("ExportReports.jl")
include("ExportSurveyLink.jl")
include("ExportSurveyParticipantList.jl")
include("ExportSurveyQueueLink.jl")
include("ExportSurveyReturnCode.jl")
include("ExportUser.jl")
include("ExportVersion.jl")
include("GenerateNextRecordID.jl")
include("ImportRecords.jl")
include("ImportUser.jl")
include("ImportArms.jl")
include("ImportEvents.jl")
include("ImportFile.jl")
include("ImportInstrumentEventMappings.jl")
include("ImportMetadata.jl")
include("ImportProjectInformation.jl")
include("DeleteArms.jl")
include("DeleteRecords.jl")
include("DeleteEvents.jl")
include("DeleteFile.jl")
include("../test/runtests.jl")

#export to make them simply usable as toplevel funcs
#export importRecord, Config, exportRecord, runTest
export runTest

end