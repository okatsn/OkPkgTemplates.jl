var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = OkPkgTemplates","category":"page"},{"location":"#OkPkgTemplates","page":"Home","title":"OkPkgTemplates","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for OkPkgTemplates.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [OkPkgTemplates]","category":"page"},{"location":"#OkPkgTemplates.chkdest-Tuple{}","page":"Home","title":"OkPkgTemplates.chkdest","text":"chkdest() return Pkg.devdir() if DEFAULT_DESTINATION() is empty.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.copymyfiles_script-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.copymyfiles_script","text":"Copy some files from repo0 to repo1. List of files:\n\nAll files under .github/workflows\n\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.mypkgtemplate_dir-Tuple{Vararg{AbstractString}}","page":"Home","title":"OkPkgTemplates.mypkgtemplate_dir","text":"Return a path relative to the default template file directory (OkPkgTemplates/mypkgtemplates).\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.pkgtemplating_script-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.pkgtemplating_script","text":"pkgtemplating_script(dest, yourpkgname) returns the script of PkgTemplates (quote ... end) to be executed at the scope that the macro is called.\n\nIt\n\ncreates a package using PkgTemplates.Templates\nadd Documenter, CompatHelperLocal, Test into Project.toml\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.stringscore-Tuple{Any}","page":"Home","title":"OkPkgTemplates.stringscore","text":"stringscore(str) gives an absolute score for a string; the order of score from large to small corresponds to the alphabetical order. For a string less than 100 characters, the score should not exceeds one.\n\nExample\n\njulia> stringscore.([\"AAA\", \"Aa\", \"BCD\"])\n3-element Vector{Float64}:\n 0.0656565\n 0.06597\n 0.06667680000000001\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.updateprojtoml_script-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.updateprojtoml_script","text":"After making the template successfully, add \"Documenter\", \"CompatHelperLocal\" to [extras] and [targets] as runtests.jl (may) use them.\n\nupdateprojtoml_script(dest, yourpkgname) creates script that projtoml_path = joinpath(dest, yourpkgname, \"Project.toml\") will be modified on execution.\n\nIt modify Project.toml by add [extras] and [targets] for the scope of Test.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.@genpkg-Tuple{String}","page":"Home","title":"OkPkgTemplates.@genpkg","text":"genpkg(yourpkgname::String) generate your package using presets.\n\nIf OkPkgTemplates.DEFAULT_DESTINATION() returns an empty string, it use Pkg.devdir() at user's scope.\n\nIn julia REPL,\n\nkey in OkPkgTemplates.DEFAULT_ and [tab] to list all functions that returns default variables\nkey in OkPkgTemplates.PLUGIN_ and [tab] to list all functions that returns ::PkgTemplates.Plugin presets.\n\nRedefine these functions in the local scope to assign the variable.\n\nExample\n\nTo specify output destination, redefine DEFAULT_DESTINATION()\n\nOkPkgTemplates.DEFAULT_DESTINATION() = pwd()\n\nand then generate the Package\n\n@genpkg \"MyNewProject\"\n\nnote: Note\nFeel free to redefine OkPkgTemplates.DEFAULT_...\n\nwarning: Warning\nIn the following cases, write a new macro of your own referencing @genpkg instead, or just use PkgTemplates as instructed:If you have the thought to redefine OkPkgTemplates.PLUGIN_...\nIf you want to set PkgTemplates.user_view (for example)\n\nAlso see the helps\n\ncopymyfiles_script\nupdateprojtoml_script\n\n\n\n\n\n","category":"macro"},{"location":"#OkPkgTemplates.@upactions-Tuple{}","page":"Home","title":"OkPkgTemplates.@upactions","text":"Replace Github Actions (all the files in .github/workflows) with the latest version that generated from OkPkgTemplates. Noted that julia enviroment should be activated in the current directory for your package in dev to update.\n\nwarning: Warning\nMake sure all your action files (all the files in .github/workflows) is under the control of git for safety.\n\nAlso see the helps\n\ncopymyfiles_script\nupdateprojtoml_script\n\n\n\n\n\n","category":"macro"}]
}
