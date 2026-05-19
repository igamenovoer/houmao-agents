## 1. Layered Structure

- [x] 1.1 Update `skillset/imsight-autodev-master/SKILL.md` so it acts as a compact layer index and router.
- [x] 1.2 Create shared primitive pages for slave inspection, native command rendering, delivery, and mail-notifier policy.
- [x] 1.3 Create raw OpenSpec invocation pages for explore, propose, apply-change, archive-change, and sync/finalization guidance.
- [x] 1.4 Create slave-skill invocation pages for `init-openspec` and `openspec-one-pass`.
- [x] 1.5 Create workflow pages for preparing a slave for OpenSpec, delegated lifecycle dispatch, bounded phase dispatch, and existing-change continuation/finalization.

## 2. Content Migration

- [x] 2.1 Move existing `inspect-slave` guidance into the shared inspection primitive and update links.
- [x] 2.2 Move existing direct OpenSpec dispatch guidance into raw invocation leaves and add meaning, prerequisites, implications, and state assumptions.
- [x] 2.3 Move existing `imsight-autodev-slave` dispatch guidance into slave-skill invocation leaves and preserve slave-owned filesystem mutation boundaries.
- [x] 2.4 Move mail delivery and notifier appendix guidance into the shared mail-notifier policy primitive.
- [x] 2.5 Ensure workflow pages reference invocation leaves instead of duplicating command semantics.

## 3. Guardrails and Current Operation Names

- [x] 3.1 Preserve user-facing operation names from the current master skill where possible.
- [x] 3.2 Preserve Codex `$...` and Claude `/...` command rendering rules.
- [x] 3.3 Preserve send-and-stop behavior after accepted delivery unless follow-up inspection is explicitly requested.
- [x] 3.4 Remove stale flat subskill pages so they do not conflict with the layered model.

## 4. Validation

- [x] 4.1 Run the skill validator against `skillset/imsight-autodev-master`.
- [x] 4.2 Search the master skill for stale links, duplicated contradictory guidance, and old flat-layer terminology.
- [x] 4.3 Run OpenSpec validation/status checks for `restructure-autodev-master-layers`.
