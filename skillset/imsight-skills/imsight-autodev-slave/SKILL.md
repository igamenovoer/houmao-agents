---
name: imsight-autodev-slave
description: Manual invocation only; Imsight-authored slave-agent automation entrypoint for Houmao-managed agents that receive and process explicit master-agent requests. Use when a prompt, gateway message, mailbox notification, direct command, another Imsight skill route, or relevant `imsight` context names imsight-autodev-slave for a maintained request-processing workflow such as init-openspec or OpenSpec one-pass explore, propose, apply, sync, and archive.
---

# Imsight Autodev Slave

Use this skill only when explicitly invoked by name. Explicit invocation may come from a human/operator or from a master agent using the slave tool's native skill invocation syntax, such as `$imsight-autodev-slave ...` for Codex or `/imsight-autodev-slave ...` for Claude.

Do not activate it implicitly for ordinary development tasks that do not name `imsight-autodev-slave` or one of its maintained operations.

This skill is an entrypoint for a slave agent that receives a master's request, selects the matching maintained subskill, and processes the request through that subskill. Keep `SKILL.md` small; reusable behavior belongs in subskill pages.

## Invocation Contract

- Preferred explicit form: `$imsight-autodev-slave use <subcommand> to do <task>`.
- Task-only form: `$imsight-autodev-slave <task prompt>` means choose the applicable subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes slave-side notes, reports, manifests, or other skill-owned auxiliary artifacts, choose the output directory in this order:

1. Use the output location explicitly provided by the user or master request.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/autodev-slave/`.

This contract does not relocate OpenSpec changes, implementation edits, or initialized `openspec/` trees; those stay in the target workdir required by the selected OpenSpec workflow.

## Subcommands

- `help`: Explain this slave request-processing skill and list available subcommands.
- `openspec-one-pass`: Given one master-provided development request, run an OpenSpec lifecycle in one pass: explore, propose, apply, sync, and archive. Use [subskills/openspec-one-pass.md](subskills/openspec-one-pass.md).
- `init-openspec`: Initialize `openspec/` in the slave's current target workdir when missing. Use [subskills/init-openspec.md](subskills/init-openspec.md).

## Workflow

1. Read the master's request and identify the requested slave subcommand.
2. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
3. If the request is task-only, choose the applicable subcommand from the task.
4. If the subcommand is `openspec-one-pass`, read [subskills/openspec-one-pass.md](subskills/openspec-one-pass.md).
5. If the subcommand is `init-openspec`, read [subskills/init-openspec.md](subskills/init-openspec.md).
6. If the subcommand or required request body is ambiguous, ask for the smallest clarification needed.
7. Do not invent additional workflow stages in this entrypoint; add a new subskill page when a new slave operation becomes reusable.

## Guardrails

- Preserve the master's request text and carry it through the selected subskill workflow.
- Prefer maintained OpenSpec skills over ad hoc artifact editing when an OpenSpec operation is requested.
- Keep implementation, verification, sync, and archiving scoped to the current repository or explicitly provided workspace.
- Stop and report clearly if a required OpenSpec skill is unavailable, an OpenSpec command fails, or the repository does not contain the expected OpenSpec structure.
