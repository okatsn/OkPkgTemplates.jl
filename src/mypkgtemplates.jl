



# # See PkgTemplates/src/plugin.jl
const DEFAULT_TEMPLATE_DIR = Ref{String}(joinpath(dirname(dirname(pathof(OkPkgTemplates))), "mypkgtemplates")) # KEYNOTE: Check the package name and folder name if moved to other package
"""
Return a path relative to the default template file directory
(`Shorthands/mypkgtemplates`).
"""
mypkgtemplate_dir(paths::AbstractString...) = joinpath(DEFAULT_TEMPLATE_DIR[], paths...)

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
function ok_pkg_template(yourpkgname::String; destination="", julia_ver = v"1.6", username="okatsn")
    if isempty(destination)
        destination = Pkg.devdir()
    end

    # # Set up Plugins
    # Readme
    # - see also PkgTemplates/src/plugins/readme.jl
    rdme = PkgTemplates.Readme(; file=mypkgtemplate_dir("README.md"), destination="README.md")

    # TagBot
    # - see PkgTemplates/src/plugins/tagbot.jl
    # - `changelog` is modified from [default changelog template](https://github.com/JuliaRegistries/TagBot/blob/master/action.yml) with extra `${{github.event.head_commit.message}}` (for get the commit message).
    # - If your registry is public, this is all you need to do. For more information, see [here](https://github.com/JuliaRegistries/TagBot#custom-registries)
    tgbt = TagBot(;registry="okatsn/OkRegistry",
            changelog = """
            ## {{ package }} {{ version }}
            \${{github.event.head_commit.message}}
            {% if previous_release %}
            [Diff since {{ previous_release }}]({{ compare_url }})
            {% endif %}
            {% if custom %}
            {{ custom }}
            {% endif %}
            {% if issues %}
            **Closed issues:**
            {% for issue in issues %}
            - {{ issue.title }} (#{{ issue.number }})
            {% endfor %}
            {% endif %}
            {% if pulls %}
            **Merged pull requests:**
            {% for pull in pulls %}
            - {{ pull.title }} (#{{ pull.number }}) (@{{ pull.author.username }})
            {% endfor %}
            {% endif %}
            """,
            file = mypkgtemplate_dir("github", "workflows", "TagBot.yml"))

    # Test
    tst = Tests(; file=mypkgtemplate_dir("test","runtests.jl")) # see PkgTemplates/src/plugins/tests.jl

    t = Template(;
    user=username,
    dir=destination,
    julia=julia_ver,
    plugins=[
        Git(; manifest=false),
        GitHubActions(;file = mypkgtemplate_dir("github", "workflows", "CI.yml")), # see PkgTemplates/src/plugins/ci.jl
        Codecov(), # https://about.codecov.io/
        Documenter{GitHubActions}(),
        rdme,
        tgbt,
        tst
    ],

    ) # https://www.juliabloggers.com/tips-and-tricks-to-register-your-first-julia-package/


    t(yourpkgname) # create template

end
