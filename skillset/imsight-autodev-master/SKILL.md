---
name: imsight-autodev-master
description: Manual invocation only; Imsight-authored master-agent dispatch entrypoint for sending OpenSpec-oriented development requests to Houmao-managed slave agents. Use only when explicitly invoked as imsight-autodev-master or when asked to dispatch a maintained master subcommand such as inspect-slave, init-slave-for-openspec, openspec-one-pass, openspec-explore, openspec-propose, openspec-apply-change, or openspec-archive-change to a slave agent.
---

# Imsight Autodev Master

Use this skill only when the user explicitly invokes `imsight-autodev-master` or asks to use this exact skill. Do not activate it implicitly for ordinary development tasks.

This skill is a master-agent entrypoint. The master agent may be any capable caller, but the target slave is expected to be a Houmao-managed agent. Keep this file small; reusable behavior belongs in subskill pages.

## Operations

- `inspect-slave`: Inspect a Houmao-managed slave agent through supported read-only Houmao surfaces and recover dispatch metadata.
- `init-slave-for-openspec`: Ask a slave to initialize `openspec/` in its own target workdir when missing.
- `openspec-one-pass`: Send one full lifecycle request to `imsight-autodev-slave openspec-one-pass`.
- `openspec-explore`: Send an explore-only OpenSpec request to the slave.
- `openspec-propose`: Send an OpenSpec proposal request to the slave.
- `openspec-apply-change`: Send an OpenSpec implementation request to the slave.
- `openspec-archive-change`: Send an OpenSpec archive/finalization request to the slave.

## Workflow

1. Identify the requested master operation.
2. If the operation sends work to a slave, read [subskills/inspect-slave.md](subskills/inspect-slave.md) first.
3. Read the matching operation subskill:
   - `inspect-slave`: [subskills/inspect-slave.md](subskills/inspect-slave.md)
   - `init-slave-for-openspec`: [subskills/init-slave-for-openspec.md](subskills/init-slave-for-openspec.md)
   - `openspec-one-pass`: [subskills/openspec-one-pass.md](subskills/openspec-one-pass.md)
   - `openspec-explore`: [subskills/openspec-explore.md](subskills/openspec-explore.md)
   - `openspec-propose`: [subskills/openspec-propose.md](subskills/openspec-propose.md)
   - `openspec-apply-change`: [subskills/openspec-apply-change.md](subskills/openspec-apply-change.md)
   - `openspec-archive-change`: [subskills/openspec-archive-change.md](subskills/openspec-archive-change.md)
4. If the operation, target slave, or request body is missing or ambiguous, ask for the smallest clarification needed.
5. After a request is accepted or delivered to the slave, finish the turn by default.

## Guardrails

- Do not guess the slave agent selector, tool lane, gateway posture, mailbox posture, or delivery lane.
- Prefer supported Houmao inspection and messaging surfaces over direct runtime file searches.
- For Codex-based slaves, render OpenSpec commands with `$openspec-*` and the slave mega-skill command as `$imsight-autodev-slave`.
- For Claude-based slaves, render OpenSpec commands with `/openspec-*` and the slave mega-skill command as `/imsight-autodev-slave`.
- For mail-based messaging, include the rendered invocation command in the mail body so it appears in the notification text.
- Do not initialize or copy files into the slave workdir directly; dispatch the initialization request to the slave.
- Do not wait for or inspect the slave's follow-up, gateway state, mailbox state, TUI output, or results unless the user explicitly asks.
