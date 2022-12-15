module OkPkgTemplates

# Write your package code here.
using PkgTemplates, Pkg, Dates
include("myplugins.jl")
include("mypkgtemplates.jl")
include("mydefaults.jl")


export ok_pkg_template
export mypkgtemplate_dir
# export PLUGIN_README(), PLUGIN_TAGBOT(), PLUGIN_TEST()

using Markdown
include("informing.jl")
export info_template_var_return

include("generatepkg.jl")
export @genpkg

end
