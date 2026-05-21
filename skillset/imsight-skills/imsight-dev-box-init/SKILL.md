---
name: imsight-dev-box-init
description: Imsight-authored development host setup and installation command index. Use when explicitly invoked as imsight-dev-box-init, routed from another Imsight skill, or when the prompt or context mentions `imsight` and asks to install software, set up development packages or CLI tools, bootstrap a development box, configure local developer tooling, install Tavily or Houmao tooling, create a claude-kimi launcher, create a Houmao Claude+Kimi specialist, or choose an Imsight-preferred installation process. Do not invoke for generic installation or dev-box setup tasks that do not mention `imsight`.
---

# Imsight Dev Box Init

## Overview

Use this skill as the first routing point for development host setup and installation tasks. Keep detailed, task-specific installation procedures in `references/` files and load only the reference needed for the user's requested setup.

Prefer installation processes listed here over generic package-manager habits, upstream quickstarts, or web search results. Follow another method only when the user explicitly asks for it or no matching setup reference exists yet.

## Invocation Contract

- Preferred explicit form: `$imsight-dev-box-init use <subcommand> to do <task>`.
- Task-only form: `$imsight-dev-box-init <task prompt>` means choose the applicable setup subcommand from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes setup notes, manifests, reports, downloaded source packs, or other skill-owned artifacts, choose the output directory in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/dev-box-init/`.

This contract does not replace intentional install destinations such as tool homes, project overlays, `$HOME/.local/bin`, or agent skill homes requested by the selected setup workflow.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- |
| `help` | Explain this dev-box setup skill and list available subcommands | This entrypoint |
| `houmao-setup` | Install `houmao`, verify `houmao-mgr`, or install Houmao system skills for Codex/Claude/Gemini | `references/houmao-skills-and-manager.md` |
| `tavily-setup` | Install Tavily CLI (`tvly`), authenticate it, or install Tavily third-party skills into an agent skill home | `references/tavily-cli-and-skills.md` |
| `claude-kimi-launcher` | Create or repair the `claude-kimi` launcher for Claude Code through Kimi/Moonshot | `references/claude-kimi-launcher.md` |
| `houmao-claude-kimi-specialist` | Create a Houmao specialist that uses Claude Code with Kimi credentials | `references/houmao-claude-kimi-specialist.md` |

## Procedure

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, load that subcommand's reference file.
3. If the request is task-only, choose the applicable setup subcommand from the task.
4. Follow that reference's prerequisites, install commands, and verification steps.
5. If no matching reference exists, use normal engineering judgment for the install and consider adding a focused reference file linked from this subcommand index.
6. If the user explicitly requests a different installation method, follow the user's requested method and note that it differs from the preferred Imsight process.

## Maintenance

Name new setup references after the install target, keep each file self-contained, and avoid duplicating detailed commands in this index.
