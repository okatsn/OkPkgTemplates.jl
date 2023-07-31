using OkPkgTemplates
using Documenter

DocMeta.setdocmeta!(OkPkgTemplates, :DocTestSetup, :(using OkPkgTemplates); recursive=true)

makedocs(;
    modules=[OkPkgTemplates],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/OkPkgTemplates.jl/blob/{commit}{path}#{line}",
    sitename="OkPkgTemplates.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/OkPkgTemplates.jl",
        edit_link="main",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
        "Keynote" =>
            ["Macro call explained" => "sayhello.md"]
    ]
)

deploydocs(;
    repo="github.com/okatsn/OkPkgTemplates.jl",
    devbranch="main"
)
