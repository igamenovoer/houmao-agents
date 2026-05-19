## ADDED Requirements

### Requirement: Master Skill Dispatch Entrypoint
The system SHALL provide an `imsight-autodev-master` skill whose `SKILL.md` acts as a compact entrypoint for master-agent request dispatch to Houmao-managed slave agents.

#### Scenario: Explicit master skill invocation
- **WHEN** a master agent is instructed to use `imsight-autodev-master`
- **THEN** the skill identifies the requested subcommand and loads the matching subskill instead of embedding the full workflow in `SKILL.md`

#### Scenario: Missing subcommand
- **WHEN** the invocation does not identify a supported master subcommand
- **THEN** the skill asks for the smallest missing clarification needed to choose a subskill

### Requirement: Slave Metadata Inspection
The system SHALL define an `inspect-slave` subskill that inspects a Houmao-managed slave agent through supported read-only Houmao surfaces before dispatching work.

#### Scenario: Inspect known slave
- **WHEN** a master request identifies a slave by `agent_name` or `agent_id`
- **THEN** the master skill guides the agent to recover slave metadata using `houmao-mgr agents state` and related supported read-only commands

#### Scenario: Manifest metadata needed
- **WHEN** dispatch needs durable metadata that is only present in the slave manifest
- **THEN** the master skill reads `manifest.json` only after a supported state surface exposes `manifest_path` or `session_root`

### Requirement: Tool-Specific Command Rendering
The system SHALL render slave requests with command syntax that matches the slave agent's tool lane.

#### Scenario: Codex slave OpenSpec dispatch
- **WHEN** the inspected slave tool is `codex`
- **THEN** direct OpenSpec requests use `$openspec-*` command prefixes

#### Scenario: Claude slave OpenSpec dispatch
- **WHEN** the inspected slave tool is `claude`
- **THEN** direct OpenSpec requests use `/openspec-*` command prefixes

#### Scenario: Unknown slave tool
- **WHEN** the slave tool cannot be determined or does not have known command syntax
- **THEN** the master skill asks for clarification or reports the unsupported tool instead of guessing

### Requirement: OpenSpec Dispatch Subcommands
The system SHALL provide master subskills for dispatching OpenSpec-oriented requests to a Houmao-managed slave.

#### Scenario: One-pass dispatch
- **WHEN** the master uses the `openspec-one-pass` subcommand
- **THEN** the rendered slave request invokes `imsight-autodev-slave openspec-one-pass` with the appropriate tool-specific command prefix

#### Scenario: Atomic OpenSpec dispatch
- **WHEN** the master uses an atomic OpenSpec subcommand such as `openspec-explore`, `openspec-propose`, `openspec-apply-change`, or `openspec-archive-change`
- **THEN** the rendered slave request invokes the corresponding OpenSpec command directly with the appropriate tool-specific command prefix

### Requirement: Send-And-Stop Delivery
The system SHALL make successful delivery the default stopping point for master-agent dispatch.

#### Scenario: Request delivered
- **WHEN** a master dispatch request is accepted or delivered to the slave through a supported Houmao messaging surface
- **THEN** the master skill instructs the master agent to finish the turn without inspecting slave follow-up by default

#### Scenario: Explicit follow-up requested
- **WHEN** the user explicitly asks the master to inspect results, gateway state, mailbox state, TUI output, or slave follow-up
- **THEN** the master skill may route to appropriate Houmao inspection or messaging guidance after delivery
