
macro gen_pkg(yourpkgname::String)

    return quote
        t = OkPkgTemplates.template_001()
        default_readme_var = PkgTemplates.view(PLUGIN_README(),t,$yourpkgname)
        merge!(default_readme_var, Dict(
            "TODAY" => today()
        ))
        function PkgTemplates.user_view(::Readme, ::Template, ::AbstractString)
            return default_readme_var
        end

        t($yourpkgname)

        disp_info1()
        info_template_var_return(
            "PLUGIN_README" => default_readme_var,)

    end
end
