
macro gen_pkg(yourpkgname::String)

    return quote
        t = OkPkgTemplates.template_001()
        function PkgTemplates.user_view(::Readme, ::Template, ::AbstractString)
            default_readme_var = PkgTemplates.view(PLUGIN_README,t,$yourpkgname)
            merge!(default_readme_var, Dict(
                "TODAY" => today(),
                "PKG" => "NOTHELLOWORLD"
            ))
            return default_readme_var
        end

        t($yourpkgname)
    end
end
