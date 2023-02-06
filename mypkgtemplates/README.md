# {{{PKG}}}{{#HAS_INLINE_BADGES}} {{#BADGES}}{{{.}}} {{/BADGES}}{{/HAS_INLINE_BADGES}}
{{^HAS_INLINE_BADGES}}

{{#BADGES}}
{{{.}}}
{{/BADGES}}
{{/HAS_INLINE_BADGES}}
{{#HAS_CITATION}}

## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
{{/HAS_CITATION}}

<!-- Don't have any of your custom contents above; they won't occur if there is no citation. -->

## Introduction

This is a julia package created using `okatsn`'s preference, and this package is expected to be registered to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) for CIs to work properly.

!!! note Checklist
    - [ ] Add `ACCESS_OKREGISTRY` secret in the settings of this repository on Github, or delete both `register.yml` and `TagBot.yml` in `/.github/workflows/`. See [Auto-Registration](#auto-registration).
    - [ ] Create an empty repository (namely, `https://github.com/okatsn/{{{PKG}}}.jl.git`) on github, and push the local to origin. See [connecting to remote](#tips-for-connecting-to-remote).

### Go to [OkPkgTemplates](https://github.com/okatsn/OkPkgTemplates.jl) for more information
- [How TagBot works and trouble shooting](https://github.com/okatsn/OkPkgTemplates.jl#tagbot)
- [Use of Documenter](https://github.com/okatsn/OkPkgTemplates.jl#use-of-documenter)

## References

### Auto-Registration
- You have to add `ACCESS_OKREGISTRY` to the secret under the remote repo (e.g., https://github.com/okatsn/{{{PKG}}}.jl).
- `ACCESS_OKREGISTRY` allows `CI.yml` to automatically register/update this package to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry).

### Test docstring
`pkg> add Documenter` to make doc tests worked.

`doctest` is executed at the following **two** places:
1. In `CI.yml`, `jobs: test: ` that runs `test/runtests.jl`
2. In `CI.yml`, `jobs: docs: ` that runs directly on bash.

It is no harm to run both, or you may manually delete either.

### Tips for connecting to remote
Connect to remote:
1. Switch to the local directory of this project ({{{PKG}}})
2. Add an empty repo {{{PKG}}}(.jl) on github (without anything!)
3. `git push origin main`
- It can be quite tricky, see https://discourse.julialang.org/t/upload-new-package-to-github/56783
More reading
Pkg's Artifact that manage an external dataset as a package
- https://pkgdocs.julialang.org/v1/artifacts/
- a provider for reposit data: https://github.com/sdobber/FA_data


This package is create on {{{TODAY}}}.
