



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
    ifelse(
        isempty(DEFAULT_DESTINATION()),
            Pkg.devdir(),
            DEFAULT_DESTINATION())
end
