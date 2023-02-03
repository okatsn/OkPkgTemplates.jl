"""
`pkgtemplating_script(dest, yourpkgname)` returns the script of `PkgTemplates` (`quote ... end`) to be executed at the scope that the macro is called.

It
- creates a package using `PkgTemplates.Templates`
- `add Documenter, CompatHelperLocal, Test` into `Project.toml`
"""
pkgtemplating_script(dest, yourpkgname) = quote
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

    using Pkg;
    Pkg.activate(joinpath($dest, $yourpkgname));
    Pkg.add(["Documenter", "CompatHelperLocal", "Test"])

    disp_info1()
    info_template_var_return(
        "PLUGIN_README" => default_readme_var,
        "PLUGIN_REGISTER" => reg_var)

end

"""
Copy some files from `repo0` to `repo1`.
List of files:
- All files under `.github/workflows`
-
"""
copymyfiles_script(repo0, repo1) = quote
    srcs = String[];
    dsts = String[];

    # Github actions
    srcdir_gitact = joinpath($repo0, ".github", "workflows")
    githubfiles = readdir(srcdir_gitact); # todo: consider use OkFiles to use regular expression to copy only the yml

    dstdir_gitact = joinpath($repo1, ".github", "workflows")

    push!(srcs, joinpath.(srcdir_gitact, githubfiles)...);
    push!(dsts, joinpath.(dstdir_gitact, githubfiles)...);

    # Test files
    testfiles = ["runtests.jl"];
    push!(srcs, joinpath.($repo0, "test", testfiles)...);
    push!(dsts, joinpath.($repo1, "test", testfiles)...);
    cp.(srcs, dsts; force=true)
end
# KEYNOTE: ./test/Project.toml is not created since in general case you will also require dependencies in ./Project.toml

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
    @info "Targeting: $(joinpath(dest, yourpkgname))"
    script_to_exe = pkgtemplating_script(dest, yourpkgname)
    return quote
        $script_to_exe;
    end
end

"""
Replace Github Actions (all the files in `.github/workflows`) with the latest version that generated from `OkPkgTemplates`. Noted that julia enviroment should be activated in the current directory for your package in dev to update.

!!! warning
    - Make sure all your action files (all the files in `.github/workflows`) is under the control of git for safety.
"""
macro upactions()
    pwd1 = ENV["PWD"]
    tempdir = joinpath(pwd1, "TEMPR_$(Random.randstring(10))")
    pkgname = Pkg.Types.Context().env.pkg.name
    @info "Update CI actions in $pwd1; temporary working directory is $(tempdir)"
    script_to_exe = pkgtemplating_script(tempdir, pkgname)
    repo0 = joinpath(tempdir, pkgname)
    repo1 = pwd1
    script_to_exe_2 = copymyfiles_script(repo0, repo1)
    return quote
        $script_to_exe;
        $script_to_exe_2;
        rm($tempdir, recursive=true)
    end
end
