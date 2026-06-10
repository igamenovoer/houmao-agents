# Imsight Skill Style Guide

## Overview

This guide specifies a small set of structural rules that every skill must follow. It is intentionally minimal — it does not prescribe a fixed section order, dictate writing style, or prevent skill writers from adding additional sections as they see fit. Writers may include any other sections (references, examples, configuration notes, etc.) in whatever order and style works best for their skill, as long as the four rules below are satisfied.

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

## Freeform skills

If the skill mainly provides tools, constraints, or subcommands rather than a rigid procedure:

- The workflow should tell the agent to use its native planning tool to plan execution steps based on the available tools/constraints/subskills and the user's specific task.
- The rest of the skill serves as reference material for that plan.

These four rules do not prevent adding other sections. They only enforce that every skill has a clear, actionable workflow entrypoint.
