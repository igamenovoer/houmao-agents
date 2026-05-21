---
name: imsight-autodev-slave
description: Manual invocation only; Imsight-authored slave-agent automation entrypoint for Houmao-managed agents that receive and process explicit master-agent requests. Use when a prompt, gateway message, mailbox notification, or direct command names imsight-autodev-slave using the target tool's native invocation method, or asks to use this exact skill for a maintained request-processing workflow such as init-openspec or OpenSpec one-pass explore, propose, apply, sync, and archive.
---

# Imsight Autodev Slave

Use this skill only when explicitly invoked by name. Explicit invocation may come from a human/operator or from a master agent using the slave tool's native skill invocation syntax, such as `$imsight-autodev-slave ...` for Codex or `/imsight-autodev-slave ...` for Claude.

Do not activate it implicitly for ordinary development tasks that do not name `imsight-autodev-slave` or one of its maintained operations.

This skill is an entrypoint for a slave agent that receives a master's request, selects the matching maintained subskill, and processes the request through that subskill. Keep `SKILL.md` small; reusable behavior belongs in subskill pages.

## Operations

- `openspec-one-pass`: Given one master-provided development request, run an OpenSpec lifecycle in one pass: explore, propose, apply, sync, and archive.
- `init-openspec`: Initialize `openspec/` in the slave's current target workdir when missing.

## Workflow

1. Read the master's request and identify the requested slave operation.
2. If the operation is `openspec-one-pass`, read [subskills/openspec-one-pass.md](subskills/openspec-one-pass.md).
3. If the operation is `init-openspec`, read [subskills/init-openspec.md](subskills/init-openspec.md).
4. If the operation is missing or ambiguous, ask for the smallest clarification needed.
5. Do not invent additional workflow stages in this entrypoint; add a new subskill page when a new slave operation becomes reusable.

## Guardrails

- Preserve the master's request text and carry it through the selected subskill workflow.
- Prefer maintained OpenSpec skills over ad hoc artifact editing when an OpenSpec operation is requested.
- Keep implementation, verification, sync, and archiving scoped to the current repository or explicitly provided workspace.
- Stop and report clearly if a required OpenSpec skill is unavailable, an OpenSpec command fails, or the repository does not contain the expected OpenSpec structure.
