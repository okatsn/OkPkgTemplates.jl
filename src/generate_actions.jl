
"""
# Create new template:

Inside OkPkgTemplates/src,
1. add concrete `struct` of `Type{<:TemplateIdentifier}`.
2. add a new templating expression (optional)
3. add a new method `get_exprs` for `XXX`

```julia
# 1
struct XXX <: TemplateIdentifier end

# 2
pkgtemplating_xxx(yourpkgname) = quote
    t = Template(;
        user=DEFAULT_USERNAME(),
        dir=DEFAULT_DESTINATION,
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

    t(\$yourpkgname)
end

# 3
get_exprs(::Type{XXX}) = [pkgtemplating_xxx, updateprojtoml_script]
```

# Use the new template

Generate: `genpkg("HelloMyPkg", XXX)`

Update: `update(XXX)`

"""
abstract type TemplateIdentifier end

"""
`genpkg(yourpkgname::String, fs...)` execute scripts `fs` one by one in user's scope using `OkPkgTemplates`'s utilities.

Please define `OkPkgTemplates.DEFAULT_**` for changing defaults.
- If `OkPkgTemplates.DEFAULT_DESTINATION` is not defined, it is defined as `Pkg.devdir()` at user's scope in the first use.


!!! tip
    In julia REPL,
    - key in `OkPkgTemplates.DEFAULT_` and [tab] to list all functions that returns default variables
    - key in `OkPkgTemplates.PLUGIN_` and [tab] to list all functions that returns `::PkgTemplates.Plugin` presets.
    - Redefine these functions in the local scope to assign the variable.


# Example
To specify output destination, redefine `DEFAULT_DESTINATION`
```julia
OkPkgTemplates.DEFAULT_DESTINATION = pwd()
```

and then generate the Package
```julia
genpkg("MyNewProject", OkReg)
```

!!! tip "Resource"
    - [PkgTemplates/Saving-Templates](https://juliaci.github.io/PkgTemplates.jl/stable/user/#Saving-Templates-1):
    - `PkgTemplates.user_view`: [Extending-Existing-Plugins](https://juliaci.github.io/PkgTemplates.jl/stable/user/#Extending-Existing-Plugins-1)

# Also see the helps
- `copymyfiles_script`
- `updateprojtoml_script`

"""
function genpkg(yourpkgname, fs...)
    exprs = [f(yourpkgname) for f in fs]
    exprs = letin.(exprs)
    return Expr(:block, exprs...)
end

"""
`genpkg(yourpkgname, tp::Type{<:TemplateIdentifier})` call `@chkdest`, and fall back to `genpkg(yourpkgname, get_exprs(tp)...)`.
"""
function genpkg(yourpkgname, tp::Type{<:TemplateIdentifier})
    @chkdest
    genpkg(yourpkgname, get_exprs(tp)...)
end

"""

"""
get_exprs(tp::Type{<:TemplateIdentifier}) = @error "Method `get_exprs` for `$tp` is undefined. It needs to be defined to return a vector of expressions."
