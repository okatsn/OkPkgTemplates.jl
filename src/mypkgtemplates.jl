



# # See PkgTemplates/src/plugin.jl
const DEFAULT_TEMPLATE_DIR = Ref{String}(joinpath(dirname(dirname(pathof(OkPkgTemplates))), "mypkgtemplates")) # KEYNOTE: Check the package name and folder name if moved to other package
"""
Return a path relative to the default template file directory
(`OkPkgTemplates/mypkgtemplates`).
"""
mypkgtemplate_dir(paths::AbstractString...) = joinpath(DEFAULT_TEMPLATE_DIR[], paths...)

"""
`chkdest()` return `Pkg.devdir()` if `DEFAULT_DESTINATION()` is empty.
"""
function chkdest()
    dest = ifelse(
        isempty(DEFAULT_DESTINATION()),
        Pkg.devdir(),
        DEFAULT_DESTINATION())

    # CHECKPOINT: make `chkdest` a `macro` in which `OkPkgTemplates.DEFAULT_DESTINATION() = dest`
    # - This is the only utility that needs macro.
    # - `Pkg.Types.Context().env` and `pathof(mod)` seems to work fine in both function and macro. See `whereami`
    # CHECKPOINT: after new release of OkPkgTemplates, use it to
    # - Register OkFiles.jl at General registry. Currently it failed [here](https://github.com/okatsn/OkFiles.jl/commit/f45b03c7eb009f6fb8168f3de8e8d735457e02a9#commitcomment-123241444).
    # - Register SmallDatasetMaker.jl at General registry. It depend on OkFiles, and currently it failed [here](https://github.com/okatsn/SmallDatasetMaker.jl/commit/37eb24f3f812d666010d384fc411ef49dd31650f#commitcomment-123241202).
    # - Registrator App is added to both OkFiles and SmallDatasetMaker
    # !!! tip
    #     After consideration, I decide to use https://github.com/JuliaRegistries/Registrator.jl,
    #     since it also allows collaborator to register a new version by commenting on a commit.
    #     Providing by `PkgTemplates.jl`, the register.yaml does no harm, and TagBot by default
    #     can be triggered by comment.


end
