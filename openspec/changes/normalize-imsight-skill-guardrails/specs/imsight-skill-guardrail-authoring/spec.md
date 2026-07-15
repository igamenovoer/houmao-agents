## ADDED Requirements

### Requirement: Guardrails prevent negative actions
Every active Imsight skill Guardrails section SHALL contain only concise bullets that begin with `DO NOT ...` and identify one materially harmful, unsafe, incorrect, or intent-breaking action to prevent.

#### Scenario: Valid negative guardrail
- **WHEN** a skill writer adds a rule that prevents an agent from mutating an out-of-scope workspace
- **THEN** the writer expresses the rule as one `DO NOT ...` bullet in Guardrails

#### Scenario: Positive requirement proposed as a guardrail
- **WHEN** a proposed guardrail tells the agent what operation it must perform
- **THEN** the writer places that instruction in substantive skill content instead of retaining it in Guardrails

### Requirement: Positive operations live in substantive content
The suite SHALL place positive actions, required operations, ordering, recipes, reporting requirements, and output requirements in workflows, procedures, contracts, constraints, quality gates, or other substantive skill sections.

#### Scenario: Unique positive behavior exists only in Guardrails
- **WHEN** migration finds a positive guardrail requirement with no equivalent substantive instruction
- **THEN** the behavior is added to the closest owning substantive section before the guardrail clause is removed

#### Scenario: Positive behavior is already stated elsewhere
- **WHEN** migration finds a positive guardrail requirement that duplicates an existing workflow, contract, or linked primitive
- **THEN** the duplicate guardrail clause is removed without adding another copy

### Requirement: Procedural disguises are not guardrails
The suite SHALL NOT use `DO NOT forget ...`, `DO NOT fail to ...`, or a positive imperative appended to a prohibition as a way to present operation steps in Guardrails.

#### Scenario: Do-not-forget checklist item
- **WHEN** an existing guardrail says `DO NOT forget to` perform a required step
- **THEN** the step is absorbed into substantive content or the guardrail is removed when that content already exists

#### Scenario: Prohibition followed by positive imperative
- **WHEN** an existing guardrail contains a valid prohibition followed by a positive command after a semicolon or sentence boundary
- **THEN** the prohibition remains concise and the positive command is moved or removed according to its substantive coverage

### Requirement: Every skill entrypoint has Guardrails
Every active Imsight `SKILL.md` SHALL include a concise `## Guardrails` section, while executable detail pages MAY omit the section when no page-specific negative prohibition is needed.

#### Scenario: Entrypoint lacks Guardrails
- **WHEN** suite validation finds an active `SKILL.md` without `## Guardrails`
- **THEN** the entrypoint is updated with intent-specific negative prohibitions without duplicating its workflow

#### Scenario: Detail page has only procedural guardrails
- **WHEN** removing duplicated operation steps leaves a command or reference page with no meaningful negative prohibition
- **THEN** the empty Guardrails section is removed

### Requirement: Authoring guides stay synchronized
The suite-level style guide and the bundled guide used by `imsight-agent-skill-handling` SHALL express the same guardrail authoring contract and example behavior.

#### Scenario: Guardrail guidance is revised
- **WHEN** the guardrail authoring contract changes
- **THEN** both guide copies describe negative-only prevention, substantive placement of positive operations, and the ban on procedural guardrail checklists

### Requirement: Runtime migration preserves behavior and provenance
The migration SHALL preserve public skill behavior, routing, output contracts, and operational requirements while leaving files under `org/src/` unchanged.

#### Scenario: Runtime uppercase MUST clause is found
- **WHEN** an uppercase `MUST` clause appears in an active runtime Guardrails section
- **THEN** it is converted, absorbed, or removed based on semantic inspection and no uppercase `MUST` remains in that active runtime block

#### Scenario: Uppercase MUST exists in immutable provenance
- **WHEN** a scan finds uppercase `MUST` under `org/src/`
- **THEN** validation reports or excludes the provenance match without editing the snapshot

### Requirement: Guardrail conformance is validated
The suite SHALL validate all active skill entrypoints and affected executable pages for metadata validity, Guardrails presence, negative-only form, procedural disguises, and clean diffs.

#### Scenario: Migration validation runs
- **WHEN** implementation is complete
- **THEN** every skill entrypoint passes the available skill validator, runtime scans find no uppercase `MUST` or `DO NOT forget ...`, every entrypoint contains Guardrails, and `git diff --check` succeeds
