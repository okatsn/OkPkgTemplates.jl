"""
`update` execute expressions returned by `upactions` one-by-one.

Running `update` overwrite/update Github actions of the repository of the currently activated julia package; make sure they are under version control that the process can be reverted.

# Example

Activate environment `OkPkgTemplates`:

```pkg-repl
pkg> activate .
(OkPkgTemplates) pkg>
```

Update CIs in `OkPkgTemplates`:

```julia
julia> using OkPkgTemplates
julia> update(GeneralReg)
```
"""
function update(TId::Type{<:TemplateIdentifier})
    exprs = upactions(TId)
    for ex in exprs
        @eval $ex
    end
end

"""
Overwrite/Update Github actions of the repository of the julia package in development; make sure the pacakge is under version control that the process can be reverted.

# Example

Activate environment `OkPkgTemplates`:

```pkg-repl
pkg> activate .
(OkPkgTemplates) pkg> dev OkFiles
    Resolving package versions...
    Updating `~/.julia/dev/OkPkgTemplates/Project.toml`
    [b25a35d4] + OkFiles v0.4.1 `~/.julia/dev/OkFiles`
    Updating `~/.julia/dev/OkPkgTemplates/Manifest.toml`
    [b25a35d4] + OkFiles v0.4.1 `~/.julia/dev/OkFiles`
```

Update CIs in `OkFiles`:

```julia
julia> using OkPkgTemplates, OkFiles
julia> update(OkFiles, GeneralReg)
```
"""
function update(mod::Module, TId::Type{<:TemplateIdentifier})
    @eval @upactions $mod $TId
end
