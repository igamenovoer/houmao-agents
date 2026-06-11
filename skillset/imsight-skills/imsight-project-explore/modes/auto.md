# Auto Exploration Mode

Use `auto` as the default when the user does not explicitly request a focused mode. The agent inspects the prompt and early repo evidence, chooses the most relevant exploration type, states that routing choice, and then asks the first decision-bearing question inside the selected exploration path.

## Workflow

When `auto` mode is selected, execute the following steps in order. Detailed rules for each step are in the sections referenced below.

1. **Perform a Pre-Exploration Scan**. Spend ~2 minutes gathering evidence from the repo. See **Pre-Exploration Scan** for the ordered checklist.
2. **Run a Coverage Scan**. Mark each category as Clear / Partial / Missing. See **Coverage Scan**.
3. **Choose the exploration type**. Based on the scan, select the most relevant mode or topic and state the routing choice to the user. This routing choice does not require user confirmation.
4. **Build 1-5 questions**. See **Question Constraints**.
5. **Execute the Sequential Questioning Loop**. Present exactly one question at a time. See **Sequential Questioning Loop** for question formats and handling rules.
6. **After each answer, integrate**. Update the coverage map, re-prioritize remaining questions, and pivot to a focused mode if the answer reveals one is needed. See **Integration After Each Answer**.
7. **When complete, produce a Completion Report**. Summarize what was explored, what remains open, and what to do next. See **Completion Report**.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan based on the constraints above and the user's specific goal, then execute the plan.

## When to Use

- The user asks a broad question such as "explore this project" or "what should we build?"
- The prompt mixes scope, terminology, and decision concerns without naming a mode.
- You need to discover which focused mode is most relevant before committing to it.

## Pre-Exploration Scan

Before asking any user-facing question, perform a 2-minute repo scan. Load evidence in this order:

1. **Previous exploration**: `<output-dir>/domain-concepts/`, `<output-dir>/adrs/`, `<output-dir>/feature-scope/`. Load any relevant prior artifacts and incorporate them into your evidence set.
2. **Project guidance**: `AGENTS.md`, `CLAUDE.md`, `.agents/`, `.cursor/`, `.github/copilot-instructions.md`
3. **Product/spec material**: `README.md`, `docs/`, `specs/`, `features/`, issue or PRD files, roadmap notes
4. **Domain memory**: `CONTEXT.md`, architecture docs, design docs
5. **Behavior surfaces**: routes, controllers, API schemas, UI pages, CLI commands, migrations, test names, fixtures

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

- Ask at least 1 question after choosing the exploration type and before making any substantive project decision, writing artifacts, or producing a final proposed direction, unless the user explicitly requested a non-interactive audit, explicitly asked the agent to make reasonable assumptions, or provided all required decisions in the prompt.
- **Maximum 5 total questions** across the whole session.
- Each question must be answerable with **either**:
  - A short multiple-choice selection (2–5 distinct, mutually exclusive options), **or**
  - A short-phrase answer. The agent's proposed answer should be concise, but the user may provide a custom answer of any length.
- Only ask questions whose answers materially impact project scope, terminology, decision status, what to explore first within the selected type, or whether the request is actionable.
- If more than 5 candidate questions remain, select the top 5 by (Impact × Uncertainty) heuristic.
- Do not reveal future queued questions in advance.

## Sequential Questioning Loop

Present **exactly one question at a time**.

### For Multiple-Choice Questions

Before presenting the options, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts the exploration (e.g., which mode to enter, what to explore first, or whether the request is actionable).
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows how each option would play out in practice.

Then analyze all options and determine the **proposed option** based on:

- Best practices for the project type
- Common patterns in similar implementations
- Risk reduction (security, performance, maintainability)
- Alignment with any explicit project goals or constraints visible in the evidence

Present your **proposed option** prominently at the top with:
- The proposal itself.
- **Why it is proposed** (1–2 sentences).
- **Implication** — what happens downstream if this option is chosen (e.g., which files change, which assumptions hold, which risks are accepted).

Format as:

```
**Proposed:** Option [X] - <why proposed>

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
You can reply with the option letter (e.g., "A"), accept the proposal by saying "yes" or "proposed", or provide your own answer.
```

### For Short-Answer Questions

Before presenting the proposed answer, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts the exploration.
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows why the answer matters.

Then provide your **proposed answer** with:
- The proposal itself.
- **Brief reasoning**.
- **Implication** — what happens downstream if this answer is chosen.

Format as:

```
**Proposed:** <your proposed answer> - <brief reasoning>

**Implication:** <downstream consequence>
```

Then output:

```
Format: Short answer. You can accept the proposal by saying "yes" or "proposed", or provide your own answer.
```

### After the User Answers

- If the user replies with "yes", "recommended", "suggested", or "proposed", use your previously stated proposal as the answer.
- Otherwise, validate the answer maps to one option or is a valid custom answer.
- If ambiguous, ask for a quick disambiguation (this still counts as the same question; do not advance the counter).
- Once satisfactory, record it in working memory, update the exploration state, and move to the next queued question.

**Stop asking** when:
- All critical ambiguities are resolved early (remaining queued items become unnecessary), **or**
- The user signals completion ("done", "good", "no more"), **or**
- You reach 5 asked questions.

Do not use "no valid questions exist" as a reason to skip the first user interaction. If the prompt appears complete, state the selected exploration type and ask the user to confirm the first substantive project assumption before proceeding, unless the user explicitly requested a non-interactive audit, explicitly asked the agent to make reasonable assumptions, or provided all required decisions in the prompt.

## Integration After Each Answer

- Maintain an in-memory exploration state plus the raw evidence set.
- After each accepted answer, update the coverage map and re-prioritize remaining questions.
- If the answer redirects the request toward a different focused mode (feature-scope, domain-language, review-decision), state the pivot explicitly and hand off to that mode's page.
- Do not write to disk in `auto` unless the user explicitly requests a written result. If they do, write it to `<output-dir>/feature-scope/feat-<what>.md` or `<output-dir>/domain-concepts/dc-<what>.md` depending on the dominant concern, following the output directory discovery contract. If the target directory does not yet contain a `README.md`, create one as an index.
- After writing any artifact, scan all other documents under `<output-dir>/` for references to the same concepts or decisions. Update affected documents to restore consistency.
- When working with an OpenSpec change, also scan the OpenSpec change artifacts for contradictions or extensions, and update or flag them.

## Completion Report

When the exploration is complete or paused, summarize:

- **Questions asked & answered**: count.
- **Selected exploration type**: what mode or topic the agent selected, plus any user redirection.
- **Evidence inspected**: key files and sections.
- **Coverage summary**: for each category, state Resolved / Deferred / Clear / Outstanding.
- **Open questions**: only unresolved blockers.
- **Suggested next action**: spec update, decision review report, ADR update, issue breakdown, implementation plan, or handoff to another mode or Imsight skill.
