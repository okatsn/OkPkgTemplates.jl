@testset "mypkgtemplates.jl" begin
    finsrc = mypkgtemplate_dir() |> dirname |> readdir
    @test all(in.(["src", "Project.toml"], [finsrc])) || "`src`, `Project.toml` does not in $finsrc"

end
