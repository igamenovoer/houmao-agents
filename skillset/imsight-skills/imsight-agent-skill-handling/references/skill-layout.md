# Agent Skill Layout

This page documents the standard skill directory layout, based on the OpenAI skill-creator guide, plus the local Imsight conventions used by skills in this repository.

## Standard Layout

A skill is a self-contained folder. At minimum it must contain a `SKILL.md` file. Everything else is optional and should only be created when the skill actually needs it.

```text
<skill-name>/
├── SKILL.md          # Required. YAML frontmatter + Markdown instructions.
├── agents/           # Recommended. Runtime UI metadata.
│   └── openai.yaml
└── Bundled Resources # Optional. Only create directories the skill needs.
    ├── scripts/      # Executable code (Python, Bash, etc.)
    ├── references/   # Documentation loaded into context as needed
    └── assets/       # Files used in output (templates, icons, fonts, etc.)
```

### `SKILL.md` (required)

- **Frontmatter** (YAML): `name` and `description`. These are the only fields Codex reads to decide whether to trigger the skill.
- **Body** (Markdown): Instructions and guidance. Loaded only after the skill triggers.

### `agents/openai.yaml` (recommended)

UI-facing metadata for skill lists and chips. Contains:

- `interface`: `display_name`, `short_description`, `default_prompt`
- `policy`: e.g., `allow_implicit_invocation`

Generate this file from the skill content rather than hardcoding it. Do not include optional interface fields (icons, brand color, etc.) unless explicitly provided.

Template:

```yaml
interface:
  display_name: "<Human-readable skill name>"
  short_description: "<One-line summary of what the skill does>"
  default_prompt: "Use $<skill-name> use help to see available subcommands, or use a specific subcommand to <do the thing>."
policy:
  allow_implicit_invocation: false
```

### `scripts/` (optional)

Executable code for tasks that require deterministic reliability or are repeatedly rewritten. Example: `scripts/rotate_pdf.py`.

Only create this directory when the skill actually bundles executable code.

### `references/` (optional)

Documentation intended to be loaded into context as needed. Examples: schemas, API docs, policies, detailed workflow guides.

Keep `SKILL.md` lean by moving detailed reference material here. Avoid duplication: information should live in either `SKILL.md` or a references file, not both.

### `assets/` (optional)

Files used in the output Codex produces, not loaded into context. Examples: templates, images, fonts, boilerplate code.

## What Not to Include

Do not create extraneous documentation or auxiliary files such as:

- `README.md`
- `INSTALLATION_GUIDE.md`
- `QUICK_REFERENCE.md`
- `CHANGELOG.md`

A skill should contain only the files needed for an AI agent to do its job.

## Imsight Local Conventions

In addition to the standard layout, Imsight skills in this repository organize subcommand detail pages under:

- `commands/`

Link these pages from the `## Subcommands` table in `SKILL.md`.
