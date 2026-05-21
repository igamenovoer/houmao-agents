## 1. Skill Structure

- [x] 1.1 Create `skillset/imsight-skills/imsight-autodev-master/` with `SKILL.md`, `agents/openai.yaml`, and `subskills/`.
- [x] 1.2 Define `SKILL.md` as a compact manual-invocation entrypoint that routes to master subskills.
- [x] 1.3 Add UI metadata for `imsight-autodev-master` with implicit invocation disabled.

## 2. Slave Inspection

- [x] 2.1 Add `subskills/inspect-slave.md` documenting supported Houmao read-only inspection surfaces.
- [x] 2.2 Document the inspection ladder: `agents list`, `agents state`, gateway status, mail resolve-live when relevant, and manifest reading only after state exposes durable paths.
- [x] 2.3 Document slave metadata fields used for dispatch, including tool lane, lifecycle state, gateway posture, mailbox posture, working directory, and manifest path.

## 3. OpenSpec Dispatch Subskills

- [x] 3.1 Add `subskills/openspec-one-pass.md` that renders requests to `imsight-autodev-slave openspec-one-pass`.
- [x] 3.2 Add `subskills/openspec-explore.md` for direct explore-only slave dispatch.
- [x] 3.3 Add `subskills/openspec-propose.md` for direct proposal slave dispatch.
- [x] 3.4 Add `subskills/openspec-apply-change.md` for direct implementation slave dispatch.
- [x] 3.5 Add `subskills/openspec-archive-change.md` for direct archive/finalization slave dispatch.

## 4. Delivery and Guardrails

- [x] 4.1 Document Codex command rendering with `$openspec-*` and `$imsight-autodev-slave`.
- [x] 4.2 Document Claude command rendering with `/openspec-*` and `/imsight-autodev-slave`.
- [x] 4.3 Document supported delivery behavior through Houmao messaging surfaces, preferring live gateway prompt delivery when available.
- [x] 4.4 Document send-and-stop behavior: after accepted or delivered requests, do not inspect slave follow-up unless explicitly asked.

## 5. Validation

- [x] 5.1 Run the skill validator against `skillset/imsight-skills/imsight-autodev-master`.
- [x] 5.2 Search the new skill for stale worker/slave/master naming mistakes and stale references.
- [x] 5.3 Run OpenSpec validation for `add-imsight-autodev-master`.
