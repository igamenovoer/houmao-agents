# Raw OpenSpec Sync-Specs Invocation

Use this invocation leaf when the master wants a Houmao-managed slave to sync delta specs from an OpenSpec change into main specs without necessarily archiving the change.

## Meaning

This dispatch invokes the slave-local OpenSpec sync-specs skill directly. It is a spec-state update phase, commonly used before final archive when the local workflow requires explicit sync.

## Prerequisites

- A selected Houmao-managed slave.
- A target repository or workspace.
- An existing OpenSpec change with delta specs ready to sync.
- Tool lane metadata from [../../primitives/inspect-slave.md](../../primitives/inspect-slave.md).

## Implications

- This invocation can mutate `openspec/specs/` in the slave workspace.
- It does not by itself archive the change unless the slave-local skill or request explicitly performs that additional action.
- Use archive invocation when the desired outcome is finalization and archival.

## Command

- Codex slave:
  ```text
  $openspec-sync-specs <change-or-request>
  ```
- Claude slave:
  ```text
  /openspec-sync-specs <change-or-request>
  ```

## Workflow

1. Read [../../primitives/inspect-slave.md](../../primitives/inspect-slave.md).
2. Preserve the sync request, including change name/path, repository/workspace, and any validation expectations.
3. Render the command using [../../primitives/render-invocation.md](../../primitives/render-invocation.md).
4. Deliver with [../../primitives/deliver-to-slave.md](../../primitives/deliver-to-slave.md).
5. After delivery is accepted, finish the turn by default.

## Guardrails

- Do not sync specs locally when the request is slave dispatch.
- Do not treat sync as archive unless the request explicitly asks for finalization too.
- Do not inspect the slave's follow-up unless the user explicitly asks.
