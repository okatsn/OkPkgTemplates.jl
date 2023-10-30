

## Interface

### [`generate`](@ref OkPkgTemplates.generate)

```@docs; canonical=false
OkPkgTemplates.generate
```

### [`update`](@ref OkPkgTemplates.update)

```@docs; canonical=false
OkPkgTemplates.update
```

## List of available [TemplateIdentifier](@ref OkPkgTemplates.TemplateIdentifier)

```@eval
using OkPkgTemplates, InteractiveUtils, Markdown
strs = join("- " .* string.(subtypes(OkPkgTemplates.TemplateIdentifier)), "\n")
Markdown.parse(strs)
```