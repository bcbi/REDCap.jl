```@meta
CurrentModule = REDCap
```
# Examples
Some example function calls:
```julia
export_version()

export_metadata()

export_logging(format=:json) |> JSON.parse |> DataFrame

# Add ability to delete records
import_users(data=(username = "userName",record_delete = 1))

delete_records(records=["TM22-15374","TM22-16931","TM22-21015"])
```

The following example is a more realistic workflow that creates a new project from an existing project XML (data dictionary) and uploads large CSV data files into it in segments.

```julia
using Dates
using REDCap
using ProgressMeter

function main()
println("Working...")

project_token = create_project(
       data=Dict(
		:project_title => "Workflow test v$(now())",
		:purpose => 3,
	),
       odm=read("project.xml",String),
)

chunk_size = 100
for file in [
"table_1.csv",
"table_2.csv",
"table_3.csv",
]

	# Measure progress
	number_of_lines = parse(Int, read(`wc -l $file`,String) |> split |> first)
	number_of_uploads = number_of_lines ÷ chunk_size + 1
	prog = Progress(number_of_uploads, desc = file)

	(header, rows) = Iterators.peel(  eachline(file ) )
	for block in Iterators.partition( rows, chunk_size)
		import_records(
			token=project_token,
			format=:csv,
			data=header * '\n' * join(block, '\n')
		)
		next!(prog)
	end
	finish!(prog)
end

end
main()
```
