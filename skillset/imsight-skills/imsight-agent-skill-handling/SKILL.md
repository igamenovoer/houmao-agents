---
name: imsight-agent-skill-handling
description: Manual invocation only; Imsight-authored command skill for analyzing or formatting Codex, Houmao, or Imsight agent skills. Use only when the user explicitly invokes imsight-agent-skill-handling or asks to use this exact skill. Its subcommands are help, analyze, and format-skill. Do not invoke implicitly for generic skill creation, skill audits, skill updates, Imsight-scoped skill-format work, routing from another Imsight skill, generic coding tasks, or ordinary use of a domain skill.
---

# Imsight Agent Skill Handling

## Overview

Use this skill as the manual Imsight entrypoint for analyzing and formatting agent skills. It reconstructs a skill's operational logic and durable outputs, writes analysis report sets, and can revise a target skill so its structure conforms to the bundled Imsight skill style guide.

## Workflow

When this skill is invoked, execute the following steps in order.

1. **Select the subcommand** from the **Subcommands** table. If no subcommand or actionable task is present, handle `help`.
2. **Resolve the target skill folder** when the subcommand is `analyze` or `format-skill`. See **Target Skill Folder**.
3. **Load the selected reference** and follow its `## Workflow`.
4. **Produce the requested result**. For `analyze`, write the analysis report set into `<output-dir>`. For `format-skill`, edit the target skill in place and summarize changed files.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan from the subcommands and constraints in this skill, then execute the plan.

## Invocation Contract

- Preferred explicit form: `$imsight-agent-skill-handling use <subcommand> to do <task>`.
- Task-only form: `$imsight-agent-skill-handling <task prompt>` means choose the applicable subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.
- Do not use this skill unless the user explicitly names it.

## Output Contract

By default, `analyze` writes Markdown report files under `<output-dir>` and returns a brief in-chat response using the chat template.

By default, `format-skill` edits the target skill files in place and writes no analysis report. It returns a brief chat summary with changed files, validations run, and any style issues left unresolved.

For `analyze`, resolve `<output-dir>` in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/agent-skill-handling/analysis/<target-skill-name>/`.

Write reports using these names:

- Primary `SKILL.md` entrypoint report: `<output-dir>/ENTRYPOINT.md`.
- Multi-part skill reports: `<output-dir>/<subskill-or-subcommand-name>.md` for each public subskill, subcommand, mode, workflow, or primitive page that deserves its own analysis.

Normalize non-entrypoint report file names to lowercase hyphen-case. `ENTRYPOINT.md` is the fixed uppercase filename for the primary `SKILL.md` report. Prefer the public subcommand or subskill name over the source file stem when they differ.

This contract does not replace intentional edits inside the target skill folder.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this skill and list available subcommands | This entrypoint |
| `analyze` | Analyze a given skill's workflow logic and durable outputs, then write Mermaid-based Markdown reports and return a brief ASCII workflow summary in chat | `references/analyze.md` |
| `format-skill` | Revise a given skill so its structure conforms to the bundled Imsight skill style guide | `references/format-skill.md` |

## Target Skill Folder

Use the skill folder explicitly provided by the user. If none is provided:

1. If the prompt names a skill, search the current project and known skill homes for an exact folder or frontmatter `name` match.
2. Otherwise, use the current working directory if it contains `SKILL.md`.
3. If multiple candidates remain, ask the user which skill to target.

Do not analyze or format a parent skillset directory as a single skill unless the user explicitly asks for a suite-level operation.

## Maintenance

Keep this entrypoint as a small router. Add detailed procedures to subcommand references. Keep the bundled style rules in `references/imsight-skill-style-guide.md` so this skill does not depend on files outside its own directory.
