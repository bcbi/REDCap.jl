var documenterSearchIndex = {"docs":
[{"location":"examples/","page":"Examples","title":"Examples","text":"CurrentModule = REDCap","category":"page"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Some example function calls:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"export_version()\n\nexport_metadata()\n\nexport_logging(format=:json) |> JSON.parse |> DataFrame\n\n# Add ability to delete records\nimport_users(data=(username = \"userName\",record_delete = 1))\n\ndelete_records(records=[\"TM22-15374\",\"TM22-16931\",\"TM22-21015\"])","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"The following example is a more realistic workflow that creates a new project from an existing project XML (data dictionary) and uploads large CSV data files into it in segments.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Dates\nusing REDCap\nusing ProgressMeter\n\nfunction main()\nprintln(\"Working...\")\n\nproject_token = create_project(\n       data=Dict(\n\t\t:project_title => \"Workflow test v$(now())\",\n\t\t:purpose => 3,\n\t),\n       odm=read(\"project.xml\",String),\n)\n\nchunk_size = 100\nfor file in [\n\"table_1.csv\",\n\"table_2.csv\",\n\"table_3.csv\",\n]\n\n\t# Measure progress\n\tnumber_of_lines = parse(Int, read(`wc -l $file`,String) |> split |> first)\n\tnumber_of_uploads = number_of_lines ÷ chunk_size + 1\n\tprog = Progress(number_of_uploads, desc = file)\n\n\t(header, rows) = Iterators.peel(  eachline(file ) )\n\tfor block in Iterators.partition( rows, chunk_size)\n\t\timport_records(\n\t\t\ttoken=project_token,\n\t\t\tformat=:csv,\n\t\t\tdata=header * '\\n' * join(block, '\\n')\n\t\t)\n\t\tnext!(prog)\n\tend\n\tfinish!(prog)\nend\n\nend\nmain()","category":"page"},{"location":"","page":"REDCap.jl","title":"REDCap.jl","text":"CurrentModule = REDCap","category":"page"},{"location":"#REDCap.jl","page":"REDCap.jl","title":"REDCap.jl","text":"","category":"section"},{"location":"","page":"REDCap.jl","title":"REDCap.jl","text":"Pages = [\"index.md\", \"examples.md\"]","category":"page"},{"location":"#Overview","page":"REDCap.jl","title":"Overview","text":"","category":"section"},{"location":"","page":"REDCap.jl","title":"REDCap.jl","text":"A Julia frontend for REDCap's API.","category":"page"},{"location":"#Index","page":"REDCap.jl","title":"Index","text":"","category":"section"},{"location":"","page":"REDCap.jl","title":"REDCap.jl","text":"","category":"page"}]
}
