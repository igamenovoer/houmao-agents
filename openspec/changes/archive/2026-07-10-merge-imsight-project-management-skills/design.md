## Context

The Imsight suite currently divides repository lifecycle work between `imsight-python-general` and `imsight-dev-project-mgr`. The former exposes Pixi/Python project structure and coding-agent rule declaration, while the latter exposes clean worktree creation and isolated implementation. The split makes related project-level tasks difficult to discover and leaves the Python skill name responsible for some rules that are not Python-specific.

The merged skill must follow the existing Imsight command contract: a compact `SKILL.md` router, universal `help`, task-only routing, constrained invocation, detailed executable pages, and explicit output ownership. It must also follow the current Imsight style guide by using an exact, early, numbered `## Workflow` with a freeform fallback on each executable page.

## Goals / Non-Goals

**Goals:**

- Establish `imsight-project-mgr` as the single entrypoint for the project-foundation and project-development operations currently split across the two source skills.
- Preserve the four original public operations and their names, add focused `init-pixi-project` initialization, and organize the operations under two clear functional categories.
- Restrict the merged skill to explicit user invocation or routing from another skill.
- Preserve the safety properties and operational paths of the existing worktree scripts and workflows.
- Remove the two replaced skills and update every internal route, example, and suite index entry.

**Non-Goals:**

- Absorb requirements exploration, feature design, OpenSpec one-pass automation, host setup, networking, or miscellaneous project infrastructure.
- Add new project inspection, generic initialization, rule-renaming, or generic verification subcommands in this change.
- Generalize the existing Pixi/Python structure workflow into a multi-ecosystem profile system.
- Change Houmao runtime or CLI behavior.
- Add an automatic compatibility period for the two removed skill names.
- Define domain-specific coding techniques; the skill manages the execution envelope around implementation.

## Decisions

### 1. Use a lifecycle umbrella with explicit ownership boundaries

`imsight-project-mgr` will own project-foundation operations and project-development execution operations. It will route planning and infrastructure work to neighboring Imsight skills instead of growing into a generic catch-all.

The skill will not activate implicitly for generic project work or merely because surrounding context mentions Imsight. Its frontmatter, invocation contract, help text, and `agents/openai.yaml` metadata will permit explicit user invocation and internal routing while setting `policy.allow_implicit_invocation: false`.

Alternative considered: broaden the merged skill with new inspection, generic initialization, profile, and verification abstractions. That would turn a bounded merge into a larger API redesign and obscure the behavior already provided by the two source skills.

### 2. Divide public subcommands into two functional categories

The merged skill will expose the union of the original public subcommands under two headings:

- **Project Foundation**: `init-pixi-project`, `structure-pixi-project`, and `declare-universal-rules`.
- **Project Development**: `create-worktree` and `impl-in-worktree`.

`help` remains the universal support command outside those functional categories. All five operational subcommands remain independently invocable. The categories communicate purpose; they do not impose a mandatory sequence. Task-only routing may select one operation or compose a sequence only when the request clearly requires it.

Alternative considered: model every command as a mandatory project lifecycle. That would make a simple rules or worktree request run unrelated stages.

### 3. Preserve project-foundation operations as public commands

`init-pixi-project` will be the focused command for first-time Pixi/Python initialization. It will inspect for existing Pixi state, avoid reinitializing an established Pixi project, select the manifest and Python version from user or repository evidence, run the standard Pixi initialization commands, and then use `structure-pixi-project` for baseline structural reconciliation.

`structure-pixi-project` will remain the explicit command for initializing, scaffolding, reviewing, or normalizing a Pixi-managed Python project. Its existing manifest, src-layout, tests, docs, context, scripts, external dependency, ignore-rule, package-naming, initialization-command, and review contracts will remain available, so existing callers are not forced to adopt the new focused command.

The project structure contract will make `context/` a deliberate project-knowledge area rather than one undifferentiated directory. Its baseline homes will be `plans/` for actionable work plans, `features/` for feature-planning bundles, `design/` for project and architecture design, `summaries/` for durable synthesized context, and `archived/` for superseded material. Initialization will create these homes through the structural handoff.

`declare-universal-rules` will remain the explicit command for adding or refreshing the managed `Universal Project Rules` section in a coding-agent context file. It will preserve the current target selection, heading-depth, project-content preservation, and idempotency contracts.

Alternative considered: replace these operations with `init-project` and `declare-project-rules`. Renaming and subsuming them would break public invocations without being necessary to merge the skills.

### 4. Preserve project-development behavior and shared policy

The existing `create_worktree.sh` and `create_impl_worktree.sh` scripts will move initially without semantic redesign. The command pages will retain branch/ref handling, detached fallback, dirty-state snapshotting, branch collision refusal, safe linking of untracked local resources, Pixi environment linking, original-checkout protection, local-only commits, and explicit no-push behavior.

Duplicated local-state candidate and linking policy will be documented once in `references/worktree-local-state-policy.md`. Script deduplication is optional only if it does not alter behavior or output keys.

### 5. Distinguish skill artifacts from project mutations

Skill-owned reports will use user path, then `IMSIGHT_SKILL_OUTPUT_DIR`, then `<project-root>/.imsight-arts/project-mgr/`. Project-foundation commands intentionally modify the selected project root. Worktrees and implementation homes will retain `.imsight-arts/worktrees/` and `.imsight-arts/impl-branches/` as operational destinations.

### 6. Perform a hard migration

The implementation will create `imsight-project-mgr`, migrate and revise owned resources, update suite-wide references, and remove both source skill directories. It will not retain redirect skills. This matches the repository's stated acceptance of breaking internal changes and leaves one canonical entrypoint.

## Risks / Trade-offs

- [The umbrella becomes a catch-all] → State ownership boundaries in the description, workflow, help output, and common-mistakes section; keep neighboring routes explicit.
- [Breaking skill names disrupt existing prompts] → Search the entire repository for old names, update examples and routes, and document the replacement mapping in the proposal and final implementation summary.
- [Moving scripts changes worktree safety behavior] → Preserve script contents and machine-readable output keys first, then validate shell syntax and focused behavior before any optional refactor.
- [The category headings imply a mandatory lifecycle] → State that the categories describe purpose and keep every operational subcommand independently invocable.
- [Project-foundation behavior drifts during relocation] → Preserve the existing Pixi structure and universal-rule workflows, then validate their original examples and idempotency expectations under the new skill name.

## Migration Plan

1. Create the new skill layout and metadata with the merged router and ownership contract.
2. Add `Project Foundation` and `Project Development` subcommand groups to the entrypoint, with `help` as the universal support command.
3. Add `init-pixi-project`, then move `structure-pixi-project` and `declare-universal-rules` into the Project Foundation group while preserving the original names and behavior.
4. Move `create-worktree` and `impl-in-worktree` into the Project Development group, move their scripts, update native skill names in examples, and preserve their operational contracts.
5. Update the suite README and all repository references to the new skill while retaining the four original subcommand names and documenting `init-pixi-project`.
6. Remove the two source skill directories.
7. Run skill validation, link/reference scans, shell syntax checks, and focused project-foundation and project-development workflow tests.

Rollback consists of reverting the change as one repository commit; no external data migration or runtime state conversion is required.

## Open Questions

None required for implementation. New project-management operations or broader initialization abstractions should be proposed as separate changes.
