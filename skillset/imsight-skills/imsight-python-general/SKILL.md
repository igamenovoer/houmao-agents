---
name: imsight-python-general
description: Imsight-authored general Python development command skill. Use when explicitly invoked as imsight-python-general, routed from another Imsight skill, or when the prompt or context mentions `imsight` and asks for Python project setup, Python repo conventions, Pixi-managed Python project structure, packaging layout, source/test/docs/context organization, dependency workflow, lint/type/test operations, or a reusable Imsight Python development standard. Do not invoke for generic Python development tasks that do not mention `imsight`.
---

# Imsight Python General

## Overview

Use this skill as the entrypoint for Imsight Python development practices. Keep detailed procedures in focused subskill references and load only the reference needed for the current task.

## Invocation Contract

- Preferred explicit form: `$imsight-python-general use <subcommand> to do <task>`.
- Task-only form: `$imsight-python-general <task prompt>` means choose the applicable Python subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this Python development skill and list available subcommands | This entrypoint |
| `structure-pixi-project` | Structure or review a Pixi-managed Python project, especially a new src-layout project with tests, docs, context, scripts, and external dependency folders | `references/structure-pixi-project.md` |

## Procedure

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, load the matching reference from the subcommand index.
3. If the request is task-only, choose the applicable Python subcommand from the task.
4. Follow the reference while adapting names and tooling to the existing repository.
5. If no reference exists yet, use normal senior Python engineering judgment and consider adding a focused reference linked from this subcommand index.

## Maintenance

Name new references by operation, keep each one self-contained, and avoid duplicating detailed commands in this entrypoint.
