## Why

`imsight-autodev-master` currently presents raw OpenSpec dispatch, slave-skill dispatch, and master-side workflow decisions as one flat set of operations. The skill needs an explicit layered design so future subcommands can grow without making `SKILL.md` carry branching workflow logic.

## What Changes

- Restructure the master skill documentation around three layers:
  - raw slave skill invocation pages for direct OpenSpec skills such as `openspec-explore`, `openspec-propose`, `openspec-apply-change`, and archive/finalization actions;
  - slave mega-skill invocation pages for predefined `imsight-autodev-slave` actions such as `init-openspec` and `openspec-one-pass`;
  - master-side workflow pages that decide when to use raw OpenSpec invocation versus slave-skill invocation.
- Keep `skillset/imsight-autodev-master/SKILL.md` as a compact entrypoint and router rather than the home for detailed command semantics.
- Add shared master primitives for slave inspection, command rendering, delivery, and mail-notifier policy so invocation and workflow pages do not duplicate transport guidance.
- Preserve existing send-and-stop behavior after dispatch unless the user explicitly asks for follow-up inspection.
- Preserve the existing slave skill contract while making the master-side distinction between raw skill calls and slave-skill calls clear.

## Capabilities

### New Capabilities

- `autodev-master-layered-dispatch`: Defines the layered master-skill model for dispatch leaves, slave-skill invocation leaves, and workflow decision pages.

### Modified Capabilities

None.

## Impact

- Updates `skillset/imsight-autodev-master/` structure and documentation.
- May move or split existing master subskill pages into clearer layer directories while preserving behavior.
- Does not add runtime dependencies or new Houmao CLI behavior.
- Does not require changes to `imsight-autodev-slave` unless implementation discovers stale cross-references that need alignment.
