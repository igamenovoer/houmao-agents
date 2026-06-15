---
name: imsight-project-explore
description: Imsight-authored agent-assisted exploration workflow for development projects. Use when explicitly invoked as imsight-project-explore, routed from another Imsight skill, or when an Imsight-scoped request asks to explore a project before implementation, clarify specs, feature behavior, scope boundaries, acceptance criteria, ambiguities, domain terminology, plan risks, or contradictions between docs and code. Do not invoke for implementation-only tasks unless exploration is requested first.
---

# Imsight Project Explore

## Overview

Use this skill to explore a development project before planning or building. Treat the user's proposal, issue, feature idea, or spec as a hypothesis to test against the repository's existing docs, code, tests, terminology, and product boundaries.

Exploration is interactive by default. In `auto` mode, the agent may inspect repository evidence and choose the exploration type itself, such as `feature-scope`, `domain-language`, or `review-decision`. After that routing choice, the agent must ask the user at least one decision-bearing question before choosing a durable project direction, writing artifacts, or producing a final proposed direction. Use zero questions only when the user explicitly requests a non-interactive audit, explicitly asks the agent to make reasonable assumptions, or provides all required decisions in the prompt.

## Workflow

When this skill is invoked, execute the following steps in order. Detailed rules for each step are in the sections referenced below.

1. **Determine the project directory**. See **Project Directory**.
2. **Resolve `<output-dir>`**. See **Output Directory Discovery**.
3. **Load previous exploration artifacts**. Check `<output-dir>/` for existing `domain-concepts/`, `adrs/`, and `feature-scope/` files. Load any relevant prior artifacts and incorporate them into your evidence set. See Core Principles §1.
4. **Prepare domain language baseline**. See **First Step: Establish Domain Language**. If accepting or changing domain language requires a project decision, ask the user before treating it as established.
5. **Select exploration mode**. Inspect the user's prompt and early repository evidence against the **Exploration Modes** table:
   - If the prompt explicitly names a mode (`feature-scope`, `domain-language`, `review-decision`, `brainstorm`) or clearly asks for that kind of work, use that mode.
   - Otherwise, default to `auto`.
   - If the prompt spans multiple modes naturally, combine them sequentially.
6. **Execute the selected mode's workflow**. Load the mode's page (linked in the **Exploration Modes** table) and follow its **Workflow** section step by step.
7. **Capture durable knowledge**. Follow the **Capturing Knowledge** rules when writing or updating artifacts.
8. **Do not start implementation** unless the user explicitly asks to switch from exploration to implementation.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan based on the available modes, constraints above, and the user's specific goal, then execute the plan.

## Invocation Contract

- Preferred explicit form: `$imsight-project-explore <task prompt>`.
- Task-only form uses `auto` exploration by default.
- Outside `auto`, select `feature-scope`, `domain-language`, `review-decision`, or `brainstorm` only when the user's prompt explicitly names that mode or clearly asks for that kind of focused exploration. Inside `auto`, the agent may choose the focused exploration type after inspecting the prompt and repository evidence.
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

## First Step: Prepare Domain Language

Before entering any exploration mode, scan the project for domain language that may affect the exploration. This scan informs mode selection and question quality; it does not authorize the agent to make terminology decisions without user consent.

1. Check `<output-dir>/domain-concepts/` for previously established domain language. If it exists, load it and treat it as the starting baseline instead of building from scratch.
2. Inspect the codebase for project-specific terms: identifiers in code, schema fields, UI labels, test names, documentation headings, and any existing glossary (such as `CONTEXT.md`).
3. Build a candidate vocabulary of canonical terms and their definitions, extending or correcting the previous baseline if one exists.
4. If the vocabulary affects the selected exploration type, artifact content, naming, or downstream implementation, ask the user to confirm, correct, or extend the candidate terms before treating them as established.
5. Write established domain language following the artifact rules in **Capturing Knowledge** below only after user consent.

If the project already has an established domain language document that the user accepts as authoritative, skip this step and load it instead.

## Exploration Modes

| Mode | Use For | Detail |
| --- | --- | --- |
| `auto` | Let the agent choose the exploration type from the prompt, repo evidence, and highest-risk uncertainty | [modes/auto.md](modes/auto.md) |
| `feature-scope` | Clarify a feature's target users, behaviors, boundaries, non-goals, and acceptance criteria | [modes/feature-scope.md](modes/feature-scope.md) |
| `domain-language` | Resolve project-specific terms and terminology conflicts | [modes/domain-language.md](modes/domain-language.md) |
| `review-decision` | Review existing decisions for consistency, drift, stale assumptions, and missing trade-offs | [modes/review-decision.md](modes/review-decision.md) |
| `brainstorm` | Turn a vague idea or product concept into an approved system design before implementation | [subskills/brainstorm.md](subskills/brainstorm.md) |

Use `auto` as the default exploration mode. In `auto`, inspect the prompt and early repo evidence, choose the most relevant exploration type, state that routing choice, and proceed into that mode's questioning loop. The routing choice itself does not require user confirmation. Any substantive product, terminology, scope, ADR, artifact, or implementation-impacting decision after routing requires user consent. Choose another mode from the user's prompt, explicit mode names, direct requests about feature scope, terminology, decision review, or system design brainstorming, wording that clearly maps to one focused mode, or the agent's evidence-based routing judgment in `auto`. Combine modes only when the request naturally spans them.

## Core Principles

### 1. Read the project context first

If a question can be answered by exploring the codebase, inspect the codebase instead of asking the user.

Do not treat repository evidence as a substitute for product intent, priority, risk tolerance, domain terminology ownership, or acceptance criteria. When evidence suggests a direction but user intent is not explicit, present it as a proposal inside a question and wait for confirmation.

Look for coding agent context files (such as `AGENTS.md` or `.cursor/`), project documentation, domain memory (such as `CONTEXT.md`, architecture docs, or ADRs), and behavior surfaces (routes, schemas, tests, migrations, UI labels, CLI commands). Also look for similar existing features that imply naming, permissions, lifecycle states, error handling, or acceptance criteria.

Before creating any new artifact, check `<output-dir>/` for previous exploration results. Load existing `domain-concepts/`, `adrs/`, and `feature-scope/` files and incorporate them into your evidence set. Do not duplicate or contradict prior exploration without explicitly noting the conflict.

Use targeted search and file reads before broad exploration. Cite file paths and line numbers when reporting evidence or contradictions.

### 2. Pay attention to domain language

Watch for discrepancies between the user's terms and the terms used in the codebase. Challenge the user when:

- Their term conflicts with the existing glossary (such as `CONTEXT.md`) or the dominant usage in code.
- The same concept has multiple names across docs, tests, and code.
- A term is overloaded or ambiguous in a way that affects implementation or tests.

Only change domain language terms with explicit user consent. Write them following the artifact rules in **Capturing Knowledge** below; only update `CONTEXT.md` if the user explicitly says that is their project's glossary. Surface the conflict, give the evidence, propose a resolution, and ask for the smallest needed decision.

## Capturing Knowledge

Update durable project artifacts inline when the session resolves durable knowledge. All paths below are relative to `<output-dir>`, resolved by the **Output Directory Discovery** rules above.

| Artifact | Path | Reference |
| --- | --- | --- |
| Domain concepts | `domain-concepts/dc-<what>.md` | `references/DOMAIN-CONCEPTS-FORMAT.md` |
| ADRs | `adrs/<index>-<what>.md` | `references/ADR-FORMAT.md` |
| Feature scope | `feature-scope/feat-<what>.md` | — |
| Design | `designs/YYYY-MM-DD-<topic>-design.md` | `subskills/brainstorm.md` |

When creating the first file in `domain-concepts/`, `feature-scope/`, or `designs/`, also create a `README.md` index in that directory. ADRs are durable project content; whether they are version-controlled depends on whether `<output-dir>` itself is tracked. Only write to `docs/design/` if the user explicitly requests tracked project docs.

### Consistency discipline

After writing or updating any artifact, scan all other documents under `<output-dir>/` for references to the same concepts, decisions, or terms. If the new content invalidates, contradicts, or extends an existing document, update the affected document to restore consistency. Do not leave stale definitions or outdated decisions across artifacts.

### OpenSpec synchronization

When `<output-dir>` is inside an OpenSpec change (i.e., `<openspec-change-dir>/explore`), also scan the OpenSpec change artifacts themselves — `proposal.md`, `design.md`, `tasks.md`, and specs under `specs/` — for references to the same topics. If a new decision or domain concept contradicts or extends the OpenSpec artifacts, update the relevant OpenSpec documents or flag the inconsistency to the user before proceeding.

- Use an existing spec, issue, PRD, or design doc when the exploration resolves feature behavior, acceptance criteria, scope, or non-goals.
- In `review-decision`, review existing ADRs, decision sections, architecture notes, and code behavior before proposing any new decision. Report inconsistencies first; update durable artifacts only after the inconsistency has a resolved answer.

Do not start implementation unless the user explicitly asks to switch from exploration to implementation.
