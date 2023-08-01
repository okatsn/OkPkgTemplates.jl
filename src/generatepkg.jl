"""
`upactions(pwd1::String, pkgname::String, TI::Type{<:TemplateIdentifier})` return expression for
replacing Github Actions (all the files in `.github/workflows`) with the latest version that generated from `OkPkgTemplates`.

# Example
```@example
exprs = OkPkgTemplates.upactions(dir_targetfolder(), pkgname2build)
for ex in exprs
    @eval(OkPkgTemplates, \$ex)
    # expression must be evaluated under the scope of OkPkgTemplates; otherwise, error will occur since the current scope might not have pakage required in `ex`.
end
```

!!! warning
    - Make sure all your action files (all the files in `.github/workflows`) is under the control of git for safety.

# Also see the helps
- `copymyfiles_script`
- `updateprojtoml_script`
"""
function upactions(pwd1::String, pkgname::String, TI::Type{<:TemplateIdentifier}) #
    tempdir = joinpath(pwd1, "TEMPR_$(Random.randstring(10))")
    @info "Update CI actions in $pwd1; temporary working directory is $(tempdir); targeting package $pkgname"

    genfns = [f(tempdir, pkgname) for f in get_exprs(TI)] # The scripts that @genpkg did.

    repo0 = joinpath(tempdir, pkgname)
    repo1 = pwd1
    script_copy_paste = copymyfiles_script(repo0, repo1)
    script_upprojtoml = updateprojtoml_script(repo1, "") # Modify Project.toml by add [extras] and [targets] for the scope of Test.
    script_rm = quote
        rm($tempdir, recursive=true)
    end
    return [genfns..., script_copy_paste, script_rm, script_upprojtoml]

end


"""
`upactions(mod::Module, TI::Type{<:TemplateIdentifier})` return expressions for updating CIs, referencing the path of `mod`. See `upactions`.

# Example
```@example
using MyPkgWhereCIToBeUpdated
exprs = upactions(\$MyPkgWhereCIToBeUpdated \$GeneralReg)
for ex in exprs
    @eval(OkPkgTemplates, \$ex)
end
```
"""
function upactions(mod::Module, TI::Type{<:TemplateIdentifier})
    pwd1 = pathof(mod) |> dirname |> dirname
    pkgname = string(mod)
    ex = upactions(pwd1, pkgname, TI)
    return ex
end



"""
`upactions` return expressions for updating CIs using `upactions` referencing the path of the current activated project environment.
"""
function upactions(TI::Type{<:TemplateIdentifier})
    pkgenv = Pkg.Types.Context().env
    project_file_path = pkgenv.project_file
    pwd1 = dirname(project_file_path)
    ex = upactions(pwd1, pkgenv.pkg.name, TI) # Currently activated environment
    return ex
end
