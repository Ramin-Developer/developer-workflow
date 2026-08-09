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

## Using the shared templates

Copy `.editorconfig` and `.gitignore` from this repository into other projects when you want the same formatting, whitespace, and ignore conventions.

Example:

```bash
git clone https://github.com/Ramin-Developer/developer-workflow.git
cp developer-workflow/.editorconfig ./your-project/.editorconfig
cp developer-workflow/.gitignore ./your-project/.gitignore
```

## Current contents

- .editorconfig — shared formatting and whitespace rules for C#, F#, LaTeX, and MATLAB repositories
- .gitignore — shared ignore rules for .NET/C#, F#, LaTeX, MATLAB, and common tooling artifacts

## Next steps

This repository is intended to be reused as a top-level workflow standard across future public projects and existing repositories.
