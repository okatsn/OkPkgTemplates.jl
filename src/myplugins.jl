# Readme
# - see also PkgTemplates/src/plugins/readme.jl
PLUGIN_README() = PkgTemplates.Readme(; file=mypkgtemplate_dir("README.md"), destination="README.md")

"""
`PLUGIN_TAGBOT()` returns an `PkgTemplates.TagBot`.
You can redefine this function.

By default it add the commit message `github.event.client_payload.commit_msg` as part of the release note. Please must read **Known issue** in the doc of `PLUGIN_REGISTER()`.

# Changelog
For variables that you can use in the changelog template, see [line 174-184, tagbot/action/changelog.py](https://github.com/JuliaRegistries/TagBot/blob/afbc9c3f5dc23047ea6e187f2cb1a3ac7d1fbbeb/tagbot/action/changelog.py) and [TagBot/Changelogs](https://github.com/JuliaRegistries/TagBot#changelogs). Which are
- "compare_url"
- "custom"
- "issues"
- "package"
- "previous_release"
- "pulls"
- "sha"
- "version"
- "version_url"

Also see
- [Default changelog template](https://github.com/JuliaRegistries/TagBot/blob/master/action.yml).

# More information
- see [PkgTemplates/src/plugins/tagbot.jl](https://github.com/JuliaCI/PkgTemplates.jl/blob/master/src/plugins/tagbot.jl).
- If your registry is public, you don't need to provide token. For more information, see [here](https://github.com/JuliaRegistries/TagBot#custom-registries)

"""
PLUGIN_TAGBOT() = TagBot(;registry="okatsn/OkRegistry",
        changelog = """
        ## {{ package }} {{ version }}
        \${{ github.event.client_payload.commit_msg }}
        {% if previous_release %}
        [Diff since {{ previous_release }}]({{ compare_url }})
        {% endif %}
        {% if custom %}
        {{ custom }}
        {% endif %}
        {% if issues %}
        **Closed issues:**
        {% for issue in issues %}
        - {{ issue.title }} (#{{ issue.number }})
        {% endfor %}
        {% endif %}
        {% if pulls %}
        **Merged pull requests:**
        {% for pull in pulls %}
        - {{ pull.title }} (#{{ pull.number }}) (@{{ pull.author.username }})
        {% endfor %}
        {% endif %}
        """,
        file = mypkgtemplate_dir("github", "workflows", "TagBot.yml"))

# Test
PLUGIN_TEST() = Tests(; file=mypkgtemplate_dir("test","runtests.jl")) # see PkgTemplates/src/plugins/tests.jl


# see PkgTemplates/src/plugins/ci.jl
PLUGIN_GITHUBACTION() = GitHubActions(;file = mypkgtemplate_dir("github", "workflows", "CI.yml"))


"""
`PLUGIN_REGISTER()` by default uses templates in $(mypkgtemplate_dir("github", "workflows", "register.yml")).

In the default template, job attempts to register the latest pushed commit of `YourPackage` where `Project.toml` is modified. If success, `TagBot.yml` will be triggered. See also `PLUGIN_TAGBOT`.

If `Project.toml` is modified but version number unchanged, it simply failed and you don't have to worry about anything.

# Known issue
According to the default "register.yml", in the workflow "Register Package to OkRegistry" both the repo of `YourPackage` and `OkRegistry` is checked out, and register `YourPackage` to `OkRegistry` using PAT `ACCESS_OKREGISTRY` token that must be provided in advance via your Github account.

As the latest commit you push is not necessary the commit you want to register, unexpected results will occurr if you push several commits among either of them 'Project.toml' is modified.

For example:
- You have in several un-pushed commits that changes 'Project.toml', and push them at once, it register the version number of the lastest commit BUT `client_payload` (client-payload in `register.yml`) store and pass the information of the earliest commit in your push.
- You add `[compat]` at the first commit with message "Fix compatibility", and increase the version number with message "New keyword args. `mkpath` for `mv2dir` ...". Both modify `Project.toml`, and the last one is registered but in release log it shows only "Fix compatibility".

If you want to automatically add commit message release note of the registered commit but you are too lazy to create pull requests since you are almost the only person working on `YourPackage`, please
- push everything else before you increase the version number, and
- push only the `Project.toml` with commit message you'd like to be adopted as release note.


# In `register.yml`:
`with` Options for `name: Trigger next workflow`:
- `client-payload:` passes data from Workflow 1 to Workflow 2
  - Example:
    ```
    with:
      client-payload: '{"ref": "\${{ github.ref }}", "sha": "\${{ github.sha }}"}'
    ```
  - Commit message can be obtained from both
    - `\${{ github.event.commits[0].message }}` and
    - `\${{ github.event.head_commit.message }}`
    - (Not sure) the latter one could be empty
    - (Not sure) error with the latter one could result from permission: content: false
    - It is possible to [Iterating over github.event.commits](https://github.com/orgs/community/discussions/35120) or [use join function to concatenate commits](https://github.com/orgs/community/discussions/25164).
    - Alternative way to [Get a commit](https://docs.github.com/en/rest/git/commits?apiVersion=2022-11-28#get-a-commit) using `curl`.
  - Also see [github context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context) for what others are available.
  - **Noted that multiline string is not acceptable for json**, you have to use e.g. "# hello\\n second line" istead as the commit message where Project.toml version is raised.

Be aware if you have in several un-pushed commits that changes 'Project.toml', and push them at once, `"commit_msg": "\${{ github.event.commits[0].message` will be the first commit and it is not necessarily the commit to be registered. UpdateOkReg register a version for this package at the latest commit being pushed.
"""
PLUGIN_REGISTER() = RegisterAction(; file=mypkgtemplate_dir("github", "workflows", "register.yml"))


PLUGIN_COMPATHELPER() = CompatHelper(;
    file=mypkgtemplate_dir("github", "workflows", "CompatHelper.yml"),
    cron="0 0 * * *",
    ) # See for configuration: https://juliaregistries.github.io/CompatHelper.jl/stable/options/
