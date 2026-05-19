## ADDED Requirements

### Requirement: Layered Master Entrypoint

The master skill SHALL present `SKILL.md` as an entrypoint that routes to layered documentation instead of carrying detailed dispatch semantics directly.

#### Scenario: Outcome-oriented request

- **WHEN** a master user asks for a higher-level outcome such as preparing a slave for OpenSpec work or delegating an OpenSpec lifecycle
- **THEN** `SKILL.md` routes the reader to a workflow page rather than a raw invocation leaf

#### Scenario: Explicit leaf invocation

- **WHEN** a master user explicitly asks for a specific raw OpenSpec skill invocation or slave-skill invocation
- **THEN** `SKILL.md` routes the reader to the matching invocation page

### Requirement: Raw OpenSpec Invocation Layer

The master skill SHALL provide raw OpenSpec invocation pages that document direct dispatch of slave-local OpenSpec skills, including meaning, prerequisites, implications, command rendering, and delivery expectations.

#### Scenario: Raw OpenSpec dispatch selected

- **WHEN** the master chooses a direct OpenSpec phase such as explore, propose, apply, sync, or archive
- **THEN** the selected raw invocation page documents the matching `$openspec-*` or `/openspec-*` command and the state assumptions for that phase

#### Scenario: Mutation implication documented

- **WHEN** a raw invocation can mutate the slave workspace or OpenSpec state
- **THEN** its invocation page describes that implication before the command rendering guidance

### Requirement: Slave Skill Invocation Layer

The master skill SHALL provide slave-skill invocation pages for predefined `imsight-autodev-slave` operations that are owned by the slave skill.

#### Scenario: Slave-owned action selected

- **WHEN** the master needs a predefined slave action such as `init-openspec` or `openspec-one-pass`
- **THEN** the selected slave-skill invocation page renders `$imsight-autodev-slave <operation>` or `/imsight-autodev-slave <operation>` according to the slave tool lane

#### Scenario: Slave filesystem ownership preserved

- **WHEN** a predefined slave action mutates the slave workspace
- **THEN** the master dispatches the slave-skill invocation and does not directly mutate the slave workdir

### Requirement: Workflow Layer

The master skill SHALL provide workflow pages that decide when to use raw OpenSpec invocation versus slave-skill invocation for branching master-side outcomes.

#### Scenario: Workflow composes invocation leaves

- **WHEN** a workflow reaches a dispatch decision
- **THEN** it references the selected raw invocation or slave-skill invocation page for command semantics

#### Scenario: Workflow branches by intent

- **WHEN** the user intent differs between one-pass automation, bounded phase work, initialization, continuation, or finalization
- **THEN** the workflow page selects the appropriate invocation path for that intent

### Requirement: Shared Dispatch Primitives

The master skill SHALL centralize shared slave inspection, command rendering, delivery, and mail-notifier policy guidance in reusable primitive pages.

#### Scenario: Dispatch page needs slave metadata

- **WHEN** a workflow or invocation page needs slave metadata
- **THEN** it references the shared inspection primitive instead of duplicating the inspection ladder

#### Scenario: Mail delivery needs request-specific behavior

- **WHEN** mail delivery is used for a single request
- **THEN** the master places request-specific behavior in the mail body and does not use mail-notifier appendix text as a one-off instruction surface

#### Scenario: Mail notifier appendix policy is changed

- **WHEN** the master intentionally changes mail-notifier appendix text
- **THEN** the guidance treats it as persistent runtime policy and accounts for side effects on other masters or senders sharing the slave

### Requirement: Send And Stop Default

The layered master skill SHALL preserve the existing rule that the master finishes after accepted delivery by default.

#### Scenario: Request delivered

- **WHEN** a workflow or invocation is accepted or delivered to the slave
- **THEN** the master stops without inspecting slave follow-up unless the user explicitly requested follow-up inspection
