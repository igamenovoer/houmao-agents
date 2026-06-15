# Format Skill

## Workflow

Use this reference to revise a given skill so its structure conforms to the bundled Imsight skill style guide.

1. **Locate the target skill**. Resolve the skill folder from the user's request and confirm it contains `SKILL.md`.
2. **Load the local style guide**. Read `references/imsight-skill-style-guide.md`; do not rely on any style guide outside this skill directory.
3. **Read target skill files**. Read the target `SKILL.md`, `agents/openai.yaml` when present, and any directly linked subskill, mode, workflow, primitive, or reference page that acts as an executable skill page.
4. **Identify style gaps**. Check **Formatting Checks** for the entrypoint and each subskill-like page.
5. **Revise structure in place**. Apply the smallest edits that make the target files conform while preserving skill meaning, public subcommands, trigger behavior, output contracts, and guardrails.
6. **Synchronize links and metadata** when structural edits change subcommand labels, reference paths, or help text.
7. **Validate**. Run the available skill validator on the target skill and inspect changed files for remaining style gaps.
8. **Report results**. Summarize changed files, validations run, and any unresolved style issues.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan from the bundled style guide and the target skill's structure, then execute the plan.

## Formatting Checks

Apply these checks to the target `SKILL.md` and any subskill-like Markdown page that another agent may execute as a workflow.

- The file has a `## Workflow` section near the top.
- The workflow is written as numbered steps.
- Each workflow step is concise and points to a detailed section when it needs more explanation.
- Multiple-choice steps tell the agent which table, mode list, subskill list, or procedure set to choose from.
- Multiple-choice steps let the agent choose the option that fits the user's task; they do not hardcode one option without evidence.
- Freeform skills tell the agent to use its native planning tool to plan execution from the available tools, constraints, subskills, subcommands, and user request.
- The workflow ends with a fallback for tasks that do not map cleanly to the default steps.

## Editing Rules

- Preserve frontmatter `name` and `description` unless they are invalid or stale because of structural edits.
- Do not broaden trigger behavior while formatting.
- Do not rename public subcommands, subskills, files, or output paths unless the user explicitly asks or the current name is broken.
- Do not remove domain-specific guardrails, approval rules, or output contracts.
- Move long procedural detail out of the workflow into existing sections when possible.
- Add a new detail section only when no suitable section exists.
- Keep references one level from `SKILL.md` when the entrypoint needs them.
- Do not create auxiliary docs such as README, changelog, installation guide, or quick reference files inside the target skill.

## Validation

Run the platform validator when available. For Codex skills, use the local `skill-creator` validator if present:

```bash
python /path/to/skill-creator/scripts/quick_validate.py <target-skill-folder>
```

If the current Python environment lacks validator dependencies, try the repository's managed Python environment before giving up.

After validation, inspect changed files for:

- stale links to moved or renamed files,
- missing `## Workflow` sections in subskill-like pages,
- workflows without numbered steps,
- workflows without a freeform fallback,
- accidental changes to trigger or output semantics.
