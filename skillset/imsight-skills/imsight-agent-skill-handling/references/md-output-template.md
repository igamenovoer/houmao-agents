# Markdown Output Template

Use this template for every Markdown report file written by `analyze`. Keep the section names below. Use Mermaid for the workflow diagram, but name the section `Workflow Overview`, not `Mermaid UML Workflow`.

````md
# {{REPORT_UNIT_TITLE}} Skill Analysis

Source skill: [{{SOURCE_LABEL}}]({{RELATIVE_SOURCE_PATH}})

Parent skill: {{PARENT_SKILL_NAME_OR_NONE}}

Report unit: {{entrypoint | subcommand | subskill | mode | workflow | primitive}}

Role: {{ROLE_IN_SKILL}}

Purpose: {{ONE_SENTENCE_PURPOSE}}

## Workflow Overview

<!--
Fill with a Mermaid state diagram or flowchart for the report unit's workflow.
Use the analyzed skill's own terminology for nodes and transitions.
Show major decisions, loops, handoffs, and terminal states.
Do not title this section "Mermaid UML Workflow".
-->

```mermaid
stateDiagram-v2
    [*] --> {{STEP_1_NAME}}
    {{STEP_1_NAME}} --> {{STEP_2_NAME}}
    {{STEP_2_NAME}} --> {{END_STATE}}
    {{END_STATE}} --> [*]
```

## Step Explanation

<!--
Fill one row per major workflow step from the Mermaid diagram.
Use "Meaning" for the step's job, not a restatement of the step name.
Use "Evidence" for the source file, section, line number, or inferred marker.
-->

| Step | Meaning | Evidence |
| --- | --- | --- |
| `{{STEP_1_NAME}}` | {{WHAT_THIS_STEP_DOES}} | {{FILE_OR_SECTION}} |
| `{{STEP_2_NAME}}` | {{WHAT_THIS_STEP_DOES}} | {{FILE_OR_SECTION}} |

## Durable Outputs

<!--
List artifacts the analyzed skill would create, modify, send, or emit during normal execution.
Do not list this analysis report itself.
Include non-file outputs such as chat reports, mailbox messages, branches, worktrees, PRs, service units, downloaded packs, or generated commands.
Use "Explicit" when the skill states the artifact directly and "Inferred" when the artifact follows from workflow logic.
-->

| Artifact | Path or Destination | Triggering Step | Evidence | Certainty |
| --- | --- | --- | --- | --- |
| {{ARTIFACT_NAME}} | {{PATH_OR_DESTINATION}} | {{STEP_NAME}} | {{FILE_OR_SECTION}} | {{Explicit | Inferred}} |

## Inner Workings

<!--
Explain how the report unit works internally:
- how the agent chooses this path,
- what context it reads,
- which decisions route execution,
- which guardrails constrain behavior,
- how it hands off or terminates.
Prefer 2-5 concise paragraphs.
-->

{{INNER_WORKINGS_EXPLANATION}}

## Key Constraints

<!--
List required guardrails, ordering constraints, approval rules, exclusions, or "do not" rules.
If none are explicit, say "No explicit constraints found."
-->

- {{CONSTRAINT_OR_GUARDRAIL}}
````

For `ENTRYPOINT.md`, add this section after `Purpose` when additional report files exist:

```md
## Per-Part Reports

<!-- Link every generated per-part report with a one-line description. -->

- [{{REPORT_FILE_STEM}}]({{REPORT_FILE_NAME}}): {{WHAT_THIS_PART_COVERS}}
```
