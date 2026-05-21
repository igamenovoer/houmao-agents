## ADDED Requirements

### Requirement: Imsight skills expose subcommand entrypoints
Each `imsight-*` skill SHALL present `SKILL.md` as the skill's compact command entrypoint, router, and subcommand index.

#### Scenario: Skill entrypoint lists subcommands
- **WHEN** an agent loads an `imsight-*` skill entrypoint
- **THEN** the entrypoint lists available subcommands with short explanations and links to detailed workflow, subskill, invocation, primitive, or reference files where applicable

#### Scenario: Skill entrypoint preserves detailed workflows
- **WHEN** a subcommand requires detailed procedure guidance
- **THEN** the entrypoint links to the detailed file instead of duplicating the full procedure in `SKILL.md`

### Requirement: Imsight skills support universal help
Each `imsight-*` skill SHALL support a `help` subcommand that explains what the skill does and lists available subcommands with explanations.

#### Scenario: Explicit help invocation
- **WHEN** a user invokes `$imsight-<what> use help`
- **THEN** the agent explains the skill purpose and lists the available subcommands with short explanations

#### Scenario: Missing subcommand defaults to help
- **WHEN** a user invokes an `imsight-*` skill without a subcommand or task prompt
- **THEN** the agent treats the invocation as `help`

### Requirement: Imsight skills route task prompts to subcommands
Each `imsight-*` skill SHALL support task-only invocation by selecting the applicable subcommand or sequence of subcommands from the user's task prompt.

#### Scenario: Task-only invocation selects one subcommand
- **WHEN** a user invokes `$imsight-<what> <task prompt>` and the task maps clearly to one subcommand
- **THEN** the agent selects that subcommand and follows the linked workflow

#### Scenario: Task-only invocation selects a sequence
- **WHEN** a user invokes `$imsight-<what> <task prompt>` and the task requires multiple maintained steps
- **THEN** the agent selects and executes the applicable sequence of subcommands or workflow pages

#### Scenario: Ambiguous task-only invocation
- **WHEN** a task prompt does not map clearly to a subcommand or sequence
- **THEN** the agent asks the smallest clarification needed or shows `help` when no actionable task is present

### Requirement: Imsight skills use constrained invocation posture
Each `imsight-*` skill SHALL be eligible for use when explicitly named, routed from another Imsight skill, or when `imsight` is mentioned in the prompt or context for a relevant covered task.

#### Scenario: Relevant Imsight context
- **WHEN** the prompt mentions `imsight` and asks for a task covered by an `imsight-*` skill
- **THEN** the agent may invoke the matching Imsight skill

#### Scenario: Generic task without Imsight context
- **WHEN** the prompt asks for a generic task and does not explicitly name an Imsight skill, mention `imsight`, or arrive through internal Imsight routing
- **THEN** the `imsight-*` skills do not trigger automatically

### Requirement: Imsight skill metadata matches the command contract
Each `imsight-*` skill's metadata SHALL reflect explicit-name, internal-routing, or relevant Imsight-context invocation and SHOULD NOT imply generic automatic triggering.

#### Scenario: UI metadata describes explicit use
- **WHEN** a user reviews an Imsight skill's UI metadata
- **THEN** the default prompt and policy align with the suite's explicit command/subcommand invocation style
