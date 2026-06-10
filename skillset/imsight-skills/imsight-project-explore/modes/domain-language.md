# Domain Language Exploration Mode

Use `domain-language` when the user's prompt involves terminology, naming, or when you detect conflicts between the user's words and the codebase's words. Resolve project-specific terms and write durable definitions to `<output-dir>/domain-concepts.md` when exploring an OpenSpec change, or to `<output-dir>/domain-concepts/<topic-name>.md` otherwise, following the output directory discovery contract. Only update `CONTEXT.md` if the user explicitly says that is their project's glossary. Ask up to 5 highly targeted clarification questions.

## When to Use

- The user uses a term that does not appear in the codebase or appears with a different meaning.
- The prompt asks to "clarify terminology", "define domain language", or "update the glossary".
- You find the same concept named differently in code, tests, docs, and user-facing copy.

## Pre-Exploration Scan

Before asking any user-facing question, inspect the repo for:

- **Existing glossary** (such as `CONTEXT.md`): canonical terms and avoided synonyms.
- **Code identifiers**: class names, function names, variable names, database tables/columns.
- **API schemas**: field names, type names, enum values.
- **UI labels**: user-facing copy, button text, headings.
- **Tests and docs**: fixture names, test descriptions, documentation headings.

Use `rg` to map every occurrence of candidate terms. Cite file paths and line numbers when reporting evidence.

## Coverage Scan

Perform a structured ambiguity & coverage scan across this taxonomy. For each category, mark status: **Clear** / **Partial** / **Missing**. Produce an internal coverage map (do not output the raw map unless no questions will be asked).

| Category | What to Check |
| --- | --- |
| **Term inventory** | Which terms in the prompt are project-specific domain words (not generic programming words)? |
| **Usage mapping** | Where does each term appear in code, tests, schemas, UI, and docs? |
| **Synonym detection** | Is one concept named with multiple words (e.g., "customer" vs "account" vs "user")? |
| **Glossary alignment** | Does the user's term conflict with an existing canonical term or _Avoid_ entry (in `CONTEXT.md` or `<output-dir>/domain-concepts/`)? |
| **Code consistency** | Does the codebase use one term inconsistently (e.g., column `status` mapped to enum `State`)? |
| **Expert language** | Which term do domain experts (not programmers) use for this concept? |
| **Definition precision** | Can the term be defined in 1–2 sentences as what the thing is, not every operation on it? |
| **Relationships** | What hierarchical, compositional, or state-transition relationships does this term participate in? |
| **Update scope** | Should this update the glossary, or is it a transient implementation naming concern? |
| **Deprecation** | Are there synonyms that should be explicitly avoided going forward? |

For each category with **Partial** or **Missing** status, add a candidate question opportunity unless:
- The term is generic programming vocabulary (service, controller, handler, manager)
- The conflict is purely implementation-level and better resolved during coding

## Question Constraints

- **Maximum 5 total questions** across the whole session.
- Each question must be answerable with **either**:
  - A short multiple-choice selection (2–5 distinct, mutually exclusive options), **or**
  - A short-phrase answer. The agent's suggested answer should be concise, but the user may provide a custom answer of any length.
- Only include questions whose answers materially impact how the team communicates about the domain, how new code should be named, or whether the glossary needs an update.
- Ensure category coverage balance: attempt to cover the highest impact unresolved categories first.
- Exclude questions already answered by repo evidence or trivial stylistic preferences.
- Favor clarifications that prevent recurring naming conflicts in code reviews.
- If more than 5 categories remain unresolved, select the top 5 by (Impact × Uncertainty) heuristic.
- Do not reveal future queued questions in advance.

## Sequential Questioning Loop

Present **exactly one question at a time**.

### For Multiple-Choice Questions

Before presenting the options, provide:

1. **Motivation** — state the question clearly and explain why the answer materially impacts how the team communicates about the domain, how new code should be named, or whether the glossary needs an update.
2. **Example** — give a concrete, hypothesized scenario drawn from the project context that shows how each option would play out in practice (e.g., a code review comment, a user-facing error message, or a schema field name).

Then analyze all options and determine the **most suitable option** based on:

- Domain expert usage over implementation jargon
- Consistency with existing glossary entries
- Prevalence in the current codebase
- Clarity and lack of overload (same word meaning multiple things)

Present your **recommended option prominently** at the top with:
- The recommendation itself.
- **Why it is recommended** (1–2 sentences).
- **Implication** — what happens downstream if this option is chosen (e.g., which files need renaming, which glossary entries change, which synonyms become avoided).

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

1. **Motivation** — state the question clearly and explain why the answer materially impacts how the team communicates about the domain, how new code should be named, or whether the glossary needs an update.
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

- Maintain an in-memory representation of the terminology state plus the raw evidence set.
- Load `references/DOMAIN-CONCEPTS-FORMAT.md` before creating or editing domain concepts docs.
- After each accepted answer, apply the clarification:
  - If the answer selects or defines a canonical term, write it to `<output-dir>/domain-concepts.md` for OpenSpec changes, or to `<output-dir>/domain-concepts/<topic-name>.md` otherwise (atomic overwrite), following the output directory discovery contract. If the `domain-concepts/` directory does not yet contain a `README.md`, create one as an index. Only update `CONTEXT.md` if the user explicitly says that is their project's glossary. Include definition, _Avoid_ synonyms, and relationships.
  - If the answer resolves a naming conflict, normalize the term across any in-memory notes; retain the original only once with `(formerly referred to as "X")` if necessary.
  - If the term is not durable or project-specific, record it in an exploration summary instead.
- Do not batch inferred terms; update immediately.
- Do not use domain language docs as a spec, implementation plan, issue list, or scratchpad.

## Completion Report

When the exploration is complete or paused, summarize:

- **Questions asked & answered**: count.
- **Resolved terms**: canonical term, definition, and avoided synonyms.
- **Open questions**: only unresolved terminology blockers.
- **Evidence**: most important docs/code references.
- **Coverage summary**: for each taxonomy category, state Resolved / Deferred / Clear / Outstanding.
- **Suggested next action**: update `<output-dir>/domain-concepts.md` for OpenSpec changes, or `<output-dir>/domain-concepts/<topic-name>.md` otherwise (only update `CONTEXT.md` if the user explicitly says that is their glossary), propose code renames, handoff to [feature-scope](feature-scope.md), or proceed to implementation planning.


