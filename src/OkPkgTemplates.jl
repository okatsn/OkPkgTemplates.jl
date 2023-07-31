module OkPkgTemplates

# Write your package code here.
using PkgTemplates, Pkg, Dates

include("mypkgtemplates.jl")
include("myokplugins.jl")
include("mydefaults.jl")


export ok_pkg_template
export mypkgtemplate_dir
# export PLUGIN_README(), PLUGIN_TAGBOT(), PLUGIN_TEST()

using Markdown
include("informing.jl")
export info_template_var_return

include("stringscore.jl")
export stringscore

using TOML, Markdown
import Random
include("generatepkg.jl")
export @genpkg, @upactions

end
