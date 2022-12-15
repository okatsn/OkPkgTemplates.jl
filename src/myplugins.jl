# Readme
# - see also PkgTemplates/src/plugins/readme.jl
const PLUGIN_README = PkgTemplates.Readme(; file=mypkgtemplate_dir("README.md"), destination="README.md")

# TagBot
# - see PkgTemplates/src/plugins/tagbot.jl
# - `changelog` is modified from [default changelog template](https://github.com/JuliaRegistries/TagBot/blob/master/action.yml) with extra `${{github.event.head_commit.message}}` (for get the commit message).
# - If your registry is public, this is all you need to do. For more information, see [here](https://github.com/JuliaRegistries/TagBot#custom-registries)
const PLUGIN_TAGBOT = TagBot(;registry="okatsn/OkRegistry",
        changelog = """
        ## {{ package }} {{ version }}
        \${{github.event.head_commit.message}}
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
const PLUGIN_TEST = Tests(; file=mypkgtemplate_dir("test","runtests.jl")) # see PkgTemplates/src/plugins/tests.jl
