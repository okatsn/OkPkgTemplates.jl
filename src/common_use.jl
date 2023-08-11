"""
After making the template successfully,
add `"Documenter", "CompatHelperLocal"` to `[extras]` and `[targets]` as `runtests.jl` (may) use them.

`updateprojtoml_script(yourpkgname)` *creates expressions* in which
`projtoml_path = joinpath(OkPkgTemplates.DEFAULT_DESTINATION(), yourpkgname, "Project.toml")`.

It modify `Project.toml` by add [extras] and [targets] for the scope of Test.
"""
updateprojtoml_script(pkgfoldername) = quote
    @info "I'm updateprojtoml_script. OkPkgTemplates.DEFAULT_DESTINATION(): $(OkPkgTemplates.DEFAULT_DESTINATION())"

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

    projtoml_path = joinpath(DEFAULT_DESTINATION(), $pkgfoldername, "Project.toml")
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

    changelog_file = joinpath(DEFAULT_DESTINATION(), $pkgfoldername, "changelog.md")
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
function copymyfiles_script(hello)
    return quote
        @info "I'm copymyfiles_script"
        srcs = String[]
        dsts = String[]

        repo0 = $(hello.repo0)
        repo1 = $(hello.repo1)
        # Github actions
        srcdir_gitact = joinpath(repo0, ".github", "workflows")
        githubfiles = readdir(srcdir_gitact) # todo: consider use OkFiles to use regular expression to copy only the yml

        dstdir_gitact = joinpath(repo1, ".github", "workflows")

        push!(srcs, joinpath.(srcdir_gitact, githubfiles)...)
        push!(dsts, joinpath.(dstdir_gitact, githubfiles)...)

        # Test files
        testfiles = ["runtests.jl"]
        push!(srcs, joinpath.(repo0, "test", testfiles)...)
        push!(dsts, joinpath.(repo1, "test", testfiles)...)
        cp.(srcs, dsts; force=true)

        try
            changelog_file = joinpath(repo0, "changelog.md")
            changelog_dest = joinpath(repo1, "changelog.md")
            cp(changelog_file, changelog_dest; force=false)
        catch
            @info "changelog.md not availabe or already exists."
        end
    end
end
# KEYNOTE: ./test/Project.toml is not created since in general case you will also require dependencies in ./Project.toml
# See https://pkgdocs.julialang.org/v1/creating-packages/#Test-specific-dependencies-in-Julia-1.2-and-above


function letin(expr)
    quote
        let
            $expr
        end
    end
end

# function safejoin(exprs...)
#     let0 = quote
#         let
#         end
#     let = quote
#     end
#             end
#     safeexpr = [Expr(:block,

#     )]

# end
