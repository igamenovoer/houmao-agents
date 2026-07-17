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

- **Frontmatter** (YAML): `name` and `description`. These are the only fields Codex reads to decide whether to trigger the skill. Imsight skills may add optional keys such as `skill_invocation_notation`; see **Skill Invocation Notation** under **Imsight Local Conventions**.
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

### `subskills/` (optional)

Imsight skills add one more hierarchy level to the standard layout: a skill may bundle nested skills under `subskills/`. Each subskill is a self-contained skill folder with its own required `SKILL.md` and the same optional bundled resources (`agents/`, `references/`, `commands/`, `scripts/`, `assets/`).

```text
<skill-name>/
├── SKILL.md
└── subskills/
    └── <subskill-name>/
        ├── SKILL.md          # Required. The subskill's own entrypoint.
        └── ...               # Optional. Same bundled resources as a top-level skill.
```

Read the structure with object semantics: treat the main skill as an object and its `SKILL.md` as the object's `()` operator. A subskill is an inner object of the main skill: a member capability scoped to and owned by the parent skill, not independently installed or discovered. Use a subskill when a capability is large or self-contained enough to be a full skill but only meaningful as part of the parent; keep ordinary subcommand procedures on `commands/` or `references/` detail pages.

The parent skill owns routing to its subskills. List bundled subskills in the `## Subcommands` table or a dedicated `## Subskills` section of the parent `SKILL.md` so the entrypoint can resolve invocation designators.

### Skill Invocation Notation

Skills designate skill and subskill invocations with object-style notation. The notation extends the plain convention other writers already use, so prefer the plain form whenever context makes the target clear:

- Skill-to-skill invocation: write "invoke skill `X`" or "invoke skill `X->Y->Z`". The bare path invokes the named skill or subskill entrypoint (its `SKILL.md`). This is the public convention; the explicit `()` forms below are a well-defined calling syntax with the same meaning.
- Skill-to-subcommand invocation: write "invoke skill subcommand `X->cmd()`" for a subcommand of skill `X`, "invoke skill subcommand `X->Y->cmd()`" for a subcommand of subskill `Y` inside skill `X`, and "invoke subcommand `cmd()`" for a subcommand of the current skill. Prefer keeping the `()` on the subcommand symbol; omit it only when context already makes clear which symbol is the subcommand.
- Explicit forms: when a symbol appears without enough context to tell a skill from a subcommand, prefer the explicit form, such as `X()` or `X->Y()` for a skill or subskill entrypoint and `X->cmd()` or `X->Y->cmd()` for a subcommand.

Any skill or subcommand page that uses these designators must declare the notation in its YAML frontmatter with the `skill_invocation_notation` key. See [imsight-skill-style-guide.md](imsight-skill-style-guide.md) for the rule and the standard frontmatter value.
