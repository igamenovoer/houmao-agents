## 1. Merged Entrypoint and Metadata

- [x] 1.1 Create `skillset/imsight-skills/imsight-project-mgr/` with `SKILL.md`, `agents/openai.yaml`, and only the command, reference, and script directories required by the retained operations.
- [x] 1.2 Implement the compact entrypoint with an exact numbered `## Workflow`, output precedence, bounded ownership, task-only routing, and strict explicit-user-or-internal-route invocation.
- [x] 1.3 Group `init-pixi-project`, `structure-pixi-project`, and `declare-universal-rules` under Project Foundation, group `create-worktree` and `impl-in-worktree` under Project Development, and keep `help` as universal support.

## 2. Project Foundation Migration

- [x] 2.1 Migrate `structure-pixi-project` into the merged skill with its name, Pixi/Python project conventions, idempotent existing-project behavior, review checklist, and an exact numbered workflow with a freeform fallback.
- [x] 2.2 Migrate `declare-universal-rules` and the canonical universal-rule content into the merged skill with its name, target selection, heading-depth handling, project-content preservation, idempotent managed-section behavior, and an exact numbered workflow with a freeform fallback.
- [x] 2.3 Add `init-pixi-project` with existing-Pixi detection, evidence-based manifest and Python selection, standard Pixi initialization, structural handoff, destructive-reinitialization avoidance, and an exact numbered workflow with a freeform fallback.
- [x] 2.4 Update the Pixi structural contract and initialization handoff to create and explain `context/plans/`, `context/features/`, `context/design/`, `context/summaries/`, and `context/archived/` idempotently.

## 3. Project Development Migration

- [x] 3.1 Move `create_worktree.sh` and `create_impl_worktree.sh` into the merged skill while preserving arguments, safety behavior, operational paths, dirty-state snapshotting, and machine-readable output keys.
- [x] 3.2 Migrate `create-worktree` and `impl-in-worktree`, update skill invocations and links, add exact numbered workflows with freeform fallbacks, and retain original-checkout, OpenSpec-discovery, local-commit, and no-push guardrails.
- [x] 3.3 Document shared worktree local-state policy once and align both development commands with tracked-path skipping, approved untracked linking, and conditional Pixi `.pixi` reuse.

## 4. Hard Migration and Suite Integration

- [x] 4.1 Update `skillset/imsight-skills/README.md` so the contract and skill index describe the manually invoked or internally routed `imsight-project-mgr`, its two subcommand categories, and `init-pixi-project`.
- [x] 4.2 Search the repository for `imsight-python-general` and `imsight-dev-project-mgr`; update suite-owned routes, metadata, prompts, examples, and documentation to `imsight-project-mgr` while preserving the four subcommand names.
- [x] 4.3 Remove both source skill directories after all retained resources and behavior exist in the merged skill, leaving no compatibility shim directories.

## 5. Validation

- [x] 5.1 Run the available skill validator and verify frontmatter, `allow_implicit_invocation: false`, layout, links, category headings, exact workflows, numbered steps, and freeform fallbacks.
- [x] 5.2 Run `bash -n` on both worktree scripts and exercise clean-worktree creation, detached fallback, tracked-link skipping, dirty-state snapshotting, collision refusal, and no-source-checkout mutation in disposable Git repositories.
- [x] 5.3 Exercise `init-pixi-project`, the required `context/` homes, Pixi project structure guidance, and universal-rule add/refresh behavior in disposable project roots, and scan for stale removed-skill invocations outside historical OpenSpec artifacts.
- [x] 5.4 Run strict OpenSpec validation and status checks for `merge-imsight-project-management-skills` and confirm every updated requirement scenario is covered.
