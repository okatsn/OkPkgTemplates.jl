
function disp_info1()
    @info """Variable for templating with respect to plugins are returned as a named tuple. For more information about templating, see
    - [Custom-Template-Files](https://juliaci.github.io/PkgTemplates.jl/stable/user/#Custom-Template-Files-1)
    """
end


function info_template_var_return(pairs::Pair{<:AbstractString, <:Dict}...)
    strs = ["# List"]
    for (nm, d) in pairs
        push!(strs, "## $nm")
        for (k,v) in d
            push!(strs, "- {{{$k}}} = $v")
        end
    end
    content = join(strs, "\n")
    Markdown.parse(content)
end
