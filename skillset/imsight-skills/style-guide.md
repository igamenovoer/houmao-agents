# Imsight Skill Style Guide

This guide captures the structural and editorial conventions used across the `imsight-skills` family. Follow it when creating new skills or revising existing ones so that agents receive consistent, actionable instructions.

## Skill File Structure

Every skill file (root `SKILL.md` and subskill mode files) must use this top-down order:

1. **Front-matter** (`---` block with `name` and `description`)
2. **Heading** (`# Skill Name`)
3. **Overview** — one-paragraph purpose statement
4. **Workflow** — numbered step-by-step entrypoint (see Workflow section below)
5. **Invocation Contract** — how the user calls the skill (root skill only)
6. **When to Use** — trigger conditions for this mode/subskill
7. **Pre-Exploration Scan** — ordered checklist of evidence to gather before acting
8. **Coverage Scan** — taxonomy table with Clear / Partial / Missing marking
9. **Question Constraints** — rules for building clarification questions
10. **Sequential Questioning Loop** — how to present one question at a time
11. **Integration After Each Answer** — how to apply answers and update artifacts
12. **Completion Report** — what to summarize when finishing or pausing
13. **Capturing Knowledge / Artifact Rules** — where and how to write durable output (root skill or referenced section)

Sections may be omitted only when they genuinely do not apply. Do not reorder sections arbitrarily.

## Workflow Section (Required)

Every skill and subskill must have a **Workflow** section immediately after Overview. It is the agent's entrypoint.

- Use **numbered steps** (`1.`, `2.`, ...).
- Each step should be a high-level action sentence.
- Reference the detailed section name in bold: `See **Pre-Exploration Scan**.`
- End with a fallback clause:

  > If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan based on the constraints above and the user's specific goal, then execute the plan.

Example:

```md
## Workflow

When `feature-scope` mode is selected, execute the following steps in order.

1. **Perform a Pre-Exploration Scan**. See **Pre-Exploration Scan**.
2. **Run a Coverage Scan**. See **Coverage Scan**.
3. **Build up to 5 questions**. See **Question Constraints**.
4. **Execute the Sequential Questioning Loop**. See **Sequential Questioning Loop**.
5. **After each answer, integrate**. See **Integration After Each Answer**.
6. **When complete, produce a Completion Report**. See **Completion Report**.

If the user's task does not map cleanly to these steps, use your native planning tool ...
```

## Mode Selection

When a skill has multiple modes or subskills:

- Present them in a **table** with columns: Mode, Use For, Detail (linked file).
- The root skill Workflow must instruct the agent to inspect this table and pick based on the user's prompt.
- Default mode must be explicitly stated.
- Combining modes is allowed only when the request naturally spans them.

## Pre-Exploration Scan Ordering

The scan checklist must always start with **previous exploration artifacts** before looking at the codebase:

1. **Previous exploration**: `<output-dir>/domain-concepts/`, `<output-dir>/adrs/`, `<output-dir>/feature-scope/`
2. **Project guidance**: `AGENTS.md`, `CLAUDE.md`, `.cursor/`, etc.
3. **Product/spec material**: `README.md`, `docs/`, `specs/`, etc.
4. **Domain memory**: `CONTEXT.md`, architecture docs, etc.
5. **Behavior surfaces**: routes, schemas, tests, etc.

This prevents the agent from duplicating work or contradicting prior exploration.

## Artifact Paths and Naming

Use consistent path conventions across all skills:

| Artifact | Path pattern |
| --- | --- |
| Domain concepts | `<output-dir>/domain-concepts/dc-<what>.md` |
| ADRs | `<output-dir>/adrs/<index>-<what>.md` |
| Feature scope | `<output-dir>/feature-scope/feat-<what>.md` |

- Create a `README.md` index when creating the first file in `domain-concepts/` or `feature-scope/`.
- Use kebab-case for `<what>` and `<index>` (e.g., `0001`, `0002`).
- ADR reference files must use `<output-dir>/adrs/` instead of hardcoded paths like `docs/adr/`.

## Consistency Discipline

After writing or updating any artifact, the agent must:

1. Scan all other documents under `<output-dir>/` for references to the same concepts, decisions, or terms.
2. If the new content invalidates, contradicts, or extends an existing document, update the affected document.
3. Do not leave stale definitions or outdated decisions across artifacts.

This rule must appear in:
- The root skill's **Capturing Knowledge** section.
- Each mode's **Integration After Each Answer** section.

## OpenSpec Synchronization

When `<output-dir>` is inside an OpenSpec change (`<openspec-change-dir>/explore`):

- After recording a new decision or updating domain concepts, scan the OpenSpec change artifacts: `proposal.md`, `design.md`, `tasks.md`, and specs under `specs/`.
- If the new content contradicts or extends the OpenSpec artifacts, update the relevant OpenSpec documents or flag the inconsistency to the user.

This rule must appear in the root skill and in each mode's integration section.

## Question Formats

The **Sequential Questioning Loop** must define two question types with strict formatting:

### Multiple-Choice

1. Motivation paragraph
2. Example paragraph
3. Recommended option block:
   ```
   **Recommended:** Option [X] - <why recommended>

   **Implication:** <downstream consequence>
   ```
4. Options table with Pros/Cons column
5. Short-answer fallback row
6. Closing instruction: `You can reply with the option letter...`

### Short-Answer

1. Motivation paragraph
2. Example paragraph
3. Suggested answer block:
   ```
   **Suggested:** <your proposed answer> - <brief reasoning>

   **Implication:** <downstream consequence>
   ```
4. Closing instruction: `Format: Short answer. You can accept the suggestion...`

## Avoid Duplication

- Centralize artifact path definitions in the root skill's **Capturing Knowledge** table.
- Subskills reference the root skill table or use the standard path patterns; do not spell out full path logic repeatedly.
- Say "Only write to `docs/design/` if the user explicitly requests tracked project docs" exactly once in the root skill.
- Use section references (`See **Coverage Scan**.`) instead of inlining detailed rules.

## Writing Style

- Use imperative voice: "Execute the following steps", "Scan the repo", "Write an ADR".
- Keep paragraphs short. One idea per paragraph.
- Use tables for taxonomies, options, and artifact mappings.
- Use bullet lists for ordered checklists and unordered constraints.
- Cite file paths and line numbers when reporting evidence.
