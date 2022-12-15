"""
`genpkg(yourpkgname::String)` generate your package using presets.


If `OkPkgTemplates.DEFAULT_DESTINATION()` returns an empty string, it use `Pkg.devdir()` at user's scope.


In julia REPL,
- key in `OkPkgTemplates.DEFAULT_` and [tab] to list all functions that returns default variables
- key in `OkPkgTemplates.PLUGIN_` and [tab] to list all functions that returns `::PkgTemplates.Plugin` presets.

Redefine these functions in the local scope to assign the variable.

# Example
To specify output destination, redefine `DEFAULT_DESTINATION()`
```julia
OkPkgTemplates.DEFAULT_DESTINATION() = pwd()
```

and then generate the Package
```julia
@genpkg "MyNewProject"
```

!!! note
    - Feel free to redefine `OkPkgTemplates.DEFAULT_...`

!!! warning
    In the following cases, write a new macro of your own referencing `@genpkg` instead, or just use `PkgTemplates` [as instructed](https://juliaci.github.io/PkgTemplates.jl/stable/user/#Saving-Templates-1):
    - If you have the thought to redefine `OkPkgTemplates.PLUGIN_...`
    - If you want to set `PkgTemplates.user_view` [(for example)](https://juliaci.github.io/PkgTemplates.jl/stable/user/#Extending-Existing-Plugins-1)

"""
macro genpkg(yourpkgname::String)
    dest = chkdest()
    @info "Targeting: $dest"
    return quote
        @assert $dest == chkdest()
        t = Template(;
        user=DEFAULT_USERNAME(),
        dir=chkdest(),
        julia=DEFAULT_JULIAVER(),
        plugins=[
            Git(; manifest=false),
            CompatHelper(),
            PLUGIN_GITHUBACTION(),
            Codecov(), # https://about.codecov.io/
            Documenter{GitHubActions}(),
            PLUGIN_README(),
            PLUGIN_TAGBOT(),
            PLUGIN_TEST(),
            PLUGIN_REGISTER()
        ],
        )
        default_readme_var = PkgTemplates.view(PLUGIN_README(),t,$yourpkgname)
        merge!(default_readme_var, Dict(
            "TODAY" => today()
        ))
        function PkgTemplates.user_view(::Readme, ::Template, ::AbstractString)
            return default_readme_var
        end

        reg_var = Dict("PKG" => $yourpkgname)
        function PkgTemplates.user_view(::RegisterAction,::Template, ::AbstractString)
            return reg_var
        end

        t($yourpkgname)

        disp_info1()
        info_template_var_return(
            "PLUGIN_README" => default_readme_var,
            "PLUGIN_REGISTER" => reg_var)

    end
end
