## ADDED Requirements

### Requirement: Project manager uses manual-or-routed invocation
The Imsight skill suite SHALL provide `imsight-project-mgr` only for explicit user invocation or routing from another skill.

#### Scenario: User explicitly invokes the skill
- **WHEN** a user explicitly names `imsight-project-mgr` with a subcommand or task prompt
- **THEN** the agent loads the skill and follows its invocation contract

#### Scenario: Another skill routes project management work
- **WHEN** another loaded skill explicitly routes a supported project-foundation or project-development operation to `imsight-project-mgr`
- **THEN** the agent loads the project manager and executes the routed operation

#### Scenario: Generic project request does not trigger the skill
- **WHEN** a prompt requests generic project work without explicitly naming `imsight-project-mgr` and without an internal skill route
- **THEN** the agent does not activate `imsight-project-mgr`, even when surrounding context mentions Imsight

### Requirement: Entrypoint categorizes the retained public commands
`imsight-project-mgr/SKILL.md` SHALL act as a compact router that groups five operational subcommands into Project Foundation and Project Development while keeping `help` as universal support.

#### Scenario: Entrypoint lists Project Foundation commands
- **WHEN** an agent loads the entrypoint
- **THEN** it lists `init-pixi-project`, `structure-pixi-project`, and `declare-universal-rules` under Project Foundation with short explanations and linked detail pages

#### Scenario: Entrypoint lists Project Development commands
- **WHEN** an agent loads the entrypoint
- **THEN** it lists `create-worktree` and `impl-in-worktree` under Project Development with short explanations and linked detail pages

#### Scenario: Missing task defaults to help
- **WHEN** a user invokes `imsight-project-mgr` without a subcommand or actionable task
- **THEN** the skill explains its scope, invocation restriction, categories, and public subcommands

#### Scenario: Task-only invocation selects retained operations
- **WHEN** an explicit or routed task maps clearly to one retained subcommand or a necessary sequence
- **THEN** the skill selects the narrowest matching operation or sequence without treating the category order as a mandatory lifecycle

### Requirement: Executable pages follow the Imsight workflow contract
The entrypoint and every executable command page MUST contain an early exact `## Workflow` with concise numbered steps, references to detailed sections, and a fallback that uses the agent's native planning tool for freeform tasks.

#### Scenario: Agent loads an executable page
- **WHEN** the agent opens the entrypoint or one of the five command pages
- **THEN** it can begin execution from an exact numbered `## Workflow` and follow linked detail without reconstructing the procedure from prose

### Requirement: Pixi project initialization is a focused foundation operation
`init-pixi-project` SHALL initialize a new Pixi-managed Python project from explicit user and repository evidence, avoid destructive reinitialization, and hand baseline layout reconciliation to `structure-pixi-project`.

#### Scenario: New Pixi Python project is initialized
- **WHEN** the user invokes `init-pixi-project` for a project root without Pixi configuration
- **THEN** the command selects the manifest form and Python version, runs the established Pixi initialization commands, applies the standard dependency baseline, and invokes the structural workflow for the project layout

#### Scenario: Existing Pixi project is not reinitialized
- **WHEN** the target contains `pixi.toml`, `pixi.lock`, or Pixi configuration in `pyproject.toml`
- **THEN** `init-pixi-project` preserves the manifest and dependency constraints and routes directly to structural reconciliation

#### Scenario: Initialization evidence is incomplete
- **WHEN** the project name, package name, Python version, or target root cannot be resolved safely from the request or repository
- **THEN** the command asks for the smallest missing decision before running Pixi initialization

### Requirement: Pixi project structure remains a public foundation operation
`structure-pixi-project` SHALL retain the existing behavior for initializing, scaffolding, reviewing, or normalizing a Pixi-managed Python project.

#### Scenario: New Pixi Python project is structured
- **WHEN** the user invokes `structure-pixi-project` for a new project root
- **THEN** the workflow applies the established Pixi manifest, `src/` package, unit/integration/manual tests, documentation, context, scripts, tracked/orphan external dependency, project skill, disposable-state, ignore-rule, package-naming, initialization-command, and review conventions

#### Scenario: Existing Pixi project is preserved
- **WHEN** the target already contains `pixi.toml`, `pixi.lock`, or Pixi configuration in `pyproject.toml`
- **THEN** the workflow preserves the existing manifest form and dependency constraints and merges missing structure idempotently

#### Scenario: Context homes are created
- **WHEN** `init-pixi-project` or `structure-pixi-project` creates or reconciles the project baseline
- **THEN** `context/` contains `plans/`, `features/`, `design/`, `summaries/`, and `archived/`, and the workflow documents the distinct role of each home

### Requirement: Universal project rules remain a public foundation operation
`declare-universal-rules` SHALL add or refresh one managed `Universal Project Rules` section in the user-selected or appropriately discovered coding-agent context file while preserving project-specific guidance.

#### Scenario: Rules are absent
- **WHEN** the target context file lacks the managed section
- **THEN** the command inserts one section at the appropriate heading depth and reports that it was added

#### Scenario: Rules already exist
- **WHEN** the target context file contains the managed section
- **THEN** the command replaces only that section with the canonical content and reports that it was refreshed

### Requirement: Clean worktree creation preserves the active checkout
`create-worktree` SHALL use Git worktrees to create an isolated snapshot while leaving the active checkout, its branch, and its tracked content unchanged.

#### Scenario: Source branch is available
- **WHEN** the requested local branch is not checked out in another worktree
- **THEN** the command creates a branch-attached worktree at the selected or default operational path

#### Scenario: Source branch is already checked out
- **WHEN** the requested local branch is checked out in another worktree
- **THEN** the command creates a detached worktree at that branch tip instead of disturbing the existing checkout

#### Scenario: Local resource is safe to link
- **WHEN** an approved local-state directory exists at the project root and contains no tracked files at that path
- **THEN** the command symlinks it into the new worktree and reports the link

#### Scenario: Local resource contains tracked content
- **WHEN** Git tracks files under a candidate local-state path
- **THEN** the command preserves worktree content, skips the symlink, and reports the tracked-path skip

### Requirement: Isolated implementation preserves local state and delivery boundaries
`impl-in-worktree` MUST create a new local feature or fix branch from a snapshot of the current tracked and untracked repository state, perform subsequent work only inside its worktree, run relevant verification, and leave a local commit without pushing.

#### Scenario: Dirty source checkout starts an implementation
- **WHEN** the source checkout contains tracked or untracked changes and the requested branch and worktree paths are available
- **THEN** the helper creates a snapshot commit and new implementation branch containing that state without committing or switching the original checkout

#### Scenario: Requested branch or path already exists
- **WHEN** the implementation branch or worktree path already exists
- **THEN** the workflow stops and asks the caller to continue the existing session or choose a new topic instead of silently reusing or overwriting it

#### Scenario: Worktree has been created
- **WHEN** the helper returns the isolated worktree path
- **THEN** all implementation reads, edits, builds, tests, and OpenSpec commands occur inside that worktree

#### Scenario: OpenSpec change is the implementation target
- **WHEN** the target resolves to an OpenSpec change
- **THEN** the workflow discovers change state with OpenSpec tooling inside the worktree and hands artifact and task progression to `openspec-apply-change`

#### Scenario: Implementation verification succeeds
- **WHEN** relevant verification passes and the requested change is complete
- **THEN** the workflow creates one or more local commits, reports the branch, worktree, commit SHA, verification commands, and local-resource bridges, and does not push or open a pull request without explicit authorization

### Requirement: Skill artifacts and operational mutations use distinct locations
The skill MUST resolve skill-owned reports from an explicit user path, then `IMSIGHT_SKILL_OUTPUT_DIR`, then `<project-root>/.imsight-arts/project-mgr/`, while preserving project files and worktrees in their intentional destinations.

#### Scenario: Skill writes an auxiliary report
- **WHEN** no explicit output path or environment override is present
- **THEN** the report is written under `<project-root>/.imsight-arts/project-mgr/`

#### Scenario: Worktree operation selects its default path
- **WHEN** a worktree command receives no explicit path
- **THEN** clean worktrees remain under `.imsight-arts/worktrees/` and implementation worktrees remain under `.imsight-arts/impl-branches/`

### Requirement: Replaced skills are removed through a hard migration
The repository MUST remove `imsight-python-general` and `imsight-dev-project-mgr` after their retained behavior is available through `imsight-project-mgr`, and MUST update all suite-owned references to the replacement skill name.

#### Scenario: Migration completes
- **WHEN** the merged skill passes validation
- **THEN** the two source skill directories are absent and suite documentation, metadata, internal routes, examples, and scripts contain no stale invocation of either removed skill

#### Scenario: Former capability is demonstrated
- **WHEN** suite documentation demonstrates `init-pixi-project` or any of the four retained operations
- **THEN** it invokes the original subcommand name through `imsight-project-mgr` rather than a compatibility shim
