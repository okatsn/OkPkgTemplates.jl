



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


end
