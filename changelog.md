# Changelog
## v0.1.1
Initiating the project.

## v0.2.1
- Macro for quickly generating a package
- With default values set by redefine `OkPkgTemplates.DEFAULT_...` functions. See default values in `myplugins.jl`
- Path for package developing or templating are validated at different machine; also add some check in test.
- Documentation.

## v0.2.4
Merge branch 'ci-trigger-workflow' into main
- Clean up
- Separate registration action out from CI to register.yml
- Trigger TagBot instead of waiting for 60s

## v0.3.2
Read the latest commit message as a part of the release note.

## v0.3.3
Read the `changelog.md` as a part of the release note.

## v0.4.0
- `@genpkg` and `@upactions` now generate or update `changelog.md`.
- CI (namely `register.yml`) now reads `changelog.md` and pass the content to TagBot as part of the release note.
- Fix the undesired escape of line break (`\n`) in reading the `changelog.md` as a part of the release note.
- Instructions for defining `GITHUB_OUTPUT` in `register.yml`, with some bash script explanation.

## v0.4.1
- Fix the error originates from "quote" in `changelog.md` by escaping it using `OkExpressions.print_raw`.

## v0.4.4
- upgrade from `checkout@v2` to `checkout@v3` (v0.4.4)
- Use `OkRegistrator`, `okatsn/get-changelog@v1` and `okatsn/add-registry@v2` for add OkRegistry and generate release note from local changelog (v0.4.3)

## v0.5.0

- julia version compatibility to 1.9

## v0.6.0

- Interface of `@genpkg` has changed.

## v0.6.1

- Interface of `@upactions` has changed.
- A fatal error fixed.

## v0.6.3

- Fix error in `upctions` and `update`.