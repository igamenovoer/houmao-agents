## Why

Slave agents may run in isolated environments where the master cannot access or safely mutate the slave workdir directly. OpenSpec initialization therefore needs to be a slave-side operation that the master dispatches, preserving the master/slave boundary.

## What Changes

- Add a master subcommand, `init-slave-for-openspec`, that inspects the Houmao-managed slave and dispatches an explicit slave-skill request.
- Add a slave subcommand, `init-openspec`, that runs inside the slave environment and initializes `openspec/` in the slave's current target workdir when missing.
- Define safe OpenSpec initialization behavior: generate OpenSpec structure in a temporary directory, copy only `openspec/`, do not copy `.codex/` or `.claude/`, and do not overwrite existing `openspec/`.
- Preserve the master skill's send-and-stop behavior after dispatch.

## Capabilities

### New Capabilities

- `autodev-openspec-init-dispatch`: Master-to-slave OpenSpec initialization dispatch, where the master sends the initialization request and the slave performs local workdir initialization.

### Modified Capabilities

None.

## Impact

- Updates `skillset/imsight-autodev-master/` with a new dispatch subcommand.
- Updates `skillset/imsight-autodev-slave/` with a new local initialization subcommand.
- Uses the existing `openspec` CLI and temporary directories; no new package dependencies are expected.
- Avoids assuming the master has filesystem access to the slave's workdir.
