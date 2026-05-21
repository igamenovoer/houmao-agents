## Why

The `imsight-*` skills now have a suite-level command contract, but the individual skill entrypoints do not consistently expose `help`, task-only subcommand selection, or named subcommand indexes. Aligning the skills makes them easier to invoke, route between, and maintain as a coherent engineering automation suite.

## What Changes

- Add a consistent subcommand contract to each `imsight-*` skill entrypoint.
- Require every `imsight-*` skill to support a universal `help` subcommand, with no-subcommand invocation defaulting to `help`.
- Support task-only invocations such as `$imsight-<what> <task prompt>` by selecting the applicable subcommand or sequence of subcommands.
- Normalize `SKILL.md` files as compact command routers that describe subcommand functionality and link to detailed workflows, subskills, or references.
- Update UI metadata where needed so Imsight skills do not imply broad automatic triggering outside explicit naming, internal routing, or relevant `imsight` context.

## Capabilities

### New Capabilities

- `imsight-skill-command-contract`: Defines the invocation, help, task-routing, and entrypoint structure expected of all Imsight skills.

### Modified Capabilities

None.

## Impact

- Affects `skillset/imsight-skills/README.md`.
- Affects `SKILL.md` entrypoints and possibly `agents/openai.yaml` metadata for each `skillset/imsight-skills/imsight-*` skill.
- Does not add runtime dependencies or change Houmao CLI behavior.
