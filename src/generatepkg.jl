
macro gen_pkg(yourpkgname::String)

    return quote
        t = OkPkgTemplates.template_001()
        function PkgTemplates.user_view(::Readme, ::Template, ::AbstractString)
            Dict(
                "TODAY" => "today",
                "PKG" => "NOTHELLOWORLD"
            )
        end
        t($yourpkgname)
    end
end


#         default_readme_var = PkgTemplates.view(PLUGIN_README,t,yourpkgname)
