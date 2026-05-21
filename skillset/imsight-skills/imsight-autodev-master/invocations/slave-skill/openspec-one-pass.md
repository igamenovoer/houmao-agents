# Slave Skill OpenSpec One-Pass Invocation

Use this invocation leaf when the master wants one Houmao-managed slave to run the slave mega-skill through the full OpenSpec lifecycle in one focused pass.

## Meaning

This dispatch invokes the predefined `imsight-autodev-slave openspec-one-pass` operation. The slave skill owns the composed local workflow: explore, propose, apply, sync as needed, and archive/finalize.

## Prerequisites

- A selected Houmao-managed slave.
- A target repository or workspace.
- A master request complete enough for one-pass automation or interactive staged execution.
- Tool lane metadata from [../../primitives/inspect-slave.md](../../primitives/inspect-slave.md).

## Implications

- This invocation can create OpenSpec artifacts, implement code, run verification, sync specs, and archive the completed change in the slave workspace.
- Use raw OpenSpec invocation leaves instead when the master wants exactly one bounded phase.
- The master dispatches once and stops by default.

## Command

- Codex slave:
  ```text
  $imsight-autodev-slave openspec-one-pass <master request>
  ```
- Claude slave:
  ```text
  /imsight-autodev-slave openspec-one-pass <master request>
  ```

## Workflow

1. Read [../../primitives/inspect-slave.md](../../primitives/inspect-slave.md).
2. Preserve the master request body exactly enough for the slave to understand the task, target repository, constraints, and desired mode.
3. Render the command using [../../primitives/render-invocation.md](../../primitives/render-invocation.md).
4. Deliver with [../../primitives/deliver-to-slave.md](../../primitives/deliver-to-slave.md).
5. After delivery is accepted, finish the turn by default.

## Guardrails

- Do not split one-pass work into multiple OpenSpec prompts from the master.
- Do not monitor, poll, or inspect the slave after delivery unless explicitly asked.
- Do not use direct OpenSpec command prefixes for one-pass dispatch; target `imsight-autodev-slave`.
