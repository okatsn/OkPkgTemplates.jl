using Pkg
@testset "mypkgtempaltes.jl" begin
    finsrc = mypkgtemplate_dir() |> dirname |> readdir
    @test all(in.(["src","Project.toml"], [finsrc]))
    @test isfile(mypkgtemplate_dir("github", "workflows", "TagBot.yml"))
    @test isfile(mypkgtemplate_dir("test","runtests.jl"))
    @test isfile(mypkgtemplate_dir("README.md"))
    @test isfile(mypkgtemplate_dir("github", "workflows", "CI.yml"))

    if haskey(ENV, "JULIA_PKG_DEVDIR")
        @test OkPkgTemplates.chkdest() == ENV["JULIA_PKG_DEVDIR"]
    end

    @test OkPkgTemplates.chkdest() == Pkg.devdir()
end
