---
name: imsight-project-automation
description: Use when the user wants to automate a development-project task through a maintained one-pass workflow, such as OpenSpec explore-propose-apply-sync-archive, inside the current repository. Triggered by explicit invocation or when a prompt names imsight-project-automation and requests a supported automation routine.
---

# Imsight Project Automation

## Overview

This skill is an entrypoint for running focused project-automation routines in a single pass. Keep `SKILL.md` small; reusable behavior belongs in subskill pages.

## When to Use

Use this skill only when explicitly invoked by name or when the request clearly targets a maintained automation routine, such as:

- a request to run OpenSpec explore, propose, apply, sync, and archive in one pass,
- explicit mention of `imsight-project-automation` or one of its subcommands,
- a routed command or message that names this skill as the handler.

Do not activate it implicitly for ordinary development tasks that do not name `imsight-project-automation` or one of its maintained operations.

## Invocation Contract

- Preferred explicit form: `$imsight-project-automation use <subcommand> to do <task>`.
- Task-only form: `$imsight-project-automation <task prompt>` means choose the applicable subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes skill-owned auxiliary artifacts, choose the output directory in this order:

1. Use the output location explicitly provided by the user or request.
2. Otherwise, use `IMSIGHT_PROJECT_AUTOMATION_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/project-automation/`.

This contract does not relocate OpenSpec changes, implementation edits, or initialized `openspec/` trees; those stay in the target workdir required by the selected OpenSpec workflow.

## Subcommands

| Subcommand | Use For | Detail |
| --- | --- | --- |
| `help` | Explain this skill and list public subcommands | This entrypoint |
| `openspec-one-pass` | Given one development request, run an OpenSpec lifecycle in one pass: explore, propose, apply, sync, and archive. | [commands/openspec-one-pass.md](commands/openspec-one-pass.md) |

## Workflow

When this skill is invoked, execute the following steps in order.

1. **Read the request** and identify the requested subcommand.
2. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
3. If the request is task-only, choose the applicable subcommand from the task.
4. If the subcommand is `openspec-one-pass`, read [commands/openspec-one-pass.md](commands/openspec-one-pass.md).
5. If the subcommand or required request body is ambiguous, ask for the smallest clarification needed.
6. Do not invent additional workflow stages in this entrypoint; add a new subskill page when a new automation routine becomes reusable.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan using the subcommands and constraints provided by this skill, then execute the plan.

## Common Mistakes

- Routing ordinary ad-hoc tasks through this skill instead of handling them directly.
- Skipping the subskill page and inlining a complex automation workflow in `SKILL.md`.
- Inventing unsupported subcommands that are not backed by a subskill page.
