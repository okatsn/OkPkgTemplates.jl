@testset "mypkgtempaltes.jl" begin
    using Revise, OkPkgTemplates
    finsrc = mypkgtemplate_dir() |> dirname |> readdir
    @test all(in.(["src","Project.toml"], [finsrc]))
end
