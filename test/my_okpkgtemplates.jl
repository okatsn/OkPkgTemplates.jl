
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
end
