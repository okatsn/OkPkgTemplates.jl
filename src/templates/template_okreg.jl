"""
`pkgtemplating_okreg(dest, yourpkgname)` returns the script of `PkgTemplates` (`quote ... end`) to be executed at the scope that the macro is called.

It
- creates a package using `PkgTemplates.Templates`
- `add Documenter, CompatHelperLocal, Test` into `Project.toml`
"""
pkgtemplating_okreg(dest, yourpkgname) = quote
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
            PLUGIN_README(),
            PLUGIN_TAGBOT(),
            PLUGIN_TEST(),
            PLUGIN_REGISTER()
        ]
    )
    default_readme_var = PkgTemplates.view(PLUGIN_README(), t, $yourpkgname)
    merge!(default_readme_var, Dict(
        "TODAY" => today()
    ))
    function PkgTemplates.user_view(::Readme, ::Template, ::AbstractString)
        return default_readme_var
    end

    reg_var = Dict("PKG" => $yourpkgname)
    function PkgTemplates.user_view(::RegisterAction, ::Template, ::AbstractString)
        return reg_var
    end

    t($yourpkgname)



    disp_info1()
    info_template_var_return(
        "PLUGIN_README" => default_readme_var,
        "PLUGIN_REGISTER" => reg_var)

end

struct OkReg <: TemplateIdentifier end
get_exprs(::Type{OkReg}) = [pkgtemplating_okreg, updateprojtoml_script]
