# Auto Exploration Mode

Use `auto` as the default when the user does not explicitly request a focused mode. The agent inspects the prompt and early repo evidence, chooses what to explore, states the chosen focus, and proceeds with up to 5 targeted clarification questions.

## When to Use

- The user asks a broad question such as "explore this project" or "what should we build?"
- The prompt mixes scope, terminology, and decision concerns without naming a mode.
- You need to discover which focused mode is most relevant before committing to it.

## Pre-Exploration Scan

Before asking any user-facing question, perform a 2-minute repo scan. Load evidence in this order:

1. **Project guidance**: `AGENTS.md`, `CLAUDE.md`, `.agents/`, `.cursor/`, `.github/copilot-instructions.md`
2. **Product/spec material**: `README.md`, `docs/`, `specs/`, `features/`, issue or PRD files, roadmap notes
3. **Domain memory**: `CONTEXT.md`, `docs/design/adrs/`, architecture docs, design docs
4. **Behavior surfaces**: routes, controllers, API schemas, UI pages, CLI commands, migrations, test names, fixtures

Cite file paths and line numbers when reporting evidence.

## Coverage Scan

Perform a structured scan across these categories. For each, mark status: **Clear** / **Partial** / **Missing**. Produce an internal coverage map (do not output the raw map unless no questions will be asked).

| Category | What to Check |
| --- | --- |
| **Request type** | Is this a new feature, refactor, bug fix, spec clarification, or terminology fix? |
| **Evidence sufficiency** | Does the repo already answer parts of the request? Which parts are missing? |
| **Primary concern** | Does the prompt lean toward scope, terminology, or existing decision review? |
| **Blockers** | What is the smallest unresolved item that prevents choosing a focused mode? |
| **Drift signals** | Are there contradictions between docs, code, tests, or the user's language? |

## Question Constraints

- **Maximum 5 total questions** across the whole session.
- Each question must be answerable with **either**:
  - A short multiple-choice selection (2–5 distinct, mutually exclusive options), **or**
  - A short-phrase answer. The agent's suggested answer should be concise, but the user may provide a custom answer of any length.
- Only ask questions whose answers materially impact which mode to enter, what to explore first, or whether the request is actionable.
- If more than 5 candidate questions remain, select the top 5 by (Impact × Uncertainty) heuristic.
- Do not reveal future queued questions in advance.

## Sequential Questioning Loop

Present **exactly one question at a time**.

### For Multiple-Choice Questions

Analyze all options and determine the **most suitable option** based on:

- Best practices for the project type
- Common patterns in similar implementations
- Risk reduction (security, performance, maintainability)
- Alignment with any explicit project goals or constraints visible in the evidence

Present your **recommended option prominently** at the top with clear reasoning (1–2 sentences explaining why this is the best choice). Format as:

```
**Recommended:** Option [X] - <reasoning>
```

Then render all options as a Markdown table:

| Option | Description |
| --- | --- |
| A | ... |
| B | ... |
| C | ... |
| Short | Provide a different answer (any length) |

After the table, add:

```
You can reply with the option letter (e.g., "A"), accept the recommendation by saying "yes" or "recommended", or provide your own answer.
```

### For Short-Answer Questions

Provide your **suggested answer** based on best practices and context. Format as:

```
**Suggested:** <your proposed answer> - <brief reasoning>
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
- The user signals completion ("done", "good", "no more"), **or**
- You reach 5 asked questions.

If no valid questions exist at the start, immediately report: "No critical ambiguities detected worth formal clarification." and suggest proceeding.

## Integration After Each Answer

- Maintain an in-memory exploration state plus the raw evidence set.
- After each accepted answer, update the coverage map and re-prioritize remaining questions.
- If the answer reveals the request is actually about a focused mode (feature-scope, domain-language, review-decision), state the pivot explicitly and hand off to that mode's page.
- Do not write to disk in `auto` unless the user explicitly requests an exploration summary. If they do, default to a tracked doc at `docs/design/exploration/<topic-name>.md`; use `.imsight-arts/project-explore/` only when the user explicitly says untracked.

## Completion Report

When the exploration is complete or paused, summarize:

- **Questions asked & answered**: count.
- **Chosen focus**: what mode or topic was selected.
- **Evidence inspected**: key files and sections.
- **Coverage summary**: for each category, state Resolved / Deferred / Clear / Outstanding.
- **Open questions**: only unresolved blockers.
- **Suggested next action**: spec update, decision review report, ADR update, issue breakdown, implementation plan, or handoff to another mode or Imsight skill.


