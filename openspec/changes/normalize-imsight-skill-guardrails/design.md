## Context

The Imsight suite was authored against a template that allowed both `DO NOT ...` and `MUST ...` bullets in Guardrails sections. The revised authoring contract treats Guardrails as a sparse negative-action prevention surface and places positive operations in workflows, procedures, contracts, quality gates, or other substantive content. The current runtime contains 39 uppercase `MUST` occurrences on 37 guardrail lines across 15 files, one entrypoint without Guardrails, and several positive operation steps disguised as `DO NOT forget ...` or appended after semicolons.

The `imsight-llm-wiki` skill also contains an immutable pre-migration snapshot under `org/src/`. Runtime normalization must preserve that provenance byte-for-byte. The suite-level style guide and the bundled copy used by `imsight-agent-skill-handling format` have drifted and must express the same contract after this change.

## Goals / Non-Goals

**Goals:**

- Establish one negative-only guardrail contract for all Imsight skill entrypoints and executable pages that use Guardrails.
- Preserve every operational requirement by relocating it before removing its guardrail copy.
- Remove requirements that merely duplicate existing workflows, contracts, constraints, quality gates, or linked primitives.
- Add a negative-only Guardrails section to every skill entrypoint.
- Keep the suite-level and bundled style guides semantically synchronized.
- Validate syntax, placement, entrypoint coverage, skill metadata, and immutable provenance.

**Non-Goals:**

- Renaming skills, public subcommands, output paths, or artifact contracts.
- Rewriting unrelated prose or restructuring entire workflows.
- Modifying migration provenance under any `org/src/` directory.
- Requiring every reference page to have Guardrails when it has no page-specific prohibition.

## Decisions

### Use a three-way migration for positive guardrail clauses

Each uppercase `MUST` clause will receive one semantic treatment: convert it into a genuine `DO NOT ...` prohibition when it describes a failure to prevent; absorb it into the closest workflow, procedure, contract, constraint, or output section when it carries unique positive behavior; or remove it when equivalent substantive content already exists. This avoids the semantic loss of a global textual replacement.

Alternative considered: mechanically replace `MUST X` with `DO NOT fail to X`. Rejected because it preserves operation steps in Guardrails under negative grammar and makes the new rule cosmetic.

### Treat `DO NOT forget ...` and positive semicolon tails as procedural smells

Guardrails that say `DO NOT forget to perform X` will be moved or removed because they are positive checklist items in disguise. A valid negative prohibition may keep a short rationale or reference, but a second imperative such as `use`, `target`, `keep`, or `split` belongs in substantive content.

Alternative considered: enforce only the `DO NOT` prefix. Rejected because prefix-only validation would accept the old procedural behavior under different wording.

### Require Guardrails on entrypoints and make them optional on detail pages

Every `SKILL.md` will carry a concise Guardrails section. Command and reference pages may carry Guardrails only when they need page-specific negative-action prevention. Empty or purely procedural Guardrails sections will be removed rather than retained for symmetry.

### Keep authoring guidance distinct from runtime Guardrails

The style guide section that explains the format will be named `Guardrail Authoring`, while fenced examples may still demonstrate an actual `## Guardrails` section. This distinction lets human and automated review identify actual runtime guardrail blocks without confusing meta-instructions for guardrail bullets.

### Preserve provenance and validate only active runtime instructions

Files under `org/src/` will not be edited. Runtime scans for uppercase `MUST`, entrypoint coverage, and guardrail form will exclude immutable provenance, generated assets, migration working documents, and OpenSpec artifacts. A separate Git diff check will confirm the provenance snapshot remains untouched.

## Risks / Trade-offs

- [Risk] Removing a positive clause could weaken behavior when its apparent duplicate is incomplete. → Mitigation: inspect the owning workflow or linked detail page before deletion and strengthen substantive content first when necessary.
- [Risk] Negative-only wording could become awkward double negation. → Mitigation: prefer direct prohibitions and relocate positive alternatives rather than writing `DO NOT fail to ...`.
- [Risk] The two style-guide copies could drift again. → Mitigation: update both in the same change and include a semantic comparison in validation.
- [Risk] A simple text scan could flag immutable provenance or examples. → Mitigation: scope scans to active runtime paths and use manual inspection for fenced examples and meta-authoring sections.
