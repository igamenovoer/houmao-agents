## Context

`imsight-autodev-master` currently dispatches requests to Houmao-managed slaves, and `imsight-autodev-slave` executes local slave workflows. OpenSpec initialization must follow the same split: the master must not directly mutate a slave's workdir because the slave may run in an isolated filesystem or environment.

## Goals / Non-Goals

**Goals:**

- Add a master-side `init-slave-for-openspec` subcommand that dispatches a slave initialization request.
- Add a slave-side `init-openspec` subcommand that initializes `openspec/` in the slave's current target workdir.
- Preserve master send-and-stop behavior after dispatch.
- Ensure initialization copies only `openspec/` from a temporary OpenSpec scaffold and does not copy tool-local state.

**Non-Goals:**

- Let the master create or copy files directly into the slave workdir.
- Install `.codex/`, `.claude/`, or other assistant-specific command scaffolding into the slave project.
- Overwrite an existing `openspec/` directory.
- Launch, stop, relaunch, or otherwise manage the slave lifecycle.

## Decisions

### Decision: Slave Owns Workdir Mutation

`init-slave-for-openspec` will render a command that invokes the slave skill:

- Codex slave: `$imsight-autodev-slave init-openspec <request>`
- Claude slave: `/imsight-autodev-slave init-openspec <request>`

The slave-side `init-openspec` subcommand performs the filesystem checks and initialization locally.

Alternative considered: have the master copy `openspec/` into the slave workdir after inspecting metadata. This fails when the slave's workdir is isolated from the master or when the master does not have appropriate filesystem permissions.

### Decision: Generate In Temp, Copy Only `openspec/`

The slave subcommand will create a temporary directory, run OpenSpec initialization there with tool setup disabled, and copy only the generated `openspec/` directory into the current target workdir. This avoids adding `.codex/`, `.claude/`, or other local assistant state as a side effect.

Alternative considered: run `openspec init` directly in the slave workdir. This can create tool-specific side effects beyond `openspec/`, depending on flags and OpenSpec defaults.

### Decision: No-Op When Already Initialized

If the slave workdir already contains `openspec/`, the slave subcommand reports that no initialization is needed and does not overwrite it.

Alternative considered: refresh or replace `openspec/` when present. That risks destroying active changes or specs and is outside initialization scope.

## Risks / Trade-offs

- The slave may not have `openspec` on `PATH` -> report a blocker with the attempted command and do not create partial state.
- The slave may run from the wrong directory -> require the slave to confirm or infer the target workdir before mutation.
- Temporary generation may partially fail -> clean up the temp directory where possible and leave the target workdir unchanged.
- Copy may fail after temp generation -> report the failure and leave any existing target state untouched.
