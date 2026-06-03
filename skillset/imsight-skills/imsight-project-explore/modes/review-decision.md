# Review Decision Exploration Mode

Use `review-decision` when the user's prompt asks to review, validate, or audit existing project decisions. Check for logical consistency, conflicts with current code/docs/tests, stale assumptions, missing trade-offs, and implementation drift. Ask up to 5 highly targeted clarification questions.

## When to Use

- The prompt asks to "review ADRs", "audit decisions", "check for drift", or "validate architecture".
- The user suspects a documented decision no longer matches the codebase.
- A planned change may conflict with an existing architectural boundary or constraint.

## Pre-Exploration Scan

Before asking any user-facing question, inspect the repo for:

- **Decision artifacts**: `docs/design/adrs/`, architecture docs, design docs, decision sections in specs, inline code comments recording intent.
- **Current evidence**: code, tests, schemas, configs, routes, UI behavior, deployment manifests.
- **Product constraints**: `README.md`, `AGENTS.md`, compliance or partner contract references.

Cite file paths and line numbers when reporting evidence.

## Coverage Scan

Perform a structured ambiguity & coverage scan across this taxonomy. For each category, mark status: **Clear** / **Partial** / **Missing**. Produce an internal coverage map (do not output the raw map unless no questions will be asked).

| Category | What to Check |
| --- | --- |
| **Decision inventory** | What ADRs, architecture notes, and spec decision sections exist? Are any missing that should exist? |
| **Logical consistency** | Does each decision still make sense given current project goals? |
| **Cross-decision conflicts** | Do any two decisions contradict each other? |
| **Code drift** | Does the decision conflict with current code behavior? |
| **Test drift** | Do tests enforce behavior that violates the decision? |
| **Documentation drift** | Do README or API docs describe behavior the decision forbids? |
| **Stale assumptions** | Are the dependencies, scale, team size, or compliance assumptions still true? |
| **Missing trade-offs** | Were genuine alternatives evaluated? Are there new trade-offs not captured? |
| **Reversal cost** | Is the cost of reversing the decision meaningful? If not, did it need an ADR? |
| **Impact of change** | What code, tests, or docs would need to change if the decision is updated? |

For each category with **Partial** or **Missing** status, add a candidate question opportunity unless:
- The ambiguity is low-impact and does not affect correctness or maintainability
- The issue is purely cosmetic (formatting, wording) rather than substance

## Question Constraints

- **Maximum 5 total questions** across the whole session.
- Each question must be answerable with **either**:
  - A short multiple-choice selection (2–5 distinct, mutually exclusive options), **or**
  - A short-phrase answer. The agent's suggested answer should be concise, but the user may provide a custom answer of any length.
- Only include questions whose answers materially impact whether a decision should be updated, deprecated, or re-affirmed, or what code/docs changes are required.
- Ensure category coverage balance: attempt to cover the highest impact unresolved categories first; avoid asking two low-impact questions when a single high-impact area (e.g., a security or data-ownership decision) is unresolved.
- Exclude questions already answered by repo evidence or plan-level execution details (unless blocking correctness).
- Favor clarifications that reduce risk of building on top of a stale or contradictory decision.
- If more than 5 categories remain unresolved, select the top 5 by (Impact × Uncertainty) heuristic.
- Do not reveal future queued questions in advance.

## Sequential Questioning Loop

Present **exactly one question at a time**.

### For Multiple-Choice Questions

Before presenting the options, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts whether a decision should be updated, deprecated, or re-affirmed, or what code/docs changes are required.
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows how each option would play out in practice (e.g., a future PR that violates the current ADR, or a test that enforces drifted behavior).

Then analyze all options and determine the **most suitable option** based on:

- Best practices for the project type
- Current codebase evidence (what the code actually does)
- Risk reduction (security, performance, maintainability)
- Alignment with any explicit project goals or constraints

Present your **recommended option prominently** at the top with:
- The recommendation itself.
- **Why it is recommended** (1–2 sentences).
- **Implication** — what happens downstream if this option is chosen (e.g., which ADRs to update, which code to amend, which tests to change).

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

1. **Motivation** — state the question clearly and explain why the answer materially impacts whether a decision should be updated, deprecated, or re-affirmed, or what code/docs changes are required.
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

- Maintain an in-memory representation of the decision review state plus the raw evidence set.
- Load `references/ADR-FORMAT.md` before creating or updating any ADR.
- After each accepted answer, apply the clarification:
  - If the answer resolves a drift, note whether to update the ADR, amend code to match, deprecate the decision, or document the drift as accepted.
  - If the answer invalidates an earlier ambiguous statement, replace that statement instead of duplicating; leave no obsolete contradictory text.
  - Update durable artifacts only after the inconsistency has a resolved answer.
- Do not write new ADRs during review unless the user explicitly requests one and the decision meets the three criteria from `ADR-FORMAT.md`.

## Completion Report

When the exploration is complete or paused, summarize:

- **Questions asked & answered**: count.
- **Consistent decisions**: decisions that remain valid.
- **Drift detected**: decisions that conflict with code, tests, or docs; include file references.
- **Stale assumptions**: assumptions no longer true.
- **Open questions**: only unresolved blockers.
- **Evidence**: most important docs/code references.
- **Coverage summary**: for each taxonomy category, state Resolved / Deferred / Clear / Outstanding.
- **Suggested next action**: update ADRs, amend code, create deprecation notes, handoff to [feature-scope](feature-scope.md), or proceed to implementation planning.


