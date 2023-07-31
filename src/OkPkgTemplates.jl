module OkPkgTemplates

# Write your package code here.
using PkgTemplates, Pkg, Dates
include("sayhello.jl")
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
# template_**.jl uses **plugins.jl
include("templates/template_okreg.jl")
include("templates/template_gereg.jl")
include("generatepkg.jl") # @genpkg uses templates/**
export @genpkg, @upactions

end
