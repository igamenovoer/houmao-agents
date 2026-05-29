---
name: imsight-project-explore
description: Imsight-authored agent-assisted exploration workflow for development projects. Use when explicitly invoked as imsight-project-explore, routed from another Imsight skill, or when an Imsight-scoped request asks to explore a project before implementation, clarify specs, feature behavior, scope boundaries, acceptance criteria, ambiguities, domain terminology, plan risks, or contradictions between docs and code. Do not invoke for implementation-only tasks unless exploration is requested first.
---

# Imsight Project Explore

## Overview

Use this skill to explore a development project before planning or building. Treat the user's proposal, issue, feature idea, or spec as a hypothesis to test against the repository's existing docs, code, tests, terminology, and product boundaries.

This skill adapts the `grill-with-docs` style: inspect the repo before asking, challenge fuzzy language, ask one unresolved question at a time, recommend an answer, and capture resolved knowledge in the right project artifact.

## Invocation Contract

- Preferred explicit form: `$imsight-project-explore <task prompt>`.
- Task-only form uses `auto` exploration by default.
- Select `feature-scope`, `domain-language`, or `review-decision` only when the user's prompt explicitly names that mode or clearly asks for that kind of focused exploration.
- No actionable task means `help`.
- `help` summarizes this skill, the exploration loop, and the artifacts it may update.

## Project Directory

Use the project directory explicitly provided by the user. If none is provided, use the current working directory. Before creating or updating files, confirm the current directory looks like the intended project root unless the user already made that explicit.

## Exploration Modes

| Mode | Use For | Artifact Bias |
| --- | --- | --- |
| `auto` | Let the agent decide what to explore from the prompt, repo evidence, and highest-risk unknowns | State the chosen focus before proceeding |
| `feature-scope` | Clarify a feature's target users, behaviors, boundaries, non-goals, and acceptance criteria | Existing spec/issue, or exploration summary |
| `domain-language` | Resolve project-specific terms and terminology conflicts | `CONTEXT.md` using `references/CONTEXT-FORMAT.md` |
| `review-decision` | Review existing decisions for logical consistency, conflict with code/docs/tests, stale assumptions, missing trade-offs, or implementation drift | Existing ADRs, specs, architecture notes, and code evidence |

Use `auto` as the default exploration mode. In `auto`, inspect the prompt and early repo evidence, choose what to explore, state the chosen focus, and continue. Choose another mode only from the user's prompt: explicit mode names, direct requests about feature scope, terminology, or decision review, or wording that clearly maps to one focused mode. Combine modes only when the request naturally spans them.

## Evidence First

If a question can be answered by exploring the codebase, inspect the codebase instead of asking the user.

Start by looking for:

- Project guidance: `AGENTS.md`, `CLAUDE.md`, `.agents/`, `.cursor/`, `.github/copilot-instructions.md`.
- Product/spec material: `README.md`, `docs/`, `specs/`, `features/`, issue or PRD files, roadmap notes.
- Domain memory: `CONTEXT.md`, `docs/adr/`, architecture docs, design docs.
- Behavior surfaces: routes, controllers, API schemas, UI pages, CLI commands, migrations, test names, fixtures.
- Similar existing features that imply naming, permissions, lifecycle states, error handling, or acceptance criteria.

Use `rg` and targeted file reads before broad exploration. Cite file paths and line numbers when reporting evidence or contradictions.

## Exploration Loop

1. Restate the exploration target in one or two concrete sentences.
2. Identify the current evidence set: docs read, code areas inspected, tests or schemas checked.
3. Build a decision tree covering goal, user, entry point, states, data ownership, permissions, edge cases, out-of-scope behavior, rollout, and tests.
4. Resolve every branch that the repo already answers.
5. Ask exactly one unresolved question at a time.
6. For each question, include:
   - `Question`: the specific decision needed.
   - `Recommended answer`: the answer you would choose from the evidence.
   - `Why it matters`: the downstream implementation, UX, data, or testing consequence.
   - `Evidence`: file references or documented facts that shaped the recommendation.
   - `Unlocks`: what can be decided after this.
7. After the user answers, update the exploration state and continue to the next highest-leverage question.
8. Stop when the remaining unknowns are either deliberately out of scope or not blocking the user's next action.

## Challenge Rules

Call out contradictions immediately:

- The user's term conflicts with `CONTEXT.md`.
- The requested behavior disagrees with existing code, tests, docs, routes, schemas, or UI affordances.
- An existing decision contradicts another decision, current code, current tests, or current docs.
- The plan assumes a capability that the project does not appear to have.
- The scope mixes product goals, implementation details, and unrelated cleanup.
- The spec says "simple", "basic", "support", "handle", "manage", or "integrate" without observable behavior.

State the conflict, give the evidence, recommend a resolution, and ask for the smallest needed decision.

## Scope Discipline

Separate findings into:

- `In scope`: behavior the feature or spec must include.
- `Out of scope`: tempting work that should not block the requested outcome.
- `Open questions`: decisions that still need the user.
- `Assumptions`: decisions made provisionally from repo evidence.
- `Risks`: uncertainty that could break implementation, testing, migration, or user expectations.

When a feature can be sliced vertically, prefer a narrow end-to-end slice over broad partial infrastructure. Name the slice in terms of user-visible behavior.

## Capturing Knowledge

Update durable project artifacts inline when the session resolves durable knowledge.

- Use `CONTEXT.md` only for project-specific domain terms. Do not put specs, implementation choices, tasks, or scratch notes there. Load `references/CONTEXT-FORMAT.md` before editing it.
- Use ADRs sparingly for hard-to-reverse, surprising, trade-off-driven decisions. Load `references/ADR-FORMAT.md` before creating or updating one.
- In `review-decision`, review existing ADRs, decision sections, architecture notes, and code behavior before proposing any new decision. Report inconsistencies first; update durable artifacts only after the inconsistency has a resolved answer.
- Use an existing spec, issue, PRD, or design doc when the exploration resolves feature behavior, acceptance criteria, scope, or non-goals.
- If no durable artifact exists and the user asked for a written result, write an exploration summary under the output directory.

When writing skill-owned exploration summaries, choose the output directory in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/project-explore/`.

## Final Output

When the exploration is complete or paused, summarize:

- Scope decision: what is in and out.
- Resolved behavior: concrete feature/spec decisions.
- Open questions: only unresolved blockers.
- Evidence: most important docs/code references.
- Suggested next action: spec update, decision review report, ADR update, issue breakdown, implementation plan, or handoff to another Imsight skill.

Do not start implementation unless the user explicitly asks to switch from exploration to implementation.
