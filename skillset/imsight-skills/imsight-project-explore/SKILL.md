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
- `help` summarizes this skill, the exploration loop, and the artifacts it may update.

## Project Directory

Use the project directory explicitly provided by the user. If none is provided, use the current working directory. Before creating or updating files, confirm the current directory looks like the intended project root unless the user already made that explicit.

## First Step: Establish Domain Language

Before entering any exploration mode, scan the project to establish a shared domain language baseline.

1. Inspect the codebase for project-specific terms: identifiers in code, schema fields, UI labels, test names, documentation headings, and any existing glossary (such as `CONTEXT.md`).
2. Build a candidate vocabulary of canonical terms and their definitions.
3. Ask the user to confirm, correct, or extend the candidate terms. Do not proceed to mode-specific exploration until the baseline vocabulary is accepted.
4. Write the established domain language to `docs/design/domain-language/<topic-name>.md` by default. If the directory does not yet contain a `README.md`, create one as an index of the domain language files. Only write to `.imsight-arts/project-explore/` when the user explicitly says the docs are untracked.

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

Only change domain language terms with explicit user consent. The default place to write them is `docs/design/domain-language/<topic-name>.md`; only update `CONTEXT.md` if the user explicitly says that is their project's glossary. Surface the conflict, give the evidence, recommend a resolution, and ask for the smallest needed decision.

## Capturing Knowledge

Update durable project artifacts inline when the session resolves durable knowledge.

- Domain language docs are tracked project content by default. Write them to `docs/design/domain-language/<topic-name>.md`. If the directory does not yet contain a `README.md`, create one as an index of the domain language files. Load `references/DOMAIN-LANGUAGE-FORMAT.md` before creating or editing domain language docs. Do not put specs, implementation choices, tasks, or scratch notes there.
- ADRs are tracked project content by default. Write them to `docs/design/adrs/<topic-name>/<index>-<what>.md`. Load `references/ADR-FORMAT.md` before creating or updating one.
- In `review-decision`, review existing ADRs, decision sections, architecture notes, and code behavior before proposing any new decision. Report inconsistencies first; update durable artifacts only after the inconsistency has a resolved answer.
- Use an existing spec, issue, PRD, or design doc when the exploration resolves feature behavior, acceptance criteria, scope, or non-goals.
- If no durable artifact exists and the user asked for a written result, ask whether the output should be tracked or untracked. By default, write tracked exploration summaries to `docs/design/exploration/<topic-name>.md`. Only write to `.imsight-arts/project-explore/` when the user explicitly says the exploration docs are untracked.

Do not start implementation unless the user explicitly asks to switch from exploration to implementation.
