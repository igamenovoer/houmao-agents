# Imsight Skill Style Guide

## Overview

This guide specifies a small set of structural rules that every skill must follow. It is intentionally minimal — it does not prescribe a fixed section order, dictate writing style, or prevent skill writers from adding additional sections as they see fit. Writers may include any other sections (references, examples, configuration notes, etc.) in whatever order and style works best for their skill, as long as the rules below are satisfied.

## Workflow section (required)

Every skill and subskill must have a `## Workflow` section near the top. This is the agent's entrypoint.

- Write it as **numbered steps** the agent executes in order.
- Keep each step concise. If a step needs detailed rules, reference another section: `See **Pre-Exploration Scan**.`
- End with a fallback for freeform tasks: if the task does not map cleanly to the default steps, tell the agent to use its native planning tool to build a step-by-step plan using the tools / constraints / subskills / subcommands provided by the skill, then execute the plan.

## Referencing details

When a step needs detail that is too long for the workflow line, state the step at a high level and reference the detailed section by name. Do not inline long procedures inside the workflow.

## Multiple-choice steps

When a workflow step involves choosing among modes, subskills, subcommands, or procedures:

- State the choice in the workflow step (e.g., "Select an exploration mode from the **Exploration Modes** table").
- Let the agent decide which option fits the user's task, using the information provided in the skill.
- Do not hardcode the choice; present the options and constraints so the agent can reason about them.

## Subcommand structure flavor

Choose the subcommand structure from the skill's functionality.

### Collection-of-routines flavor

Use one plain `## Subcommands` section when the skill is a collection of related routines rather than a complex procedure.

This flavor fits skills where:

- Subcommands are peer functions, tools, or routines.
- The normal calling order is absent, flexible, or task-specific.
- The skill does not describe one complex multi-step workflow.
- Most subcommands can be invoked independently without predecessor artifacts from earlier subcommands.

For this flavor, one table is enough:

| Subcommand | Use For | Detail |
| --- | --- | --- |
| `analyze` | Analyze existing data | [modes/analyze.md](modes/analyze.md) |
| `generate` | Generate new artifacts | [modes/generate.md](modes/generate.md) |

### Complex-procedure flavor

Use the three-type split when the skill describes a complex procedure with multiple steps, where each step has its own sub-workflow and a separate detail page.

This flavor fits skills where:

- The skill has a normal user-facing execution flow.
- Several workflow steps have their own reference pages.
- Some steps depend on artifacts produced by earlier steps.
- The skill benefits from shortcuts such as `fast-forward` or `step-by-step`.

For this flavor, divide the `## Subcommands` section into Procedural Subcommands, Helper Subcommands, and Misc Subcommands.

### Procedural subcommands

Procedural subcommands are the user-facing single-step workflow API. They represent the normal public execution steps a caller may invoke directly.

- Name them as short kebab-case verb phrases, such as `init-topic`, `derive-gate`, or `verify-gate`.
- Put them in the user-facing workflow order when an order exists.
- State required predecessor artifacts on the subcommand detail page. If those artifacts are missing, the subcommand should refuse to run and explain which earlier subcommand should create them.
- Include procedural subcommands in help output.

### Helper subcommands

Helper subcommands are lower-level implementation commands called by procedural subcommands. They are analogous to private API: callers can still invoke them, but the skill should not steer ordinary users toward them.

- Add helper subcommands only when they reduce real complexity or repetition.
- Keep helper names short, kebab-case, and action-oriented.
- Keep helper subcommands out of help output unless the helper is promoted to a public workflow step.
- If a complex skill has no helper subcommands, say so explicitly: `No helper subcommands are currently exposed.`

### Misc subcommands

Misc subcommands are public support commands and shortcuts that do not represent one normal procedural step.

- Put `help` here when the skill supports help.
- Put shortcuts such as `fast-forward` or `step-by-step` here. `fast-forward` should run the full procedural workflow automatically. `step-by-step` should run the same required workflow but pause for user confirmation between stages.
- Include misc subcommands in help output because they are part of the public interface.

## Freeform skills

If the skill mainly provides tools, constraints, or subcommands rather than a rigid procedure:

- The workflow should tell the agent to use its native planning tool to plan execution steps based on the available tools/constraints/subskills and the user's specific task.
- The rest of the skill serves as reference material for that plan.

These rules do not prevent adding other sections. They only enforce that every skill has a clear, actionable workflow entrypoint.

## Example skeleton

Below is a minimal collection-of-routines skill that follows these rules. Writers may add any other sections they need.

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
3. **Select the appropriate subcommand** from the **Subcommands** section below.
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
| `help` | Explain this skill and list public subcommands | This entrypoint |

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

Writers can add any other sections here — configuration notes, references,
examples, safety warnings, etc. — in whatever order and style they prefer.
```
