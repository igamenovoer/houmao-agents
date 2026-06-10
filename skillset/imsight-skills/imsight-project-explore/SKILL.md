---
name: imsight-project-explore
description: Imsight-authored agent-assisted exploration workflow for development projects. Use when explicitly invoked as imsight-project-explore, routed from another Imsight skill, or when an Imsight-scoped request asks to explore a project before implementation, clarify specs, feature behavior, scope boundaries, acceptance criteria, ambiguities, domain terminology, plan risks, or contradictions between docs and code. Do not invoke for implementation-only tasks unless exploration is requested first.
---

# Imsight Project Explore

## Overview

Use this skill to explore a development project before planning or building. Treat the user's proposal, issue, feature idea, or spec as a hypothesis to test against the repository's existing docs, code, tests, terminology, and product boundaries.

## Invocation Contract

- Preferred explicit form: `$imsight-project-explore <task prompt>`.
- Task-only form uses `auto` exploration by default.
- Select `feature-scope`, `domain-language`, or `review-decision` only when the user's prompt explicitly names that mode or clearly asks for that kind of focused exploration.
- No actionable task means `help`.

## Project Directory

Use the project directory explicitly provided by the user. If none is provided, use the current working directory. Before creating or updating files, confirm the current directory looks like the intended project root unless the user already made that explicit.

## Output Directory Discovery

When this skill writes artifacts, resolve `<output-dir>` in this priority:

1. An output location explicitly provided by the user.
2. If the user is targeting an OpenSpec change, use `<openspec-change-dir>/explore` (e.g., `openspec/changes/<change-name>/explore`). [OpenSpec](https://github.com/Fission-AI/OpenSpec) is a structured, artifact-driven spec workflow; when the prompt names a change directory or references a change-specific artifact, treat that change as the exploration scope.
3. The directory named in the `IMSIGHT_SKILL_OUTPUT_DIR` environment variable (relative or absolute).
4. `<project-dir>/.imsight-arts/project-explore/` by default.

Only write to `docs/design/` if the user explicitly requests tracked project docs.

## First Step: Establish Domain Language

Before entering any exploration mode, scan the project to establish a shared domain language baseline.

1. Inspect the codebase for project-specific terms: identifiers in code, schema fields, UI labels, test names, documentation headings, and any existing glossary (such as `CONTEXT.md`).
2. Build a candidate vocabulary of canonical terms and their definitions.
3. Ask the user to confirm, correct, or extend the candidate terms. Do not proceed to mode-specific exploration until the baseline vocabulary is accepted.
4. Write the established domain language following the artifact rules in **Capturing Knowledge** below.

If the project already has an established domain language document that the user accepts as authoritative, skip this step and load it instead.

## Exploration Modes

| Mode | Use For | Detail |
| --- | --- | --- |
| `auto` | Let the agent decide what to explore from the prompt, repo evidence, and highest-risk unknowns | [modes/auto.md](modes/auto.md) |
| `feature-scope` | Clarify a feature's target users, behaviors, boundaries, non-goals, and acceptance criteria | [modes/feature-scope.md](modes/feature-scope.md) |
| `domain-language` | Resolve project-specific terms and terminology conflicts | [modes/domain-language.md](modes/domain-language.md) |
| `review-decision` | Review existing decisions for consistency, drift, stale assumptions, and missing trade-offs | [modes/review-decision.md](modes/review-decision.md) |

Use `auto` as the default exploration mode. In `auto`, inspect the prompt and early repo evidence, choose what to explore, state the chosen focus, and continue. Choose another mode only from the user's prompt: explicit mode names, direct requests about feature scope, terminology, or decision review, or wording that clearly maps to one focused mode. Combine modes only when the request naturally spans them.

## Core Principles

### 1. Read the project context first

If a question can be answered by exploring the codebase, inspect the codebase instead of asking the user.

Look for coding agent context files (such as `AGENTS.md` or `.cursor/`), project documentation, domain memory (such as `CONTEXT.md`, architecture docs, or ADRs), and behavior surfaces (routes, schemas, tests, migrations, UI labels, CLI commands). Also look for similar existing features that imply naming, permissions, lifecycle states, error handling, or acceptance criteria.

Use targeted search and file reads before broad exploration. Cite file paths and line numbers when reporting evidence or contradictions.

### 2. Pay attention to domain language

Watch for discrepancies between the user's terms and the terms used in the codebase. Challenge the user when:

- Their term conflicts with the existing glossary (such as `CONTEXT.md`) or the dominant usage in code.
- The same concept has multiple names across docs, tests, and code.
- A term is overloaded or ambiguous in a way that affects implementation or tests.

Only change domain language terms with explicit user consent. Write them following the artifact rules in **Capturing Knowledge** below; only update `CONTEXT.md` if the user explicitly says that is their project's glossary. Surface the conflict, give the evidence, recommend a resolution, and ask for the smallest needed decision.

## Capturing Knowledge

Update durable project artifacts inline when the session resolves durable knowledge. All paths below are relative to `<output-dir>`, resolved by the **Output Directory Discovery** rules above.

| Artifact | Path | Reference |
| --- | --- | --- |
| Domain concepts | `domain-concepts/dc-<what>.md` | `references/DOMAIN-CONCEPTS-FORMAT.md` |
| ADRs | `adrs/<index>-<what>.md` | `references/ADR-FORMAT.md` |
| Feature scope | `feature-scope/feat-<what>.md` | — |

When creating the first file in `domain-concepts/` or `feature-scope/`, also create a `README.md` index in that directory. ADRs are durable project content; whether they are version-controlled depends on whether `<output-dir>` itself is tracked. Only write to `docs/design/` if the user explicitly requests tracked project docs.

### Consistency discipline

After writing or updating any artifact, scan all other documents under `<output-dir>/` for references to the same concepts, decisions, or terms. If the new content invalidates, contradicts, or extends an existing document, update the affected document to restore consistency. Do not leave stale definitions or outdated decisions across artifacts.

### OpenSpec synchronization

When `<output-dir>` is inside an OpenSpec change (i.e., `<openspec-change-dir>/explore`), also scan the OpenSpec change artifacts themselves — `proposal.md`, `design.md`, `tasks.md`, and specs under `specs/` — for references to the same topics. If a new decision or domain concept contradicts or extends the OpenSpec artifacts, update the relevant OpenSpec documents or flag the inconsistency to the user before proceeding.

- Use an existing spec, issue, PRD, or design doc when the exploration resolves feature behavior, acceptance criteria, scope, or non-goals.
- In `review-decision`, review existing ADRs, decision sections, architecture notes, and code behavior before proposing any new decision. Report inconsistencies first; update durable artifacts only after the inconsistency has a resolved answer.

Do not start implementation unless the user explicitly asks to switch from exploration to implementation.
