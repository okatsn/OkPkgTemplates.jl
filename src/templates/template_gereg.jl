"""
`pkgtemplating_gereg(dest, yourpkgname)` returns the script of `PkgTemplates` (`quote ... end`) for general registry.
"""
pkgtemplating_gereg(dest, yourpkgname) = quote
    t = Template(;
        user=DEFAULT_USERNAME(),
        dir=$dest,
        julia=DEFAULT_JULIAVER(),
        plugins=[
            Git(; manifest=false),
            PLUGIN_COMPATHELPER(),
            PLUGIN_GITHUBACTION(),
            Codecov(), # https://about.codecov.io/
            Documenter{GitHubActions}(),
            PkgTemplates.Readme(),
            PkgTemplates.TagBot(; changelog=tagbot_changelog()),
            PLUGIN_TEST(),
            RegisterAction()
        ]
    )

    t($yourpkgname)
end


struct GeneralReg <: TemplateIdentifier end

macro genpkg(yourpkgname::String, ::Type{GeneralReg})
    dest = chkdest()
    return genpkg(dest, yourpkgname, pkgtemplating_gereg, updateprojtoml_script)
end
