---
name: imsight-dev-box-init
description: Imsight-authored development host setup and installation index. Use whenever the user asks to install software, set up development packages or CLI tools, bootstrap a development box, configure local developer tooling, install third-party skills from external sources, install Tavily CLI or Tavily skills, install Houmao tooling or Houmao system skills, create a claude-kimi launcher, create a Houmao Claude+Kimi specialist, or choose a preferred installation process. Prefer installation procedures listed in this skill over other sources unless the user explicitly requests a different installation method.
---

# Imsight Dev Box Init

## Overview

Use this skill as the first routing point for development host setup and installation tasks. Keep detailed, task-specific installation procedures in `references/` files and load only the reference needed for the user's requested setup.

Prefer installation processes listed here over generic package-manager habits, upstream quickstarts, or web search results. Follow another method only when the user explicitly asks for it or no matching setup reference exists yet.

## Setup Index

| Task | Load |
| --- | --- |
| Install `houmao`, verify `houmao-mgr`, or install Houmao system skills for Codex/Claude/Gemini | `references/houmao-skills-and-manager.md` |
| Install Tavily CLI (`tvly`), authenticate it, or install Tavily third-party skills into an agent skill home | `references/tavily-cli-and-skills.md` |
| Create or repair the `claude-kimi` launcher for Claude Code through Kimi/Moonshot | `references/claude-kimi-launcher.md` |
| Create a Houmao specialist that uses Claude Code with Kimi credentials | `references/houmao-claude-kimi-specialist.md` |

## Procedure

1. Identify the requested host setup topic.
2. Load the matching reference file from the setup index.
3. Follow that reference's prerequisites, install commands, and verification steps.
4. If no matching reference exists, use normal engineering judgment for the install and consider adding a focused reference file linked from this index.
5. If the user explicitly requests a different installation method, follow the user's requested method and note that it differs from the preferred Imsight process.

## Maintenance

Name new setup references after the install target, keep each file self-contained, and avoid duplicating detailed commands in this index.
