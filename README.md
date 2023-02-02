# OkPkgTemplates

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okatsn.github.io/OkPkgTemplates.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okatsn.github.io/OkPkgTemplates.jl/dev/)
[![Build Status](https://github.com/okatsn/OkPkgTemplates.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/okatsn/OkPkgTemplates.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/okatsn/OkPkgTemplates.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/okatsn/OkPkgTemplates.jl)

`OkPkgTemplates` initiate julia package with CI presets that automate test, release tag, documentation and registry management **based on** [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) with my personal preferences. 
You can fork this repository and replace `okatsn/OkRegistry` and its path by your own.

## Basic use
- `help?> @genpkg` to see how to create a new package with this template.
- `help?> @upactions` to see how to update files in `.github/workflows` at one click once your package is already created.


Please also read `README.md` of the generated package for further instructions to complete the workflow setting.


## Compatibility
`OkPkgTemplates` is compatible to `PkgTemplates` of this commit: https://github.com/JuliaCI/PkgTemplates.jl/commit/0de5d855e050d93169f8661a13b3a53a8cb2b283 or [v0.7.29](https://github.com/JuliaCI/PkgTemplates.jl/releases/tag/v0.7.29)


## TagBot
### TagBot is designed to stop at failure
Seemingly, TagBot is designed to be interrupted in the process of scanning sequentially the existent tags until `Error: TagBot experienced an unexpected internal failure`. In some cases, it experience this error at a much earlier stage that no further version can be tagged anymore.

For example, in the case I modify the `TagBot.yml` for the attempt to include commit message as the release note by adding `${{ github.event.head_commit.message }}` in the `changelog` template as the input for the TagBot action, the internal failure will occurred if the tagbot does not triggered and run successfully exactly at that commit. The error is as followings:  
```
raise self.__createException(status, responseHeaders, output)
github.GithubException.GithubException: 403 {"message": "Resource not accessible by integration", "documentation_url": "https://docs.github.com/rest/reference/git#create-a-reference"}
```

And it is found that the problem always occur in the changelog generating stage for this example, because `github.event.head_commit.message` is not accessible. 
```
Generating changelog for version v0.2.3 (1281cdccbc33566fce239fbcd098797144020d98)
Warning: No registry pull request was found for this version
Error: TagBot experienced an unexpected internal failure
```

The Action that includes the commit message will always fail if it is triggered by other action.
This is because beyond that commit (starting a new machine), `github.event.head_commit.message` does not exist anymore.


### Trouble shooting
Once it experienced this kind of error in the history, further tagging will never be reached EVEN IF you fixed your `TagBot.yml`. To deal with this problem, just manually tag on all commits that should be tagged correctly, and TagBot can go further from the last tag.

Manually add tags correctly may solve many problems:
1. Go to Github Actions of the repo, click TagBot to see at what version it stuck.
2. Go to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) to get the git-tree-sha1 of the version where it always failed.
3. Convert `git-tree-sha1` to commit hash in bash: `git log --pretty=raw | grep -B 1 <git-tree-sha1>` (no `<` and `>`).
4. In Git Graph, add tag at that commit hash.


- https://discourse.julialang.org/t/tagbot-unexpected-internal-error/74680/3
- https://discourse.julialang.org/t/tagbot-github-action-runs-successfully-but-a-new-release-does-not-show-up-on-github-releases/80770
- https://github.com/JuliaRegistries/TagBot/issues/242





### What is the variable `custom` in the `changelog` template?
You cannot define the variable `custom` for the `changelog` template in your repository.
As referred in [julia-tagbot#changelogs](https://github.com/marketplace/actions/julia-tagbot#changelogs), for the changelog template
```json
...
    ...
        with:
        token: ${{ secrets.GITHUB_TOKEN }}
        changelog: |
            This is release {{ version }} of {{ package }}.
            {% if custom %}
            Here are my release notes!
            {{ custom }}
            {% endif %}
```
where "The data available to you looks like this:"
```json
{
  "compare_url": "https://github.com/Owner/Repo/compare/previous_version...current_version (or null for first release)",
  "custom": "your custom release notes",
  "package": "YourPackage",
  "previous_release": "v1.1.2 (or null for first release)",
  // Go to julia-tagbot#changelogs to see all available variables
}
```
is not what you can explicitly set. 

However, the variable `custom` can be defined when you use `PkgDev.tag("YourPackage", v"0.2.6"; release_notes="Trying release note")`, for example, as mentioned in TagBot's Readme. 
As you dig into the source code of `PkgDev`, you will find the variable `release_notes` eventually goes into `GitHub.create_pull_request(...)` as the `:body` entry (see [tag.jl](https://github.com/JuliaLang/PkgDev.jl/blob/ffc464b068cee8604083804e757103771510fbce/src/tag.jl)).

That is, you can only have your final changelog templated with these existing variable, through for example `{{ package }}of version {{ version }} after {{ previous_release }}`; noted that this is a [Jinja](https://routebythescript.com/using-yaml-and-jinja-to-create-network-configurations/) templating (no evaluation `$` sign of [Github Actions - Expression](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/expressions)).
That is, it is useless to solely set environment variable (e.g., `env: custom: "My message..."`) in your YAML; you have to also add evaluation sign but in this way you can easily break the changelog generating process since the variable itself might contain something that violates the templating rules.

In conclusion, TagBot is Pull-Request based that you can only manipulate the changelog with information captured from pull-request or issues.


## Use of Documenter


In `docs/make.jl`, add pages for example:
```julia
pages=[
    "Home" => "index.md",
    "Examples" => "examples/examples.md",
    "Exported Functions" => "functions.md",
    "Models" =>
                ["Model 1" => "models/model1.md",
                 "Model 2" => "models/model2.md"],
    "Reference" => "reference.md",
    ]
```

In which,
- the `index.md` is the home page, where
    - [`@index` block](https://documenter.juliadocs.org/stable/man/syntax/#@index-block) makes a list of links to docstrings once generated by `@autodoc` in any of your `.md` files for pages.
    - [`@autodocs` block](https://documenter.juliadocs.org/stable/man/syntax/#@autodocs-block) automatically generates docstrings given
        1. the `Modules` (e.g., `Modules = [Foo, Bar, Bar.Baz]`)
        2. the `Pages` (e.g., `Pages   = ["a.jl", "b.jl"]`)
- [`@contents` block](https://documenter.juliadocs.org/stable/man/syntax/#@contents-block) generates table of contents.
    - Example
      ```@contents
      Pages = ["examples/examples.md"]
      Depth = 5
      ```

!!! note
    - If error occurred in generating the page, try the followings in your local machine:
    ```julia
    makedocs(root=joinpath(dirname(pathof(YourPackage)), "..", "docs"), sitename="TEMP")
    ```
    - Use `dirname(pathof(YourPackage))` to locate `YourPackage/src`!

!!! warning for  `@autodocs`:
    Noted that you cannot generate duplicate doc strings with `@autodocs`, with later ones all ignored with warning messages. For example:
    In `index.md`, I have `@autodocs` block:
    ```@autodocs
    Modules = [YourPackage]
    Order   = [:function, :type]
    ```
    , which generates docstrings for ALL instances under `YourPackage`.
    After that, in `"models/model2.md"`, I have `@autodocs` block:
    ```@autodocs
    Modules = [YourPackage]
    Order   = [:function, :type]
    using FileTools, YourPackage
    Pages = filelist(r".+\.jl", joinpath(dirname(pathof(YourPackage)),"mymodels"); join=false)
    # which might be `Pages = [model2.jl, model2a.jl]` in the directory "mymodels", for example
    ```
    , which is intended to generate docstrings for instances (functions, macros, structs...) defined in all `.jl` files in the directory "mymodels".
    However, since the docstrings for an instance cannot be `@autodocs` twice, the corresponding `@autodocs` block in the page `"Model 2" => "models/model2.md"` will be empty.

For more information, see [this](https://documenter.juliadocs.org/stable/man/guide/#Adding-Some-Docstrings)
