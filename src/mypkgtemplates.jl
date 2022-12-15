



# # See PkgTemplates/src/plugin.jl
const DEFAULT_TEMPLATE_DIR = Ref{String}(joinpath(dirname(dirname(pathof(OkPkgTemplates))), "mypkgtemplates")) # KEYNOTE: Check the package name and folder name if moved to other package
"""
Return a path relative to the default template file directory
(`Shorthands/mypkgtemplates`).
"""
mypkgtemplate_dir(paths::AbstractString...) = joinpath(DEFAULT_TEMPLATE_DIR[], paths...)




function template_001(; destination="", julia_ver = v"1.6", username="okatsn")
    if isempty(destination)
        destination = Pkg.devdir()
    end
    Template(;
    user=username,
    dir=destination,
    julia=julia_ver,
    plugins=[
        Git(; manifest=false),
        GitHubActions(;file = mypkgtemplate_dir("github", "workflows", "CI.yml")), # see PkgTemplates/src/plugins/ci.jl
        Codecov(), # https://about.codecov.io/
        Documenter{GitHubActions}(),
        PLUGIN_README,
        PLUGIN_TAGBOT,
        PLUGIN_TEST
    ],

    ) # https://www.juliabloggers.com/tips-and-tricks-to-register-your-first-julia-package/
end


# function OkPkgTemplates.user_view(::Readme, ::Template, yourpkgname::AbstractString)
#     # default_readme_var = PkgTemplates.view(PLUGIN_README,t,yourpkgname)
#     Dict(
#         "TODAY" => "today",
#     )
# end


"""
`ok_pkg_template(yourpkgname::String; destination="", julia_ver = v"1.6", username="okatsn")` is
a quick package creater that does
```julia
t = Template(;
    ...
    ]
)

t("YourPackage")
```
but with my configurations.

Template files are put under: $(DEFAULT_TEMPLATE_DIR[]), just like that of "PkgTemplates/templates".

Correspond `PkgTemplates` to this commit: https://github.com/JuliaCI/PkgTemplates.jl/commit/0de5d855e050d93169f8661a13b3a53a8cb2b283 or [v0.7.29](https://github.com/JuliaCI/PkgTemplates.jl/releases/tag/v0.7.29)
"""
function ok_pkg_template(yourpkgname::String; kwargs...)
    # # Set up Plugins


    t = template_001(;kwargs...)

    # # Set up variables
    t(yourpkgname) # create template

end
