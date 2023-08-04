

"""
`upactions(mod::Module, TI::Type{<:TemplateIdentifier})` return expressions for updating CIs, referencing the path of `mod`.

# Example
```
using MyPkgWhereCIToBeUpdated
exprs = upactions(\$MyPkgWhereCIToBeUpdated \$GeneralReg)
for ex in exprs
    @eval(OkPkgTemplates, \$ex)
end
```

!!! warning
    - Make sure all your action files (all the files in `.github/workflows`) is under the control of git for safety.

# Also see the helps
- `copymyfiles_script`
- `updateprojtoml_script`

"""
function upactions(repo1, pkgname, TI::Type{<:TemplateIdentifier})
    tempdir = joinpath(repo1, "TEMPR_$(Random.randstring(10))")
    repo0 = joinpath(tempdir, pkgname) # e.g., ./TEMPR_XXXXXX/TargetPackage
    tempdevdir = dirname(repo0)
    expr0 = quote
        this_is_temp_str_for_okpkgtemplates_restore_hahaha = OkPkgTemplates.DEFAULT_DESTINATION
        OkPkgTemplates.DEFAULT_DESTINATION = $tempdevdir
    end
    expr999 = quote
        OkPkgTemplates.DEFAULT_DESTINATION = this_is_temp_str_for_okpkgtemplates_restore_hahaha
    end

    @info "Update CI actions in $repo1; temporary working directory is $(tempdir); targeting package $pkgname"

    genfns = [f(pkgname) for f in get_exprs(TI)] # The scripts that genpkg did.
    hello = (repo0=repo0, repo1=repo1)
    script_copy_paste = copymyfiles_script(hello)
    script_upprojtoml = updateprojtoml_script(pkgname) # Modify Project.toml by add [extras] and [targets] for the scope of Test.
    script_rm = quote
        rm($tempdir, recursive=true)
    end
    exprs = letin.([expr0, genfns..., script_copy_paste, script_rm, script_upprojtoml, expr999])
    return Expr(:block, exprs...)
end

function upactions(mod::Module, TI)
    repo1 = pathof(mod) |> dirname |> dirname
    # /home/jovyan/.julia/dev/OkPkgTemplates/(src/OkPkgTemplates.jl)"
    #                                  repo1^
    pkgname = string(mod)

    upactions(repo1, pkgname, TI)
end


"""
`upactions` return expressions for updating CIs using `upactions` referencing the path of the current activated project environment.
"""
function upactions(TI::Type{<:TemplateIdentifier})
    pkgenv = Pkg.Types.Context().env
    project_file_path = pkgenv.project_file
    repo1 = dirname(project_file_path)
    upactions(repo1, pkgenv.pkg.name, TI) # Currently activated environment
end
