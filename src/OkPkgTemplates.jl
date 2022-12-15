module OkPkgTemplates

# Write your package code here.
using PkgTemplates, Pkg, Dates
include("myplugins.jl")
include("mypkgtemplates.jl")

export ok_pkg_template
export mypkgtemplate_dir
# export PLUGIN_README, PLUGIN_TAGBOT, PLUGIN_TEST
end
