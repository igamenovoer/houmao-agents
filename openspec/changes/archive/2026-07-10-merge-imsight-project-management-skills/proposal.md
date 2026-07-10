## Why

Project-foundation operations and isolated project-development operations are split between `imsight-python-general` and `imsight-dev-project-mgr`, forcing users and routing skills to know two entrypoints for closely related repository management work. A single manually invoked or internally routed `imsight-project-mgr` can expose the existing operations coherently without redesigning their public command contracts.

## What Changes

- Add `imsight-project-mgr` as the canonical Imsight skill for the retained project-foundation and project-development operations.
- Organize `init-pixi-project`, `structure-pixi-project`, and `declare-universal-rules` under **Project Foundation**.
- Organize `create-worktree` and `impl-in-worktree` under **Project Development**.
- Keep `help` as the universal support command outside the two functional categories.
- Restrict invocation to explicit user invocation or routing from another skill; do not activate implicitly for generic project tasks or surrounding Imsight context alone.
- Add a focused `init-pixi-project` operation for first-time Pixi/Python initialization that hands structural reconciliation to `structure-pixi-project`.
- Define the initialized `context/` baseline with `plans/`, `features/`, `design/`, `summaries/`, and `archived/` homes.
- Preserve the existing Pixi/Python structure, universal-rule declaration, safe worktree, dirty-state snapshot, local-resource linking, OpenSpec handoff, local verification, and no-push behavior.
- Keep requirements exploration, feature design, one-pass OpenSpec automation, host setup, networking, and miscellaneous project infrastructure in their existing Imsight skills.
- **BREAKING**: Remove the `imsight-python-general` and `imsight-dev-project-mgr` skill entrypoints; callers must use `imsight-project-mgr` while retaining the original subcommand names.
- Update suite documentation, metadata, examples, references, and validation coverage for the merged skill.

## Capabilities

### New Capabilities

- `imsight-project-management`: Defines the merged skill's manual-or-routed invocation, categorized command surface, retained project-foundation and project-development behavior, output ownership, and migration contracts.

### Modified Capabilities

None.

## Impact

- Replaces `skillset/imsight-skills/imsight-python-general/` and `skillset/imsight-skills/imsight-dev-project-mgr/` with `skillset/imsight-skills/imsight-project-mgr/`.
- Moves and revises their entrypoint, command/reference pages, UI metadata, universal project rules, and worktree helper scripts.
- Changes public skill names used by prompts, internal routes, examples, and documentation while preserving all four original operational subcommand names and adding `init-pixi-project`.
- Adds no runtime dependency and does not change Houmao CLI behavior.
