# Feature Scope Exploration Mode

Use `feature-scope` when the user's prompt is about a feature, user story, or behavior change. Clarify who it is for, what it does, what it explicitly does not do, and how to know it is done. Ask up to 5 highly targeted clarification questions.

## When to Use

- The user describes a new feature, enhancement, or change in behavior.
- The prompt includes phrases like "support X", "handle Y", "integrate Z", or "add a way to..."
- There is no clear acceptance criteria or boundary stated.

## Pre-Exploration Scan

Before asking any user-facing question, inspect the repo for:

- **Similar existing features**: How are they named, tested, and scoped? What permissions and error patterns do they use?
- **Behavior surfaces**: Routes, controllers, API schemas, UI pages, CLI commands, migrations, test names, fixtures.
- **Product material**: `README.md`, `docs/`, `specs/`, `features/`, issue or PRD files.
- **Domain memory**: `CONTEXT.md`, `<output-dir>/adrs/`, architecture docs that constrain the feature.

Cite file paths and line numbers when reporting evidence.

## Coverage Scan

Perform a structured ambiguity & coverage scan across this taxonomy. For each category, mark status: **Clear** / **Partial** / **Missing**. Produce an internal coverage map (do not output the raw map unless no questions will be asked).

| Category | What to Check |
| --- | --- |
| **Functional Scope & Behavior** | Core user goals & success criteria; explicit out-of-scope declarations; user roles / personas differentiation |
| **Domain & Data Model** | Entities, attributes, relationships; identity & uniqueness rules; lifecycle/state transitions; data volume / scale assumptions |
| **Interaction & UX Flow** | Critical user journeys / sequences; error/empty/loading states; accessibility or localization notes |
| **Non-Functional Quality Attributes** | Performance targets; reliability & availability; observability signals; security & privacy posture |
| **Integration & External Dependencies** | External services/APIs and failure modes; data import/export formats; protocol/versioning assumptions |
| **Edge Cases & Failure Handling** | Negative scenarios; rate limiting / throttling; conflict resolution (e.g., concurrent edits) |
| **Constraints & Tradeoffs** | Technical constraints; explicit tradeoffs or rejected alternatives visible in code or docs |
| **Terminology & Consistency** | Canonical glossary terms; avoided synonyms / deprecated terms; conflicts with the existing glossary |
| **Completion Signals** | Acceptance criteria testability; measurable Definition of Done style indicators |
| **Misc / Placeholders** | TODO markers / unresolved decisions; ambiguous adjectives ("robust", "intuitive") lacking quantification |

For each category with **Partial** or **Missing** status, add a candidate question opportunity unless:
- Clarification would not materially change implementation or validation strategy
- Information is better deferred to the planning phase (note internally)

## Question Constraints

- **Maximum 5 total questions** across the whole session.
- Each question must be answerable with **either**:
  - A short multiple-choice selection (2–5 distinct, mutually exclusive options), **or**
  - A short-phrase answer. The agent's suggested answer should be concise, but the user may provide a custom answer of any length.
- Only include questions whose answers materially impact architecture, data modeling, task decomposition, test design, UX behavior, operational readiness, or compliance validation.
- Ensure category coverage balance: attempt to cover the highest impact unresolved categories first; avoid asking two low-impact questions when a single high-impact area (e.g., security posture) is unresolved.
- Exclude questions already answered by repo evidence, trivial stylistic preferences, or plan-level execution details (unless blocking correctness).
- Favor clarifications that reduce downstream rework risk or prevent misaligned acceptance tests.
- If more than 5 categories remain unresolved, select the top 5 by (Impact × Uncertainty) heuristic.
- Do not reveal future queued questions in advance.

## Sequential Questioning Loop

Present **exactly one question at a time**.

### For Multiple-Choice Questions

Before presenting the options, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts architecture, data modeling, task decomposition, test design, UX behavior, operational readiness, or compliance validation.
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows how each option would play out in practice.

Then analyze all options and determine the **most suitable option** based on:

- Best practices for the project type
- Common patterns in similar implementations
- Risk reduction (security, performance, maintainability)
- Alignment with any explicit project goals or constraints visible in the spec

Present your **recommended option prominently** at the top with:
- The recommendation itself.
- **Why it is recommended** (1–2 sentences).
- **Implication** — what happens downstream if this option is chosen (e.g., which files change, which assumptions hold, which risks are accepted).

Format as:

```
**Recommended:** Option [X] - <why recommended>

**Implication:** <downstream consequence>
```

Then render all options as a Markdown table that includes a **Pros/Cons** column:

| Option | Description | Pros/Cons |
| --- | --- | --- |
| A | ... | Pros: ... Cons: ... |
| B | ... | Pros: ... Cons: ... |
| C | ... | Pros: ... Cons: ... |
| Short | Provide a different answer (any length) | — |

After the table, add:

```
You can reply with the option letter (e.g., "A"), accept the recommendation by saying "yes" or "recommended", or provide your own answer.
```

### For Short-Answer Questions

Before presenting the suggested answer, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts architecture, data modeling, task decomposition, test design, UX behavior, operational readiness, or compliance validation.
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows why the answer matters.

Then provide your **suggested answer** with:
- The suggestion itself.
- **Brief reasoning**.
- **Implication** — what happens downstream if this answer is chosen.

Format as:

```
**Suggested:** <your proposed answer> - <brief reasoning>

**Implication:** <downstream consequence>
```

Then output:

```
Format: Short answer. You can accept the suggestion by saying "yes" or "suggested", or provide your own answer.
```

### After the User Answers

- If the user replies with "yes", "recommended", or "suggested", use your previously stated recommendation/suggestion as the answer.
- Otherwise, validate the answer maps to one option or is a valid custom answer.
- If ambiguous, ask for a quick disambiguation (this still counts as the same question; do not advance the counter).
- Once satisfactory, record it in working memory, update the exploration state, and move to the next queued question.

**Stop asking** when:
- All critical ambiguities are resolved early (remaining queued items become unnecessary), **or**
- The user signals completion ("done", "good", "no more", "stop", "proceed"), **or**
- You reach 5 asked questions.

If no valid questions exist at the start, immediately report: "No critical ambiguities detected worth formal clarification." and suggest proceeding.

## Integration After Each Answer

- Maintain an in-memory representation of the exploration state plus the raw evidence set.
- After each accepted answer, apply the clarification to the most appropriate category in the coverage map:
  - Functional ambiguity → Update scope / behavior notes
  - User interaction / actor distinction → Update user roles or entry points
  - Data shape / entities → Update data model notes
  - Non-functional constraint → Add measurable criteria
  - Edge case / negative flow → Add error-handling notes
  - Terminology conflict → Normalize term across notes; if the conflict is durable, also update `<output-dir>/domain-concepts/dc-<what>.md`
- If the clarification invalidates an earlier ambiguous statement, replace that statement instead of duplicating; leave no obsolete contradictory text.
- If an existing spec, issue, PRD, or design doc is the target artifact, update it incrementally after each answer (atomic overwrite). Preserve formatting and heading hierarchy.
- If the answer resolves a decision that is hard to reverse, surprising without context, or involves a real trade-off, write an ADR immediately to `<output-dir>/adrs/<index>-<what>.md`. Load `references/ADR-FORMAT.md` before creating it. Do not batch ADRs; create them as decisions are made.
- If the user asked for a written result or the session is pausing, write the accumulated scope notes to `<output-dir>/feature-scope/feat-<what>.md`. If the `feature-scope/` directory does not yet contain a `README.md`, create one as an index.
- After writing or updating any artifact, scan all other documents under `<output-dir>/` for references to the same concepts, decisions, or terms. Update affected documents to restore consistency.
- When working with an OpenSpec change, also scan the OpenSpec change artifacts (`proposal.md`, `design.md`, `tasks.md`, and specs under `specs/`) for references to the same topics. Update the relevant OpenSpec documents or flag the inconsistency to the user.

## Completion Report

When the exploration is complete or paused, summarize:

- **Questions asked & answered**: count.
- **Scope decision**: what is in and out.
- **Resolved behavior**: concrete feature/spec decisions.
- **Open questions**: only unresolved blockers.
- **Evidence**: most important docs/code references.
- **Coverage summary**: for each taxonomy category, state Resolved / Deferred / Clear / Outstanding.
- **Suggested next action**: spec update, decision review report, ADR update, issue breakdown, implementation plan, or handoff to another Imsight skill.

Prefer a narrow end-to-end slice over broad partial infrastructure. Name the slice in terms of user-visible behavior.
