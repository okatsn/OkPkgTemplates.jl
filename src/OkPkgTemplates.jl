module OkPkgTemplates
# Test
include("docs_src_sayhello_md_related/sayhello.jl")
include("docs_src_sayhello_md_related/whereami.jl")


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
# general genpkg function
include("generate_actions.jl")
# template_**.jl uses **plugins.jl
include("templates/template_okreg.jl")
include("templates/template_gereg.jl")
include("update_actions.jl")
export genpkg, @upactions, OkReg, GeneralReg

include("interface.jl")
export update, generate

end
