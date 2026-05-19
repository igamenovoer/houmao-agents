## ADDED Requirements

### Requirement: Master Dispatches Slave OpenSpec Initialization
The system SHALL provide an `init-slave-for-openspec` master subcommand that sends an explicit `imsight-autodev-slave init-openspec` request to a selected Houmao-managed slave instead of directly mutating the slave workdir.

#### Scenario: Codex slave initialization dispatch
- **WHEN** the master dispatches OpenSpec initialization to a Codex-based slave
- **THEN** the rendered request uses `$imsight-autodev-slave init-openspec <request>`

#### Scenario: Claude slave initialization dispatch
- **WHEN** the master dispatches OpenSpec initialization to a Claude-based slave
- **THEN** the rendered request uses `/imsight-autodev-slave init-openspec <request>`

#### Scenario: Dispatch accepted
- **WHEN** the initialization request is accepted or delivered to the slave
- **THEN** the master finishes the turn without inspecting slave follow-up by default

### Requirement: Slave Initializes Local OpenSpec Workspace
The system SHALL provide an `init-openspec` slave subcommand that initializes `openspec/` in the slave's current target workdir when it is missing.

#### Scenario: Workdir already initialized
- **WHEN** the slave's target workdir already contains `openspec/`
- **THEN** the slave reports that no initialization is needed and does not overwrite the directory

#### Scenario: Workdir missing OpenSpec
- **WHEN** the slave's target workdir does not contain `openspec/`
- **THEN** the slave generates OpenSpec structure in a temporary directory and copies only the generated `openspec/` directory into the target workdir

#### Scenario: Tool-local state excluded
- **WHEN** the slave initializes OpenSpec from a temporary scaffold
- **THEN** the slave does not copy `.codex/`, `.claude/`, or other tool-local assistant state into the target workdir

#### Scenario: Target workdir unclear
- **WHEN** the slave cannot determine the target workdir safely
- **THEN** the slave stops and reports the missing workdir information instead of initializing OpenSpec
