# Imsight Project Explore

An Imsight skill for repo-grounded exploration before implementation. It clarifies feature scope, specs, terminology, and ambiguity by combining codebase inspection with focused user questions.

## Language

**Exploration session**:
A structured conversation and repository inspection pass that turns a fuzzy project request into concrete scope, evidence, decisions, and open questions.
_Avoid_: brainstorm, vague planning chat

**Evidence**:
Project material that can answer or constrain a question, such as code, tests, routes, schemas, docs, specs, issues, ADRs, or existing UI behavior.
_Avoid_: hunch, guess, vibes

**Feature boundary**:
The line between behavior included in the requested feature and behavior that is intentionally excluded or deferred.
_Avoid_: rough scope, nice-to-have list

**Spec surface**:
Any existing place where intended behavior is expressed, including a formal spec, PRD, issue, test fixture, route contract, API schema, or user-facing copy.
_Avoid_: spec only when it means a single document

**Ambiguity**:
A missing, overloaded, or contradictory decision that can change implementation, testing, UX, data shape, permissions, or rollout.
_Avoid_: minor wording issue

**Resolved decision**:
A choice accepted by the user or forced by repository evidence that can now guide specs, implementation, or tests.
_Avoid_: assumption when the choice is still provisional

**Decision review**:
An evidence-backed review of existing project decisions for logical consistency, conflict with current code or docs, stale assumptions, and implementation drift.
_Avoid_: new ADR drafting when the task is to check existing decisions

**Implementation drift**:
A mismatch between a documented decision and the behavior now present in code, tests, schemas, configuration, or user-facing surfaces.
_Avoid_: inconsistency when the mismatch is specifically between decision and implementation

**Recommended answer**:
The answer the agent would choose for an unresolved question, backed by evidence and downstream consequences.
_Avoid_: neutral option list when one option is clearly better

**Durable artifact**:
A project file that should preserve resolved knowledge beyond the conversation, such as `CONTEXT.md`, `docs/adr/`, a spec, a PRD, or an issue.
_Avoid_: transient chat summary

## Relationships

- An **Exploration session** gathers **Evidence**.
- **Evidence** exposes **Ambiguity** and constrains **Recommended answers**.
- A **Resolved decision** can update a **Feature boundary**, **Spec surface**, or **Durable artifact**.
- A **Decision review** looks for **Implementation drift** and unresolved **Ambiguity** in existing **Durable artifacts**.

## Flagged Ambiguities

- "Explore" does not mean implement. This skill may inspect code and update durable docs, but it should not build the feature unless the user explicitly switches modes.
- "Spec" may refer to formal documentation, issues, tests, code contracts, or product copy. Resolve which **Spec surface** is authoritative before editing.
- "Scope" must include both positive behavior and explicit non-goals.
