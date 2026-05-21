## Why

Master agents need a reusable way to send development requests to Houmao-managed slave agents without re-learning Houmao delivery surfaces, OpenSpec command syntax, or slave metadata inspection rules each time. This change adds a master-side skill that standardizes request dispatch while preserving the workspace rule that masters stop after delivery by default.

## What Changes

- Add a new `imsight-autodev-master` skill as a mega-skill entrypoint with subskills that behave like subcommands.
- Add an `inspect-slave` subskill that reads Houmao-managed slave metadata through supported read-only surfaces before dispatch.
- Add OpenSpec dispatch subskills that render the correct slave command for Codex-based and Claude-based slaves.
- Define delivery behavior that prefers supported Houmao messaging surfaces and stops after successful request acceptance or delivery unless explicitly asked to inspect follow-up.
- Keep the existing `imsight-autodev-slave` skill as the slave-side request processor that the master targets for one-pass workflows.

## Capabilities

### New Capabilities

- `autodev-master-dispatch`: Master-side dispatch of OpenSpec-oriented development requests to Houmao-managed slave agents, including slave metadata inspection, command rendering, and delivery-stop behavior.

### Modified Capabilities

None.

## Impact

- Adds `skillset/imsight-skills/imsight-autodev-master/` with `SKILL.md`, `agents/openai.yaml`, and subskills.
- Uses existing Houmao managed-agent inspection and messaging conventions; no new runtime dependencies are expected.
- Documents command syntax differences for Codex (`$openspec-*`) and Claude (`/openspec-*`) slave agents.
- Aligns with workspace `AGENTS.md` messaging rules for send-and-stop behavior.
