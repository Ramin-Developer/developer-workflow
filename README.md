# developer-workflow

This repository holds reusable workflow standards for my public projects.

## Purpose

The goal of this repository is to keep development practices consistent across my GitHub projects by centralizing reusable workflow artifacts such as editor settings, formatting rules, and documentation guidance.

## How it fits into the workflow

Use this repository as a shared source of truth for:

- coding standards
- editor configuration
- formatting and whitespace rules
- reusable project setup guidance
- shared ignore rules for different repository types

## Canonical configuration

The root `.editorconfig` and `.gitignore` files are the canonical copies for the repositories listed in
`config-repositories.txt`. Root copies in those repositories must remain byte-for-byte identical to these
files.

The `.vscode/settings.json` file is a portable baseline for editor behavior. Merge its shared settings into each
repository's workspace settings instead of replacing the file, because repositories may require project-specific
formatter, build, or extension configuration. Keep fonts, themes, machine paths, credentials, and personal workflow
preferences in VS Code User Settings.

Nested `.editorconfig` files are allowed only for narrowly scoped analyzer overrides. They must inherit from the root
file and must not set `root = true`. Nested `.gitignore` files should be avoided because root ignore patterns apply
recursively.

Check for drift without changing files:

```powershell
./scripts/Sync-RepositoryConfig.ps1 -Check
```

Synchronize all listed local repositories:

```powershell
./scripts/Sync-RepositoryConfig.ps1
```

Use `-RepositoriesRoot` when sibling clones are stored outside the parent directory of this repository.
Synchronization stops if a target root configuration file has uncommitted changes. Use `-Force` only when those
changes are intentionally being replaced.

## Current contents

- .editorconfig — shared formatting and whitespace rules for C#, F#, LaTeX, and MATLAB repositories
- .gitignore — shared ignore rules for .NET/C#, F#, LaTeX, MATLAB, and common tooling artifacts
- .vscode/settings.json — portable VS Code wrapping, whitespace, and language editor defaults
- config-repositories.txt — repositories governed by the canonical root files
- scripts/Sync-RepositoryConfig.ps1 — configuration drift checker and synchronizer

## Next steps

Add new repositories to `config-repositories.txt` when they adopt the shared root configuration.
