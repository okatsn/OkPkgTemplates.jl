"""
`pkgtemplating_gereg(yourpkgname)` returns the script of `PkgTemplates` (`quote ... end`) for general registry.
"""
pkgtemplating_gereg(yourpkgname) = quote
    t = Template(;
        user=DEFAULT_USERNAME(),
        dir=DEFAULT_DESTINATION(),
        julia=DEFAULT_JULIAVER(),
        plugins=[
            Git(; manifest=false),
            PLUGIN_COMPATHELPER(),
            PLUGIN_GITHUBACTION(),
            Codecov(), # https://about.codecov.io/
            PkgTemplates.Readme(),
            PkgTemplates.TagBot(; changelog=tagbot_changelog()),
            PLUGIN_TEST(),
            PLUGIN_DOCUMENTER(),
            RegisterAction()
        ]
    )

    t($yourpkgname)
end


struct GeneralReg <: TemplateIdentifier end
get_exprs(::Type{GeneralReg}) = [pkgtemplating_gereg, updateprojtoml_script]
