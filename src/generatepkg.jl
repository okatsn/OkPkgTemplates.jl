"""
`upactions(pwd1::String, pkgname::String)` return expression for
replacing Github Actions (all the files in `.github/workflows`) with the latest version that generated from `OkPkgTemplates`.

This function is separated for test purpose. For user, please use `@upactions`.

# Example
```julia
ex = OkPkgTemplates.upactions(dir_targetfolder(), pkgname2build)
@eval(OkPkgTemplates, \$ex) # expression must be evaluated under the scope of OkPkgTemplates; otherwise, error will occur since the current scope might not have pakage required in `ex`.
```

!!! warning
    - Make sure all your action files (all the files in `.github/workflows`) is under the control of git for safety.

# Also see the helps
- `copymyfiles_script`
- `updateprojtoml_script`
"""
function upactions(pwd1::String, pkgname::String)
    tempdir = joinpath(pwd1, "TEMPR_$(Random.randstring(10))")
    @info "Update CI actions in $pwd1; temporary working directory is $(tempdir); targeting package $pkgname"
    script_to_exe = pkgtemplating_okreg(tempdir, pkgname) # at tempdir, make package pkgname.
    repo0 = joinpath(tempdir, pkgname)
    repo1 = pwd1
    script_copy_paste = copymyfiles_script(repo0, repo1)
    script_upprojtoml = updateprojtoml_script(repo1, "") # Modify Project.toml by add [extras] and [targets] for the scope of Test.
    return quote
        $script_to_exe
        $script_copy_paste
        rm($tempdir, recursive=true)
        $script_upprojtoml
    end
end


"""
`@upactions(mod::Module)` update CIs using `upactions` referencing the path of `mod`. See `upactions`.

# Example
```julia
using MyPkgWhereCIToBeUpdated
@upactions MyPkgWhereCIToBeUpdated
```
"""
macro upactions(mod::Module)
    pwd1 = pathof(mod) |> dirname |> dirname
    pkgname = string(mod)
    ex = upactions(pwd1, pkgname)
    return ex
end



"""
`@upactions` update CIs using `upactions` referencing the path of the current activated project environment. See `upactions`.


# Example
```julia
@upactions
```
"""
macro upactions()
    pkgenv = Pkg.Types.Context().env
    project_file_path = pkgenv.project_file
    pwd1 = dirname(project_file_path)
    ex = upactions(pwd1, pkgenv.pkg.name) # Currently activated environment
    return ex
end
