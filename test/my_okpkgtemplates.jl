using TOML

@testset "my_okpkgtempaltes.jl" begin
    my_okpkgtemplate_dir = OkPkgTemplates.my_okpkgtemplate_dir
    @test isfile(my_okpkgtemplate_dir("github", "workflows", "TagBot.yml"))
    @test isfile(my_okpkgtemplate_dir("test", "runtests.jl"))
    @test isfile(my_okpkgtemplate_dir("README.md"))
    @test isfile(my_okpkgtemplate_dir("github", "workflows", "CI.yml"))

    if haskey(ENV, "JULIA_PKG_DEVDIR")
        @test OkPkgTemplates.chkdest() == ENV["JULIA_PKG_DEVDIR"]
    end

    @test OkPkgTemplates.chkdest() == Pkg.devdir()


    # # Test @genpkg
    OkPkgTemplates.DEFAULT_DESTINATION() = pwd()
    pkgname2build = "HelloWorldX12349981"
    dir_targetfolder(args...) = joinpath(OkPkgTemplates.DEFAULT_DESTINATION(), pkgname2build, args...)

    @info "Trying to generate package at: $(dir_targetfolder())"

    # generate package
    @eval @genpkg $pkgname2build
    # test if file/dir exists
    @test isdir(dir_targetfolder())
    @test isfile(dir_targetfolder("Project.toml"))
    # test for package name
    project_toml = TOML.parsefile(dir_targetfolder("Project.toml"))
    @test project_toml["name"] == pkgname2build

    # remove the package
    rm(pkgname2build, recursive=true)
    @test !isdir(dir_targetfolder())
end
