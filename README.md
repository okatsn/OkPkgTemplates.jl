# OkPkgTemplates

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okatsn.github.io/OkPkgTemplates.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okatsn.github.io/OkPkgTemplates.jl/dev/)
[![Build Status](https://github.com/okatsn/OkPkgTemplates.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/okatsn/OkPkgTemplates.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/okatsn/OkPkgTemplates.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/okatsn/OkPkgTemplates.jl)

`OkPkgTemplates` initiate julia package with CI presets that automate test, release tag, documentation and registry management **based on** [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) with my personal preferences.

Please read `README.md` of the generated package for further instructions to complete the workflow setting.


## Compatibility
`OkPkgTemplates` is compatible to `PkgTemplates` of this commit: https://github.com/JuliaCI/PkgTemplates.jl/commit/0de5d855e050d93169f8661a13b3a53a8cb2b283 or [v0.7.29](https://github.com/JuliaCI/PkgTemplates.jl/releases/tag/v0.7.29)


## TagBot Error
### Known issue
Seemingly, TagBot is designed to be interrupted in the process of scanning sequentially the existent tags until `Error: TagBot experienced an unexpected internal failure`.
However, in many of my packages it experience this error at a much earlier stage that no further version can be tagged anymore, this is not what I desired.

The detail of the internal failure above is like:
```
raise self.__createException(status, responseHeaders, output)
github.GithubException.GithubException: 403 {"message": "Resource not accessible by integration", "documentation_url": "https://docs.github.com/rest/reference/git#create-a-reference"}
```

Excluded possible causes for this error:
- The `${{ github.event.head_commit.message }}` in the changelog template: I delete them in `Shorthands` and `OkPkgTemplates`'s `Tagbot.yml`. But the problem remains.
- The broken of `OkRegistry`: Seemingly no problem in `OkRegistry`. It is OK to make your registry as a Package (as [HolyLabRegistry](https://github.com/HolyLab/HolyLabRegistry)). Furthermore, for example, in `OkPkgTemplates` there is no inconsistency of version numbering, problem still occurred.

It seems to be an issue of permissions that may occur in many cases, see the threads:
- https://discourse.julialang.org/t/tagbot-unexpected-internal-error/74680/3
- https://discourse.julialang.org/t/tagbot-github-action-runs-successfully-but-a-new-release-does-not-show-up-on-github-releases/80770
- https://github.com/JuliaRegistries/TagBot/issues/242

The problem seemingly always occur in the changelog generating stage, e.g., 
```
Generating changelog for version v0.2.3 (1281cdccbc33566fce239fbcd098797144020d98)
Warning: No registry pull request was found for this version
Error: TagBot experienced an unexpected internal failure
```

### Setting `custom` for the changelog template
Seemingly you cannot do this.

In [julia-tagbot#changelogs](https://github.com/marketplace/actions/julia-tagbot#changelogs), for the changelog template
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
  "package": "PackageName",
  "previous_release": "v1.1.2 (or null for first release)",
  // Go to julia-tagbot#changelogs to see all available variables
}
```
is not what you can explicitly set. 

The variable `custom` is defined when you use `PkgDev.tag("YourPackage", v"0.2.6"; release_notes="Trying release note")`, for example, as mentioned in TagBot's Readme. 
As you dig into the source code of `PkgDev`, you will find the variable `release_notes` eventually goes into `GitHub.create_pull_request(...)` (see [tag.jl](https://github.com/JuliaLang/PkgDev.jl/blob/ffc464b068cee8604083804e757103771510fbce/src/tag.jl)).

That is, you can only have your final changelog templated with these existing variable, through for example `{{ package }}of version {{ version }} after {{ previous_release }}`; noted that this is a [Jinja](https://routebythescript.com/using-yaml-and-jinja-to-create-network-configurations/) templating (no evaluation `$` sign of [Github Actions - Expression](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/expressions)).
That is, it is useless to solely set environment variable (e.g., `env: custom: "My message..."`) in your YAML; you have to also add evaluation sign but in this way you can easily break the changelog generating process since the variable itself might contain something that violates the templating rules.

In conclusion, TagBot is Pull-Request based that you can only manipulate the changelog with information captured from pull-request or issues.


### TODO/CHECKPOINT

- Manually tag all versions that TagBot can skip.
- You have to figure out the formal way to provide custom message in the changelog template. Even if `${{ github.event.head_commit.message }}` deleted problem still remains, it very likely be the cause. As in the previous `client-payload:` test, `Error: Unexpected token T in JSON` occurred in saving the committed message (https://github.com/okatsn/OkPkgTemplates.jl/actions/runs/3702434045/jobs/6272709943#step:6:12).


## TODO: Hints for Documenter

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
    makedocs(root=joinpath(dirname(pathof(OkPkgTemplates)), "..", "docs"), sitename="TEMP")
    ```
    - Use `dirname(pathof(OkPkgTemplates))` to locate `OkPkgTemplates/src`!

!!! warning for  `@autodocs`:
    Noted that you cannot generate duplicate doc strings with `@autodocs`, with later ones all ignored with warning messages. For example:
    In `index.md`, I have `@autodocs` block:
    ```@autodocs
    Modules = [SWCForecast]
    Order   = [:function, :type]
    ```
    , which generates docstrings for ALL instances under `SWCForecast`.
    After that, in `"models/model2.md"`, I have `@autodocs` block:
    ```@autodocs
    Modules = [SWCForecast]
    Order   = [:function, :type]
    using FileTools, SWCForecast
    Pages = filelist(r".+\.jl", joinpath(dirname(pathof(SWCForecast)),"mymodels"); join=false)
    # which might be `Pages = [model2.jl, model2a.jl]` in the directory "mymodels", for example
    ```
    , which is intended to generate docstrings for instances (functions, macros, structs...) defined in all `.jl` files in the directory "mymodels".
    However, since the docstrings for an instance cannot be `@autodocs` twice, the corresponding `@autodocs` block in the page `"Model 2" => "models/model2.md"` will be empty.

For more information, see [this](https://documenter.juliadocs.org/stable/man/guide/#Adding-Some-Docstrings)
