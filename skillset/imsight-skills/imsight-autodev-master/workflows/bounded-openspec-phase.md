# Bounded OpenSpec Phase

Use this workflow when the master wants exactly one OpenSpec phase performed by the slave.

## Phase Selection

| Phase intent | Invocation leaf |
| --- | --- |
| Explore requirements, inspect code, clarify problem | [../invocations/raw-openspec/explore.md](../invocations/raw-openspec/explore.md) |
| Create or continue proposal artifacts | [../invocations/raw-openspec/propose.md](../invocations/raw-openspec/propose.md) |
| Implement an existing change | [../invocations/raw-openspec/apply-change.md](../invocations/raw-openspec/apply-change.md) |
| Sync delta specs into main specs | [../invocations/raw-openspec/sync-specs.md](../invocations/raw-openspec/sync-specs.md) |
| Archive or finalize completed work | [../invocations/raw-openspec/archive-change.md](../invocations/raw-openspec/archive-change.md) |

## Workflow

1. Identify the requested OpenSpec phase from the master request.
2. If the phase is ambiguous, ask for the smallest clarification needed.
3. Read the selected invocation leaf for meaning, prerequisites, and implications.
4. Dispatch through the selected invocation leaf.
5. After delivery is accepted, finish the turn by default.

## Guardrails

- Do not chain multiple raw OpenSpec phases from this workflow.
- Do not use `imsight-autodev-slave openspec-one-pass` when the user asked for one bounded phase.
- Do not restate command semantics here; the invocation leaf owns them.
