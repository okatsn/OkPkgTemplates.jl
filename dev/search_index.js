var documenterSearchIndex = {"docs":
[{"location":"sayhello/","page":"Macro call explained","title":"Macro call explained","text":"The use of macro is confusing. Thus, I made an exemplary @sayhello3 to help me understand.","category":"page"},{"location":"sayhello/#The-say-hello-function","page":"Macro call explained","title":"The say-hello function","text":"","category":"section"},{"location":"sayhello/","page":"Macro call explained","title":"Macro call explained","text":"OkPkgTemplates.sayhello3","category":"page"},{"location":"sayhello/#OkPkgTemplates.sayhello3","page":"Macro call explained","title":"OkPkgTemplates.sayhello3","text":"sayhello3(name) = \"Hello world! $name\", an example to understand metaprogramming.\n\n\n\n\n\n","category":"function"},{"location":"sayhello/#The-say-hello-macro-built-upon","page":"Macro call explained","title":"The say-hello macro built upon","text":"","category":"section"},{"location":"sayhello/","page":"Macro call explained","title":"Macro call explained","text":"OkPkgTemplates.@sayhello3","category":"page"},{"location":"sayhello/#OkPkgTemplates.@sayhello3","page":"Macro call explained","title":"OkPkgTemplates.@sayhello3","text":"macro sayhello3(str::String)\n    return Expr(:block, :(sayhello3($str)))\nend\n\nExample\n\nOkPkgTemplates.@sayhello3 \"Bruce Willey\"\n\n# output\n\"Hello world! Bruce Willey\"\n\n\n\n\n\nmacro sayhello3(ex::Expr)\n    return Expr(:block, :(sayhello3($(last(ex.args)))))\nend\n\nExample: variable name is not defined in macro's scope\n\nname = \"Bruce Willey\"\n\n# output\n\"Bruce Willey\"\n\njulia> OkPkgTemplates.@sayhello3 $name\nERROR: UndefVarError: `name` not defined\n\ntip: Explain\nname is passed as expression in this case, and it is not defined since macro dispatch is not based on the AST evaluated at runtime. Thus an error of UndefVarError is raised.\nSee Macros and dispatch for more information.\n\nExample: a creative application\n\nOkPkgTemplates.@sayhello3 name = \"Bruce Willey\"\n\n# output\n\"Hello world! Bruce Willey\"\n\ntip: Explain\nIn this example, the last argument of the expression name = \"Bruce Willey\" is \"Bruce Willey\".\n\nExample 3: Use @eval if you want name be evaluated\n\n@eval OkPkgTemplates.@sayhello3 $name\n\n# output\n\"Hello world! Bruce Willey\"\n\ntip: Explain\n@eval evalute the expression @sayhello3 $name at runtime.\nThus, the argument for @sayhello3 is evaluated as String, and @sayhello3(str::String) is the dispatched method.\n\n\n\n\n\nmacro sayhello3(symb::Symbol)\n    return Expr(:block, :(sayhello3($(string(symb)))))\nend\n\nExample: A single the runtime variable is rendered as Symbol\n\nname = \"Bruce Willey\"\nOkPkgTemplates.@sayhello3 name\n\n# output\n\"Hello world! name\"\n\n\n\n\n\n","category":"macro"},{"location":"extend/","page":"Extend","title":"Extend","text":"The use of macro is confusing. Thus, I made an exemplary @sayhello3 to help me understand.","category":"page"},{"location":"extend/#The-use-of-genpkg","page":"Extend","title":"The use of genpkg","text":"","category":"section"},{"location":"extend/","page":"Extend","title":"Extend","text":"OkPkgTemplates.genpkg","category":"page"},{"location":"extend/#OkPkgTemplates.genpkg","page":"Extend","title":"OkPkgTemplates.genpkg","text":"genpkg(yourpkgname::String, fs...) execute scripts fs one by one in user's scope using OkPkgTemplates's utilities.\n\nPlease define OkPkgTemplates.DEFAULT_** for changing defaults.\n\nIf OkPkgTemplates.DEFAULT_DESTINATION() returns an empty string, it use Pkg.devdir() at user's scope.\n\ntip: Tip\nIn julia REPL,key in OkPkgTemplates.DEFAULT_ and [tab] to list all functions that returns default variables\nkey in OkPkgTemplates.PLUGIN_ and [tab] to list all functions that returns ::PkgTemplates.Plugin presets.\nRedefine these functions in the local scope to assign the variable.\n\nExample\n\nTo specify output destination, redefine DEFAULT_DESTINATION()\n\nOkPkgTemplates.DEFAULT_DESTINATION() = pwd()\n\nand then generate the Package\n\n@genpkg \"MyNewProject\" OkReg\n\nnote: Note\nFeel free to redefine OkPkgTemplates.DEFAULT_...\n\nwarning: Warning\nIn the following cases, write a new macro of your own referencing @genpkg instead, or just use PkgTemplates as instructed:If you have the thought to redefine OkPkgTemplates.PLUGIN_...\nIf you want to set PkgTemplates.user_view (for example)\n\nAlso see the helps\n\ncopymyfiles_script\nupdateprojtoml_script\n\n\n\n\n\n","category":"function"},{"location":"extend/#Procedure-to-add-a-new-method-of-@genpkg","page":"Extend","title":"Procedure to add a new method of @genpkg","text":"","category":"section"},{"location":"extend/","page":"Extend","title":"Extend","text":"OkPkgTemplates.TemplateIdentifier","category":"page"},{"location":"extend/#OkPkgTemplates.TemplateIdentifier","page":"Extend","title":"OkPkgTemplates.TemplateIdentifier","text":"For developer,\n\n1. add new struct XXX <: TemplateIdentifier end for every new @genpkg.\n\n2. add a new templating expression, e.g.,\n\npkgtemplating_xxx(dest, yourpkgname) = quote\n    t = Template(;\n        user=DEFAULT_USERNAME(),\n        dir=$dest,\n        julia=DEFAULT_JULIAVER(),\n        plugins=[\n            Git(; manifest=false),\n            PLUGIN_COMPATHELPER(),\n            PLUGIN_GITHUBACTION(),\n            Codecov(), # https://about.codecov.io/\n            Documenter{GitHubActions}(),\n            PkgTemplates.Readme(),\n            PkgTemplates.TagBot(; changelog=tagbot_changelog()),\n            PLUGIN_TEST(),\n            RegisterAction()\n        ]\n    )\n\n    t($yourpkgname)\nend\n\n3. add a new method for @genpkg macro\n\nget_exprs(::Type{XXX}) = [pkgtemplating_xxx, updateprojtoml_script] # Expressions to be executed\nmacro genpkg(yourpkgname::String, xxx::Type{XXX})\n    dest = chkdest()\n    return genpkg(dest, yourpkgname, get_exprs(xxx)...)\nend\n\n\n\n\n\n","category":"type"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = OkPkgTemplates","category":"page"},{"location":"#OkPkgTemplates","page":"Home","title":"OkPkgTemplates","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for OkPkgTemplates.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [OkPkgTemplates]","category":"page"},{"location":"#OkPkgTemplates.commit_msg","page":"Home","title":"OkPkgTemplates.commit_msg","text":"Notice\n\nCurrently, you have to add\n\n    client-payload: '{\"commit_msg\": \"${{ github.event.commits[0].message }}\"}'\n\n\nin register.yml manually.\n\nIn register.yml:\n\nwith Options for name: Trigger next workflow:\n\nclient-payload: passes data from Workflow 1 to Workflow 2\nExample:\nwith:\n  client-payload: '{\"ref\": \"${{ github.ref }}\", \"sha\": \"${{ github.sha }}\"}'\nCommit message can be obtained from both\n${{ github.event.commits[0].message }} and\n${{ github.event.head_commit.message }}\n(Not sure) the latter one could be empty\n(Not sure) error with the latter one could result from permission: content: false\nIt is possible to Iterating over github.event.commits or use join function to concatenate commits.\nAlternative way to Get a commit using curl.\nAlso see github context for what others are available.\nNoted that multiline string is not acceptable for json, you have to use e.g. \"# hello\\n second line\" istead as the commit message where Project.toml version is raised.\n\nBe aware if you have in several un-pushed commits that changes 'Project.toml', and push them at once, \"commit_msg\": \"${{ github.event.commits[0].message will be the first commit and it is not necessarily the commit to be registered. UpdateOkReg register a version for this package at the latest commit being pushed.\n\nNotice\n\nAs the latest commit you push is not necessary the commit you want to register, unexpected results will occurr if you push several commits among either of them 'Project.toml' is modified.\n\nFor example:\n\nYou have in several un-pushed commits that changes 'Project.toml', and push them at once, it register the version number of the lastest commit BUT client_payload (client-payload in register.yml) store and pass the information of the earliest commit in your push.\nYou add [compat] at the first commit with message \"Fix compatibility\", and increase the version number with message \"New keyword args. mkpath for mv2dir ...\". Both modify Project.toml, and the last one is registered but in release log it shows only \"Fix compatibility\".\n\nIf you want to automatically add commit message release note of the registered commit but you are too lazy to create pull requests since you are almost the only person working on YourPackage, please\n\npush everything else before you increase the version number, and\npush only the Project.toml with commit message you'd like to be adopted as release note.\n\n\n\n\n\n","category":"constant"},{"location":"#OkPkgTemplates.logfile_msg","page":"Home","title":"OkPkgTemplates.logfile_msg","text":"\n\n\n\n","category":"constant"},{"location":"#OkPkgTemplates.PLUGIN_REGISTER-Tuple{}","page":"Home","title":"OkPkgTemplates.PLUGIN_REGISTER","text":"PLUGIN_REGISTER() by default uses templates in /home/runner/work/OkPkgTemplates.jl/OkPkgTemplates.jl/mypkgtemplates/for_okregistry/github/workflows/register.yml.\n\nIn the default template, job attempts to register the latest pushed commit of YourPackage where Project.toml is modified. If success, TagBot.yml will be triggered. See also PLUGIN_TAGBOT.\n\nIf Project.toml is modified but version number unchanged, it simply failed and you don't have to worry about anything.\n\nKnown issue\n\nAccording to the default \"register.yml\", in the workflow \"Register Package to OkRegistry\" both the repo of YourPackage and OkRegistry is checked out, and register YourPackage to OkRegistry using PAT ACCESS_OKREGISTRY token that must be provided in advance via your Github account. By default,  actions/checkout checkout the commit of the pushed event.\n\nAfter the current version is successfully registerd, TagBot will be triggered. However, if there is something wrong in tagging the previous version, that is a version exists in OkRegistry but failed to be tagged with TagBot, TagBot will stop at that version; and thus, succeeding versions cannot be tagged. See README for trouble shooting.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.PLUGIN_TAGBOT-Tuple{}","page":"Home","title":"OkPkgTemplates.PLUGIN_TAGBOT","text":"PLUGIN_TAGBOT() returns an PkgTemplates.TagBot. You can redefine this function.\n\nBy default it add github.event.client_payload.logfile_msg as part of the release note. Please must read Known issue in the doc of PLUGIN_REGISTER().\n\nChangelog\n\nFor variables that you can use in the changelog template, see line 174-184, tagbot/action/changelog.py and TagBot/Changelogs. Which are\n\n\"compare_url\"\n\"custom\"\n\"issues\"\n\"package\"\n\"previous_release\"\n\"pulls\"\n\"sha\"\n\"version\"\n\"version_url\"\n\nAlso see\n\nDefault changelog template.\n\nMore information\n\nsee PkgTemplates/src/plugins/tagbot.jl.\nIf your registry is public, you don't need to provide token. For more information, see here\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.chkdest-Tuple{}","page":"Home","title":"OkPkgTemplates.chkdest","text":"chkdest() return Pkg.devdir() if DEFAULT_DESTINATION() is empty.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.copymyfiles_script-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.copymyfiles_script","text":"Copy some files from repo0 to repo1. List of files:\n\nAll files under .github/workflows\n\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.genpkg-Tuple{Any, Any, Vararg{Any}}","page":"Home","title":"OkPkgTemplates.genpkg","text":"genpkg(yourpkgname::String, fs...) execute scripts fs one by one in user's scope using OkPkgTemplates's utilities.\n\nPlease define OkPkgTemplates.DEFAULT_** for changing defaults.\n\nIf OkPkgTemplates.DEFAULT_DESTINATION() returns an empty string, it use Pkg.devdir() at user's scope.\n\ntip: Tip\nIn julia REPL,key in OkPkgTemplates.DEFAULT_ and [tab] to list all functions that returns default variables\nkey in OkPkgTemplates.PLUGIN_ and [tab] to list all functions that returns ::PkgTemplates.Plugin presets.\nRedefine these functions in the local scope to assign the variable.\n\nExample\n\nTo specify output destination, redefine DEFAULT_DESTINATION()\n\nOkPkgTemplates.DEFAULT_DESTINATION() = pwd()\n\nand then generate the Package\n\n@genpkg \"MyNewProject\" OkReg\n\nnote: Note\nFeel free to redefine OkPkgTemplates.DEFAULT_...\n\nwarning: Warning\nIn the following cases, write a new macro of your own referencing @genpkg instead, or just use PkgTemplates as instructed:If you have the thought to redefine OkPkgTemplates.PLUGIN_...\nIf you want to set PkgTemplates.user_view (for example)\n\nAlso see the helps\n\ncopymyfiles_script\nupdateprojtoml_script\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.mypkgtemplate_dir-Tuple{Vararg{AbstractString}}","page":"Home","title":"OkPkgTemplates.mypkgtemplate_dir","text":"Return a path relative to the default template file directory (OkPkgTemplates/mypkgtemplates).\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.pkgtemplating_gereg-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.pkgtemplating_gereg","text":"pkgtemplating_gereg(dest, yourpkgname) returns the script of PkgTemplates (quote ... end) for general registry.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.pkgtemplating_okreg-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.pkgtemplating_okreg","text":"pkgtemplating_okreg(dest, yourpkgname) returns the script of PkgTemplates (quote ... end) to be executed at the scope that the macro is called.\n\nIt\n\ncreates a package using PkgTemplates.Templates\nadd Documenter, CompatHelperLocal, Test into Project.toml\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.sayhello3-Tuple{Any}","page":"Home","title":"OkPkgTemplates.sayhello3","text":"sayhello3(name) = \"Hello world! $name\", an example to understand metaprogramming.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.stringscore-Tuple{Any}","page":"Home","title":"OkPkgTemplates.stringscore","text":"stringscore(str) gives an absolute score for a string; the order of score from large to small corresponds to the alphabetical order. For a string less than 100 characters, the score should not exceeds one.\n\nExample\n\njulia> stringscore.([\"AAA\", \"Aa\", \"BCD\"])\n3-element Vector{Float64}:\n 0.0656565\n 0.06597\n 0.06667680000000001\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.upactions-Tuple{String, String, Type{<:OkPkgTemplates.TemplateIdentifier}}","page":"Home","title":"OkPkgTemplates.upactions","text":"upactions(pwd1::String, pkgname::String, TI::Type{<:TemplateIdentifier}) return expression for replacing Github Actions (all the files in .github/workflows) with the latest version that generated from OkPkgTemplates.\n\nThis function is separated for test purpose. For user, please use @upactions.\n\nExample\n\nex = OkPkgTemplates.upactions(dir_targetfolder(), pkgname2build)\n@eval(OkPkgTemplates, $ex) # expression must be evaluated under the scope of OkPkgTemplates; otherwise, error will occur since the current scope might not have pakage required in `ex`.\n\nwarning: Warning\nMake sure all your action files (all the files in .github/workflows) is under the control of git for safety.\n\nAlso see the helps\n\ncopymyfiles_script\nupdateprojtoml_script\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.updateprojtoml_script-Tuple{Any, Any}","page":"Home","title":"OkPkgTemplates.updateprojtoml_script","text":"After making the template successfully, add \"Documenter\", \"CompatHelperLocal\" to [extras] and [targets] as runtests.jl (may) use them.\n\nupdateprojtoml_script(dest, yourpkgname) creates script that projtoml_path = joinpath(dest, yourpkgname, \"Project.toml\") will be modified on execution.\n\nIt modify Project.toml by add [extras] and [targets] for the scope of Test.\n\n\n\n\n\n","category":"method"},{"location":"#OkPkgTemplates.@sayhello3-Tuple{Expr}","page":"Home","title":"OkPkgTemplates.@sayhello3","text":"macro sayhello3(ex::Expr)\n    return Expr(:block, :(sayhello3($(last(ex.args)))))\nend\n\nExample: variable name is not defined in macro's scope\n\nname = \"Bruce Willey\"\n\n# output\n\"Bruce Willey\"\n\njulia> OkPkgTemplates.@sayhello3 $name\nERROR: UndefVarError: `name` not defined\n\ntip: Explain\nname is passed as expression in this case, and it is not defined since macro dispatch is not based on the AST evaluated at runtime. Thus an error of UndefVarError is raised.\nSee Macros and dispatch for more information.\n\nExample: a creative application\n\nOkPkgTemplates.@sayhello3 name = \"Bruce Willey\"\n\n# output\n\"Hello world! Bruce Willey\"\n\ntip: Explain\nIn this example, the last argument of the expression name = \"Bruce Willey\" is \"Bruce Willey\".\n\nExample 3: Use @eval if you want name be evaluated\n\n@eval OkPkgTemplates.@sayhello3 $name\n\n# output\n\"Hello world! Bruce Willey\"\n\ntip: Explain\n@eval evalute the expression @sayhello3 $name at runtime.\nThus, the argument for @sayhello3 is evaluated as String, and @sayhello3(str::String) is the dispatched method.\n\n\n\n\n\n","category":"macro"},{"location":"#OkPkgTemplates.@sayhello3-Tuple{String}","page":"Home","title":"OkPkgTemplates.@sayhello3","text":"macro sayhello3(str::String)\n    return Expr(:block, :(sayhello3($str)))\nend\n\nExample\n\nOkPkgTemplates.@sayhello3 \"Bruce Willey\"\n\n# output\n\"Hello world! Bruce Willey\"\n\n\n\n\n\n","category":"macro"},{"location":"#OkPkgTemplates.@sayhello3-Tuple{Symbol}","page":"Home","title":"OkPkgTemplates.@sayhello3","text":"macro sayhello3(symb::Symbol)\n    return Expr(:block, :(sayhello3($(string(symb)))))\nend\n\nExample: A single the runtime variable is rendered as Symbol\n\nname = \"Bruce Willey\"\nOkPkgTemplates.@sayhello3 name\n\n# output\n\"Hello world! name\"\n\n\n\n\n\n","category":"macro"},{"location":"#OkPkgTemplates.@upactions-Tuple{Module, Type{<:OkPkgTemplates.TemplateIdentifier}}","page":"Home","title":"OkPkgTemplates.@upactions","text":"@upactions(mod::Module, TI::Type{<:TemplateIdentifier}) update CIs using upactions referencing the path of mod. See upactions.\n\nExample\n\nusing MyPkgWhereCIToBeUpdated\n@eval @upactions $MyPkgWhereCIToBeUpdated $GeneralReg\n# execute `@upactions` whth `GeneralReg` evaluated as `Type{<:TemplateIdentifier}` and `MyPkgWhereCIToBeUpdated` evaluated as `Module`.\n\n\n\n\n\n","category":"macro"},{"location":"#OkPkgTemplates.@upactions-Tuple{Type{<:OkPkgTemplates.TemplateIdentifier}}","page":"Home","title":"OkPkgTemplates.@upactions","text":"@upactions update CIs using upactions referencing the path of the current activated project environment. See upactions.\n\nExample\n\n@eval @upactions $GeneralReg\n# execute `@upactions` whth `GeneralReg` evaluated as `Type{<:TemplateIdentifier}`\n\n\n\n\n\n","category":"macro"}]
}
