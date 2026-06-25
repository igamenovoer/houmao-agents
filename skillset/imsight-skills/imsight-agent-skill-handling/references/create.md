# Create Skill

## Workflow

Use this reference to create a new skill from a user request. Because `imsight-agent-skill-handling` is manually invoked, respect the user's intent: do not force a failing baseline or a post-creation verification run. Capture what the user wants, choose the right shape for the skill, write a minimal and format-compliant `SKILL.md`, validate its structure, and return a brief summary. Leave pressure testing to the explicit `test` subcommand.

1. **Confirm the task and locate the skill home**. See **Skill Home**.
2. **Capture intent** from the user's request and conversation history. See **Intent Capture**.
3. **Classify the skill type** based on what it must do. See **Skill Type**.
4. **Choose the subcommand structure flavor** if the skill needs subcommands. See **Subcommand Structure**.
5. **Author a minimal `SKILL.md`** that captures the requested behavior and is already format-compliant. See **Authoring the Skill**.
6. **Validate** the skill frontmatter and structure. See **Validation**.
7. **Return a brief in-chat summary** that lists the files written and the validation result.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan from the available writing guidance and the user's request, then execute the plan.

## Skill Home

Use the skill home explicitly provided by the user. Agent runtimes typically discover skills at runtime through `.agents/skills/`, which may be a real folder or a symlink to a committed skill location such as `skillset/`.

- If the user provides a target path, use it as the skill home.
- Otherwise, default to `.agents/skills/<skill-name>/` under the current project root.
- If the directory does not exist, create it.

## Intent Capture

Start by understanding what the user wants the skill to do. If the current conversation already contains a workflow the user wants to capture (for example, "turn this into a skill"), extract answers from the conversation history first: the tools used, the sequence of steps, corrections the user made, and input/output formats observed.

Resolve these questions before writing:

1. What should this skill enable the agent to do?
2. When should this skill be invoked? (user phrases or contexts)
3. What is the expected output format?

Confirm the answers with the user before proceeding to the next step.

## Skill Type

Choose the type that best matches the skill's purpose:

| Type | Description | Example |
| --- | --- | --- |
| Technique | Concrete method with steps to follow | condition-based-waiting |
| Pattern | Way of thinking about problems | flatten-with-flags |
| Reference | API docs, syntax guides, tool documentation | office docs |
| Discipline-enforcing | Rules that agents might rationalize away | TDD, verify-before-completion |

The skill type determines how you test and harden it.

## Subcommand Structure

If the skill needs subcommands, choose the structure from the skill's functionality.

Use the collection-of-routines flavor when subcommands are peer routines, tools, or functions and their calling order is absent, flexible, or task-specific. Write one plain `## Subcommands` section with a table.

Use the complex-procedure flavor when the skill describes a multi-step procedure, each step may have its own sub-workflow or reference page, and some steps depend on artifacts produced by earlier steps. Split `## Subcommands` into:

- `### Procedural Subcommands` for user-facing workflow steps.
- `### Helper Subcommands` for lower-level implementation commands called by procedural subcommands.
- `### Misc Subcommands` for `help` and public shortcuts such as `fast-forward` or `step-by-step`.

For complex-procedure skills, put procedural subcommands in user-facing workflow order, keep helper subcommands out of help output unless promoted, and say `No helper subcommands are currently exposed.` when the helper group is empty.

## Authoring the Skill

Write a minimal `SKILL.md` that captures the user's request. Write it in format-compliant form from the start; do not rely on a later `format` pass to fix structure or description.

### Required Frontmatter

```yaml
---
name: <skill-name>
description: Use when <specific triggering conditions and symptoms>
---
```

Rules for the frontmatter:

- `name` must use letters, numbers, and hyphens only.
- `description` must start with "Use when..." and describe triggering conditions only. Do not summarize the workflow.
- Keep the description under 500 characters if possible, 1024 maximum.
- Write in third person.
- Include keywords agents would search for: error messages, symptoms, tools, library names.

### Required Sections

1. **## Overview** — core principle in 1-2 sentences.
2. **## When to Use** — symptoms and contexts that trigger this skill. Include when NOT to use.
3. **## Workflow** or **Core Pattern** — the technique, pattern, or rule the agent must follow.
4. **## Common Mistakes** — what goes wrong and how to fix it.

Write the workflow as numbered steps. Keep each step concise and point to a detail section when it needs more explanation. End with a fallback for freeform tasks. Move long procedural detail, examples, edge cases, and configuration notes out of the workflow into dedicated sections or `references/<page>.md` files.

When the skill has subcommands, apply **Subcommand Structure** before writing the `## Subcommands` section. Do not use the three-type split for a simple collection of unordered routines.

For discipline-enforcing skills, also include:

- A foundational principle such as "Violating the letter of the rules is violating the spirit of the rules."
- A rationalization table.
- A red flags list.

### Form That Matches the Purpose

Choose the guidance form based on what the skill must prevent or produce:

| Problem the skill solves | Right form |
| --- | --- |
| Skips/violates a rule under pressure | Prohibition + rationalization table + red flags |
| Output has wrong shape | Positive recipe or contract: state what the output IS |
| Omits a required element | Structural: REQUIRED field or slot in template |
| Behavior should depend on a condition | Conditional keyed to an observable predicate |

Keep the skill concise. One excellent example beats many mediocre ones.

## Validation

Validate the skill before finishing:

1. Confirm `SKILL.md` exists and has valid YAML frontmatter with `name` and `description`.
2. Confirm `name` matches the directory name for project-scoped skills.
3. Confirm the description starts with "Use when...", is in third person, and does not summarize the workflow.
4. Confirm the overview, when-to-use, and workflow/core-pattern sections exist.
5. Confirm the workflow is a concise numbered list with a freeform fallback.
6. Confirm long detail has been moved out of the workflow into dedicated sections or reference pages.
7. If subcommands exist, confirm the selected subcommand structure flavor matches the skill functionality.
8. If a skill validator such as `skill-creator/scripts/quick_validate.py` is available, run it on the target skill folder.

Report any validation failures and fix them before returning the summary.

## Pressure Testing

Do not run pressure scenarios as part of `create`. After the skill is written, the user can run the `test` subcommand explicitly to baseline natural failure or verify compliance. If the user wants a failing baseline before writing, invoke `test` in baseline mode first, then run `create`, then invoke `test` in verify mode.

## Output Contract

By default, `create` writes files inside the target skill folder and returns a brief chat summary. It does not produce analysis reports under `<output-dir>`.

The chat summary must include:

- The skill folder path.
- The skill type chosen.
- Files written or changed.
- Validation result.
- Next recommended step (for example, run `test` pressure scenarios or hand off for review).
