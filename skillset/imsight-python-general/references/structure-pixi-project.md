# Structure Pixi Python Project

Use this subskill when the task is to initialize, scaffold, review, or normalize a Pixi-managed Python project. It is self-contained: follow the structure, workflow, commands, and checklist below as the complete project-structure guide.

## Workflow

1. Work from the Python project root, not a mega-workspace parent.
2. Check for existing Pixi artifacts before changing files: `pixi.lock`, `pixi.toml`, or `[tool.pixi]` in `pyproject.toml`.
3. If Pixi is already configured, preserve existing dependency constraints and merge structure idempotently.
4. Prefer `pyproject.toml` format unless the user or repo already uses `pixi.toml`.
5. Use `src/` layout for importable code and name the package from the project name by lowercasing and replacing hyphens with underscores, unless the user provides a package name.
6. Keep generated or local-only state out of version control: `.pixi/`, `tmp/`, and `extern/orphan/*`.
7. Prefer `pixi run ...` for project commands.

## Directory Structure

```text
<project-root>/
|-- pyproject.toml
|-- pixi.lock
|-- .gitignore
|-- .github/
|   `-- workflows/
|-- src/
|   `-- <package_name>/
|       `-- __init__.py
|-- extern/
|   |-- .gitignore
|   |-- tracked/
|   `-- orphan/
|-- scripts/
|-- tests/
|   |-- unit/
|   |-- integration/
|   `-- manual/
|-- docs/
|-- context/
|   `-- archived/
`-- tmp/
```

## Directory Roles

- `.github/workflows/`: CI, docs deployment, automated tests, and package build workflows.
- `src/<package_name>/`: importable package code.
- `extern/tracked/`: pinned third-party code, typically Git submodules tracked through `.gitmodules`.
- `extern/orphan/`: local-only clones or checkouts that must not be committed.
- `scripts/`: command-line helpers and one-off project automation.
- `tests/unit/`: fast deterministic tests, mirroring source modules where useful.
- `tests/integration/`: filesystem, service, multi-component, or slower integration checks.
- `tests/manual/`: manually executed checks that should not be collected by CI by default.
- `docs/`: Markdown documentation source, typically suitable for MkDocs Material.
- `context/`: AI assistant working context, design notes, plans, and reference material.
- `context/archived/`: superseded plans and historical notes.
- `tmp/`: disposable working files.

## Standard Files

Create `src/<package_name>/__init__.py` with a short module docstring. Add `extern/.gitignore`:

```gitignore
orphan/*
!orphan/README.md
```

Ensure the project `.gitignore` includes:

```gitignore
.pixi/
tmp/
```

Do not add `.git/` to `.gitignore` unless matching an existing local standard; Git does not need it ignored inside normal repositories.

## Pixi Initialization

For a new project:

```bash
pixi init . --format pyproject -c conda-forge
pixi add python=<version>
pixi add --pypi scipy mdutils ruff mkdocs-material mypy attrs omegaconf imageio
pixi install
```

Choose a Python version compatible with the project and user requirements. When no constraint exists, use a stable modern Python version rather than chasing the newest release automatically.

For an existing project, inspect the manifest first and add only missing dependencies. If `python` is already declared, respect that version unless the user asks to change it.

## Review Checklist

- Project commands are run from the project root.
- Pixi configuration exists in the selected manifest format.
- Package name and `src/<package_name>` agree.
- Tests are split into unit, integration, and manual when those categories exist.
- External dependency folders distinguish tracked submodules from local-only clones.
- `.pixi/`, `tmp/`, and `extern/orphan/*` are ignored.
- Documentation and AI context have distinct homes.
