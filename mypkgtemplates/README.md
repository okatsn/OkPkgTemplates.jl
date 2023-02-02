# {{{PKG}}}{{#HAS_INLINE_BADGES}} {{#BADGES}}{{{.}}} {{/BADGES}}{{/HAS_INLINE_BADGES}}
{{^HAS_INLINE_BADGES}}

{{#BADGES}}
{{{.}}}
{{/BADGES}}
{{/HAS_INLINE_BADGES}}
{{#HAS_CITATION}}

This is a julia package created using `okatsn`'s preference, and this package is expected to be registered to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) for CIs to work properly.

!!! note Checklist
    - [ ] `pkg> add Documenter` to make doc tests work, or delete `using Documenter; @testset "DocTests" begin ...` in `test/runtests.jl`. See [Doc Test](#doc-test).
    - [ ] Add `ACCESS_OKREGISTRY` secret in the settings of this repository on Github, or delete both `register.yml` and `TagBot.yml` in `/.github/workflows/`.
    - [ ] Create an empty repository (namely, `https://github.com/okatsn/{{{PKG}}}.jl.git`) on github, and push the local to origin. See [connecting to remote](#tips-for-connecting-to-remote).


## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
{{/HAS_CITATION}}


## Auto-Registration
- You have to add `ACCESS_OKREGISTRY` to the secret under the remote repo (e.g., https://github.com/okatsn/{{{PKG}}}.jl).
- `ACCESS_OKREGISTRY` allows `CI.yml` to automatically register/update this package to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry).

## Doc Test
`pkg> add Documenter` to make doc tests worked.

`doctest` is executed at the following **two** places:
1. In `CI.yml`, `jobs: test: ` that runs `test/runtests.jl`
2. In `CI.yml`, `jobs: docs: ` that runs directly on bash.

It is no harm to run both, or you may manually delete either.

## Tips for connecting to remote
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
