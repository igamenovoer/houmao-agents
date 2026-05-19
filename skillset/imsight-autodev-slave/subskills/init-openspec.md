# Init OpenSpec

Use this subskill when the slave receives an explicit master request to initialize `openspec/` in the slave's current target workdir.

## Target Workdir

Use the current repository or working directory as the target workdir unless the master request provides a clear path. If the target workdir is unclear, stop and report the missing information instead of initializing OpenSpec.

Before mutating anything, confirm the target path exists and is a directory:

```bash
pwd
test -d "$TARGET_WORKDIR"
```

## Workflow

1. Determine `TARGET_WORKDIR`.
2. If `$TARGET_WORKDIR/openspec` already exists, report that no initialization is needed and stop.
3. Verify `openspec` CLI is available:
   ```bash
   command -v openspec
   ```
4. Create a temporary directory and initialize OpenSpec there with tool setup disabled:
   ```bash
   TMP="$(mktemp -d)"
   openspec init --tools none "$TMP"
   ```
5. Verify the generated scaffold contains `openspec/changes` and `openspec/specs`.
6. Copy only the generated `openspec/` directory into the target workdir:
   ```bash
   cp -R "$TMP/openspec" "$TARGET_WORKDIR/openspec"
   ```
7. Remove the temporary directory:
   ```bash
   rm -rf "$TMP"
   ```
8. Verify the target now contains:
   ```bash
   test -d "$TARGET_WORKDIR/openspec/changes"
   test -d "$TARGET_WORKDIR/openspec/specs"
   ```
9. Report the initialized path and any verification performed.

## Failure Handling

- If `openspec/` already exists, do not overwrite, merge, or refresh it.
- If `openspec` CLI is unavailable, report the missing command and stop.
- If temporary generation fails, clean up the temp directory when possible and leave the target workdir unchanged.
- If copying fails, report the failure and do not retry with broader copy patterns.

## Guardrails

- Copy only `$TMP/openspec`; do not copy `.codex/`, `.claude/`, or other tool-local assistant state.
- Do not run `openspec init` directly in the target workdir for this workflow.
- Do not initialize when the target workdir is ambiguous.
- Do not delete an existing `openspec/`.
