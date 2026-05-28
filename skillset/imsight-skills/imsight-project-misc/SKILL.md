---
name: imsight-project-misc
description: Imsight-authored generic development project task router. Use when explicitly invoked as imsight-project-misc, routed from another Imsight skill, or when the prompt or context mentions `imsight` and asks to set up miscellaneous project infrastructure, development project utilities, project-local Docker services, Docker Compose service folders, or other generic project support tasks that do not fit a more specific Imsight skill. Do not invoke for generic project or Docker tasks that do not mention `imsight`.
---

# Imsight Project Misc

## Overview

Use this skill as a router for miscellaneous generic development project tasks. Keep `SKILL.md` as a first-level subcommand index and place detailed second-level subskill pages in `references/`.

## Invocation Contract

- Preferred explicit form: `$imsight-project-misc use <subcommand> to do <task>`.
- Task-only form: `$imsight-project-misc <task prompt>` means choose the applicable subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Project Directory

Use the project directory explicitly provided by the user. If none is provided, use the current working directory after confirming it is the intended project root when the task would create files.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this miscellaneous project skill and list available subcommands | This entrypoint |
| `docker-service-setup` | Create project-local Docker service files under `<project-dir>/dockers/<service-name>/...` | `references/docker-service-setup.md` |

## Procedure

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, load that subcommand's reference file.
3. If the request is task-only, choose the applicable subcommand from the task.
4. Follow the selected reference's discovery, file layout, implementation, and verification steps.
5. If no matching subcommand exists, use normal engineering judgment and consider adding a focused reference file linked from this subcommand index.

## Maintenance

Name new subskill references after the first-level subcommand, keep each reference self-contained, and avoid duplicating detailed workflows in this index.
