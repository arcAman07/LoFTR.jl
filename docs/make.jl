using LoFTR
using Documenter

DocMeta.setdocmeta!(LoFTR, :DocTestSetup, :(using LoFTR); recursive=true)

makedocs(;
    modules=[LoFTR],
    authors="Aman <aman.sharma2020b@vitstudent.ac.in> and contributors",
    repo="https://github.com/arcAman07/LoFTR.jl/blob/{commit}{path}#{line}",
    sitename="LoFTR.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://arcAman07.github.io/LoFTR.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/arcAman07/LoFTR.jl",
    devbranch="master",
)
