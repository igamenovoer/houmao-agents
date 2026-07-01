# Prepare Slave For OpenSpec

Use this workflow when the master wants the slave to ensure OpenSpec is initialized in the slave's own target workdir.

## Decision

The slave owns the filesystem check because it may be running in an isolated environment. The master should dispatch [../invocations/slave-skill/init-openspec.md](../invocations/slave-skill/init-openspec.md) and stop after accepted delivery.

## Workflow

1. Read [../../references/primitives/inspect-slave.md](../../references/primitives/inspect-slave.md) and recover slave metadata.
2. Preserve the target workdir hint from the request when provided.
3. Read [../invocations/slave-skill/init-openspec.md](../invocations/slave-skill/init-openspec.md) for command semantics.
4. Render the `imsight-autodev-slave init-openspec` command with [../../references/primitives/render-invocation.md](../../references/primitives/render-invocation.md).
5. Deliver with [../../references/primitives/deliver-to-slave.md](../../references/primitives/deliver-to-slave.md).
6. After delivery is accepted, finish the turn by default.

## Guardrails

- Do not check the slave filesystem from the master unless the user explicitly asks for inspection and the path is actually local.
- Do not initialize or copy `openspec/` from the master.
- Do not inspect follow-up unless explicitly asked.
