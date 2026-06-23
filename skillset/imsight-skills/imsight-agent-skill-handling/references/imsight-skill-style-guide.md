# Imsight Skill Style Guide

This is the local bundled copy of the Imsight skill style guide used by `format`. Do not depend on a style-guide file outside this skill directory at runtime.

## Overview

This guide specifies a small set of structural rules that every skill must follow. It is intentionally minimal: it does not prescribe a fixed section order, dictate writing style, or prevent skill writers from adding additional sections as they see fit. Writers may include any other sections (references, examples, configuration notes, etc.) in whatever order and style works best for their skill, as long as the four rules below are satisfied.

## Workflow section (required)

Every skill and subcommand must have a `## Workflow` section near the top. This is the agent's entrypoint.

- Write it as **numbered steps** the agent executes in order.
- Keep each step concise. If a step needs detailed rules, reference another section: `See **Pre-Exploration Scan**.`
- End with a fallback for freeform tasks: if the task does not map cleanly to the default steps, tell the agent to use its native planning tool to build a step-by-step plan using the tools, constraints, or subcommands provided by the skill, then execute the plan.

## Referencing details

When a step needs detail that is too long for the workflow line, state the step at a high level and reference the detailed section by name. Do not inline long procedures inside the workflow.

## Multiple-choice steps

When a workflow step involves choosing among modes, subcommands, or procedures:

- State the choice in the workflow step, for example: "Select an exploration mode from the **Exploration Modes** table."
- Let the agent decide which option fits the user's task, using the information provided in the skill.
- Do not hardcode the choice; present the options and constraints so the agent can reason about them.

## Freeform skills

If the skill mainly provides tools, constraints, or subcommands rather than a rigid procedure:

- The workflow should tell the agent to use its native planning tool to plan execution steps based on the available tools, constraints, subcommands, and the user's specific task.
- The rest of the skill serves as reference material for that plan.

These four rules do not prevent adding other sections. They only enforce that every skill has a clear, actionable workflow entrypoint.

## Example skeleton

```md
---
name: example-skill
description: Short description of what this skill does and when to use it.
---

# Example Skill

## Overview

One-paragraph explanation of the skill's purpose.

## Workflow

When this skill is invoked, execute the following steps in order.

1. **Determine the target directory**. See **Project Directory**.
2. **Resolve the output location**. See **Output Directory Discovery**.
3. **Select the appropriate subcommand** from the **Subcommands** table below.
   Let the agent choose the subcommand that best matches the user's task.
4. **Execute the selected subcommand's workflow**. See the linked detail page.
5. **Capture results** following the artifact rules in **Capturing Knowledge**.

If the user's task does not map cleanly to these steps, use your native
planning tool to build a step-by-step plan using the subcommands and
constraints provided by this skill, then execute the plan.

## Subcommands

| Subcommand | Use For | Detail |
| --- | --- | --- |
| `analyze` | Analyze existing data | [modes/analyze.md](modes/analyze.md) |
| `generate` | Generate new artifacts | [modes/generate.md](modes/generate.md) |

## Project Directory

Use the directory explicitly provided by the user, or the current working
directory if none is given.

## Output Directory Discovery

Resolve `<output-dir>` in this priority:

1. User-provided location.
2. `EXAMPLE_SKILL_OUTPUT_DIR` environment variable.
3. `<project-dir>/.example-skill/output/` by default.

## Capturing Knowledge

Write results to `<output-dir>/results/<timestamp>-<what>.md`.

## Additional sections

Writers can add any other sections here: configuration notes, references,
examples, safety warnings, etc. Use whatever order and style works best.
```
