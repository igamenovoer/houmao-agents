## 1. Master Dispatch

- [x] 1.1 Add `init-slave-for-openspec` to `skillset/imsight-autodev-master/SKILL.md` operations and routing.
- [x] 1.2 Add `skillset/imsight-autodev-master/subskills/init-slave-for-openspec.md`.
- [x] 1.3 Document Codex rendering as `$imsight-autodev-slave init-openspec <request>` and Claude rendering as `/imsight-autodev-slave init-openspec <request>`.
- [x] 1.4 Document that the master must dispatch and stop by default rather than initializing the slave workdir directly.

## 2. Slave Initialization

- [x] 2.1 Add `init-openspec` to `skillset/imsight-autodev-slave/SKILL.md` operations and routing.
- [x] 2.2 Add `skillset/imsight-autodev-slave/subskills/init-openspec.md`.
- [x] 2.3 Document the no-op behavior when `openspec/` already exists in the slave target workdir.
- [x] 2.4 Document the temporary generation flow using `openspec init --tools none <tmp>` and copying only `<tmp>/openspec` into the target workdir.
- [x] 2.5 Document guardrails for unclear workdir, missing `openspec` CLI, failed temp generation, and exclusion of `.codex/` and `.claude/`.

## 3. Validation

- [x] 3.1 Run skill validation for `imsight-autodev-master` and `imsight-autodev-slave`.
- [x] 3.2 Search both skills for stale or contradictory initialization guidance.
- [x] 3.3 Run OpenSpec validation for `add-autodev-openspec-init-dispatch`.
