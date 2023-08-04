
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
pkgtemplating_xxx(dest, yourpkgname) = quote
    t = Template(;
        user=DEFAULT_USERNAME(),
        dir=\$dest,
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
function genpkg(dest, yourpkgname, fs...)
    @info "Targeting: $(joinpath(dest, yourpkgname))."
    exprs = [f(dest, yourpkgname) for f in fs]
    return Expr(:block, exprs...)
end

"""
`genpkg(yourpkgname, tp::Type{<:TemplateIdentifier})` call `@chkdest`, obtain `dest = OkPkgTemplates.DEFAULT_DESTINATION` and fall back to `genpkg(dest, yourpkgname, get_exprs(tp)...)`.
"""
function genpkg(yourpkgname, tp::Type{<:TemplateIdentifier})
    @chkdest
    dest = OkPkgTemplates.DEFAULT_DESTINATION
    genpkg(dest, yourpkgname, get_exprs(tp)...)
end

"""

"""
get_exprs(tp::Type{<:TemplateIdentifier}) = @error "Method `get_exprs` for `$tp` is undefined. It needs to be defined to return a vector of expressions."


"""
After making the template successfully,
add `"Documenter", "CompatHelperLocal"` to `[extras]` and `[targets]` as `runtests.jl` (may) use them.

`updateprojtoml_script(dest, yourpkgname)` creates script that
`projtoml_path = joinpath(dest, yourpkgname, "Project.toml")` will be modified on execution.

It modify `Project.toml` by add [extras] and [targets] for the scope of Test.
"""
updateprojtoml_script(dest, yourpkgname) = quote

    function ordering(str)
        d = Dict(
            "name" => 1,
            "uuid" => 2,
            "authors" => 3,
            "version" => 4,
            "deps" => 5,
            "compat" => 6,
            "extras" => 99,
            "targets" => 100, # largest the last
        ) # the order for default look of Project.toml
        master_order = get(d, str, 999) # for others, put them to the last
        final_order = master_order + stringscore(str)
    end



    function pair_String_Any(entries)
        [string(k) => v for (k, v) in pairs(entries)]
    end


    function update_project_toml!(d)
        extraentries = pair_String_Any((
            Documenter="e30172f5-a6a5-5a46-863b-614d45cd2de4",
            Test="8dfed614-e22c-5e08-85e1-65c5234f0b40",
            CompatHelperLocal="5224ae11-6099-4aaa-941d-3aab004bd678"
        )) # SETME: set your extra packages for env. of Test here.

        targetentries = ["Test", "Documenter", "CompatHelperLocal"]
        target_test = d["targets"]["test"]

        push!(d["extras"], extraentries...)
        push!(target_test, targetentries...)
        unique!(target_test)
        return d
    end

    projtoml_path = joinpath($dest, $yourpkgname, "Project.toml")
    d = TOML.parsefile(projtoml_path)
    update_project_toml!(d)

    open(projtoml_path, "w") do io
        TOML.print(io, d; sorted=true, by=ordering)
    end

    cglog = md"""
    # Changelog
    ## v0.1.0
    - Initiating the project.
    """

    changelog_file = joinpath($dest, $yourpkgname, "changelog.md")
    if !isfile(changelog_file)
        open(changelog_file, "w") do io
            write(io, string(cglog))
        end
    end

    @info " $projtoml_path is updated."

end
# It is useless to do the followings in script:
# using Pkg;
# Pkg.activate(joinpath($dest, $yourpkgname));
# Pkg.add(["Documenter", "CompatHelperLocal", "Test"])

"""
Copy some files from `repo0` to `repo1`.
List of files:
- All files under `.github/workflows`
-
"""
copymyfiles_script(repo0, repo1) = quote
    srcs = String[]
    dsts = String[]

    # Github actions
    srcdir_gitact = joinpath($repo0, ".github", "workflows")
    githubfiles = readdir(srcdir_gitact) # todo: consider use OkFiles to use regular expression to copy only the yml

    dstdir_gitact = joinpath($repo1, ".github", "workflows")

    push!(srcs, joinpath.(srcdir_gitact, githubfiles)...)
    push!(dsts, joinpath.(dstdir_gitact, githubfiles)...)

    # Test files
    testfiles = ["runtests.jl"]
    push!(srcs, joinpath.($repo0, "test", testfiles)...)
    push!(dsts, joinpath.($repo1, "test", testfiles)...)
    cp.(srcs, dsts; force=true)

    try
        changelog_file = joinpath($repo0, "changelog.md")
        changelog_dest = joinpath($repo1, "changelog.md")
        cp(changelog_file, changelog_dest; force=false)
    catch
        @info "changelog.md not availabe or already exists."
    end
end
# KEYNOTE: ./test/Project.toml is not created since in general case you will also require dependencies in ./Project.toml
# See https://pkgdocs.julialang.org/v1/creating-packages/#Test-specific-dependencies-in-Julia-1.2-and-above
