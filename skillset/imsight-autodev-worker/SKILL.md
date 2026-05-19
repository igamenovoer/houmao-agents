---
name: imsight-autodev-worker
description: Manual invocation only; Imsight-authored worker-side development automation operations for agents that receive implementation tasks and execute them. Use only when the user explicitly invokes imsight-autodev-worker or asks to use this exact skill for a maintained task workflow such as OpenSpec one-pass explore, propose, apply, sync, and archive.
---

# Imsight Autodev Worker

Use this skill only when the user explicitly invokes `imsight-autodev-worker` or asks to use this exact skill. Do not activate it implicitly for ordinary development tasks.

This skill is an entrypoint. Keep `SKILL.md` small and load the matching subskill for the requested worker operation.

## Operations

- `openspec-one-pass`: Given one development task, run an OpenSpec lifecycle in one pass: explore, propose, apply, sync, and archive.

## Workflow

1. Identify the requested worker operation.
2. If the operation is `openspec-one-pass`, read [subskills/openspec-one-pass.md](subskills/openspec-one-pass.md).
3. If the operation is missing or ambiguous, ask for the smallest clarification needed.
4. Do not invent additional workflow stages in this entrypoint; add a new subskill page when a new worker operation becomes reusable.

## Guardrails

- Preserve the user's development task text and carry it through the workflow.
- Prefer maintained OpenSpec skills over ad hoc artifact editing when an OpenSpec operation is requested.
- Keep implementation, verification, sync, and archiving scoped to the current repository or explicitly provided workspace.
- Stop and report clearly if a required OpenSpec skill is unavailable, an OpenSpec command fails, or the repository does not contain the expected OpenSpec structure.
