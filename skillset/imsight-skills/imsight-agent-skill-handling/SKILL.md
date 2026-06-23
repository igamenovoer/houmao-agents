---
name: imsight-agent-skill-handling
description: Manual invocation only; Imsight-authored command skill for analyzing, writing, or formatting agent skills. Use only when the user explicitly invokes imsight-agent-skill-handling or asks to use this exact skill. Its subcommands are help, analyze, write-skill, and format-skill. Do not invoke implicitly for generic skill creation, skill audits, skill updates, skill-format work, routing from another skill, generic coding tasks, or ordinary use of a domain skill.
---

# Imsight Agent Skill Handling

## Overview

Use this skill as the manual entrypoint for analyzing, writing, and formatting agent skills. It reconstructs a skill's operational logic and durable outputs, writes analysis report sets, creates new skills from user requests, and can revise a target skill so its structure conforms to the bundled skill style guide.

## Workflow

When this skill is invoked, execute the following steps in order.

1. **Select the subcommand** from the **Subcommands** table. If no subcommand or actionable task is present, handle `help`.
2. **Resolve the target skill folder** when the subcommand is `analyze`, `write-skill`, or `format-skill`. See **Target Skill Folder**.
3. **Load the selected reference** and follow its `## Workflow`.
4. **Produce the requested result** following the selected subcommand's workflow and output contract.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan from the subcommands and constraints in this skill, then execute the plan.

## Invocation Contract

- Preferred explicit form: `$imsight-agent-skill-handling use <subcommand> to do <task>`.
- Task-only form: `$imsight-agent-skill-handling <task prompt>` means choose the applicable subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.
- Do not use this skill unless the user explicitly names it.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this skill and list available subcommands | This entrypoint |
| `analyze` | Analyze a given skill's workflow logic and durable outputs, then write Mermaid-based Markdown reports and return a brief ASCII workflow summary in chat | `references/analyze.md` |
| `write-skill` | Create a new skill from a user request or rewrite an existing skill draft so it is ready for testing | `references/write-skill.md` |
| `format-skill` | Revise a given skill so its structure conforms to the bundled skill style guide | `references/format-skill.md` |

## Target Skill Folder

Use the skill folder explicitly provided by the user. If none is provided:

1. If the prompt names a skill, search the current project and known skill homes for an exact folder or frontmatter `name` match.
2. Otherwise, use the current working directory if it contains `SKILL.md`.
3. If multiple candidates remain, ask the user which skill to target.

Do not analyze or format a parent skillset directory as a single skill unless the user explicitly asks for a suite-level operation.

## Maintenance

Keep this entrypoint as a small router. Add detailed procedures to subcommand references. Keep the bundled style rules in `references/imsight-skill-style-guide.md` so this skill does not depend on files outside its own directory.
