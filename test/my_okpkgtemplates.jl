using TOML, Pkg
using InteractiveUtils # I don't know why this is required for subtypes to be able to used

@testset "my_okpkgtempaltes.jl" begin
    my_okpkgtemplate_dir = OkPkgTemplates.my_okpkgtemplate_dir
    @test isfile(my_okpkgtemplate_dir("github", "workflows", "TagBot.yml"))
    @test isfile(my_okpkgtemplate_dir("test", "runtests.jl"))
    @test isfile(my_okpkgtemplate_dir("README.md"))
    @test isfile(my_okpkgtemplate_dir("github", "workflows", "CI.yml"))

    if haskey(ENV, "JULIA_PKG_DEVDIR")
        @test OkPkgTemplates.@chkdest() == ENV["JULIA_PKG_DEVDIR"]
    end

    @test OkPkgTemplates.@chkdest() == Pkg.devdir()


    # # Test genpkg
    dir_test_proj_env = pwd()
    OkPkgTemplates.DEFAULT_DESTINATION = dir_test_proj_env
    pkgname2build = "HelloWorldX12349981"
    dir_targetfolder(args...) = joinpath(OkPkgTemplates.DEFAULT_DESTINATION, pkgname2build, args...) # noted that in `genpkg` pkgname2build is joinpathed with DEFAULT_DESTINATION.

    @info "Trying to generate package at: $(dir_targetfolder())"

    for TID in subtypes(OkPkgTemplates.TemplateIdentifier)
        # generate package
        OkPkgTemplates.generate(pkgname2build, TID)
        # test if file/dir exists
        @test isdir(dir_targetfolder())
        @test isfile(dir_targetfolder("Project.toml"))
        # test for package name
        project_toml = TOML.parsefile(dir_targetfolder("Project.toml"))
        @test project_toml["name"] == pkgname2build

        # Pkg.develop(path=dir_targetfolder())
        # symb_targetpkg = Symbol(pkgname2build)
        # eval(Expr(:using, symb_targetpkg))

        # expr_using = quote
        #     using $(symb_targetpkg)
        # end
        # @eval $expr_using


        exprs = OkPkgTemplates.upactions(dir_targetfolder(), pkgname2build, TID)
        for ex in exprs
            @eval(OkPkgTemplates, $ex)
        end
        # ex must be evaluated under the scope of OkPkgTemplates; otherwise, error will occur since the current scope might not have pakage required in `ex`.

        @test haskey(project_toml["extras"], "CompatHelperLocal") # make sure update_project_toml! works properly.


        # remove the package
        rm(dir_targetfolder(), recursive=true)
        @test !isdir(dir_targetfolder())
    end
end
