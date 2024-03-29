using {{{PKG}}}
using Documenter
# using DocumenterCitations
# # 1. Uncomment this line and the CitationBibliography line
# # 2. add docs/src/refs.bib
# # 3. Cite something in refs.bib and add ```@bibliography ``` (in index.md, for example)
# # Please refer https://juliadocs.org/DocumenterCitations.jl/stable/


DocMeta.setdocmeta!({{{PKG}}}, :DocTestSetup, :(using {{{PKG}}}); recursive=true)

makedocs(;
    modules=[{{{PKG}}}],
    authors="{{{AUTHORS}}}",
    repo="https://{{{REPO}}}/blob/{commit}{path}#{line}",
    sitename="{{{PKG}}}.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
{{#CANONICAL}}
        canonical="{{{CANONICAL}}}",
{{/CANONICAL}}
{{#EDIT_LINK}}
        edit_link={{{EDIT_LINK}}},
{{/EDIT_LINK}}
        assets={{^HAS_ASSETS}}String{{/HAS_ASSETS}}[{{^HAS_ASSETS}}],{{/HAS_ASSETS}}
{{#ASSETS}}
            "assets/{{{.}}}",
{{/ASSETS}}
{{#HAS_ASSETS}}
        ],
{{/HAS_ASSETS}}
    ),
    pages=[
        "Home" => "index.md",
    ],
    # plugins=[
    #     CitationBibliography(joinpath(@__DIR__, "src", "refs.bib")),
    # ],
{{#MAKEDOCS_KWARGS}}
    {{{first}}}={{{second}}},
{{/MAKEDOCS_KWARGS}}
)
{{#HAS_DEPLOY}}

deploydocs(;
    repo="{{{REPO}}}",
{{#BRANCH}}
    devbranch="{{{BRANCH}}}",
{{/BRANCH}}
)
{{/HAS_DEPLOY}}
