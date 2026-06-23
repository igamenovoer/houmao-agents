# Write Skill

## Workflow

Use this reference to create a new skill from a user request, or to rewrite an existing skill draft so it is ready for testing.

1. **Confirm the task and locate the skill home**. See **Skill Home**.
2. **Capture intent** from the user's request and conversation history. See **Intent Capture**.
3. **Interview the user** for edge cases, inputs, outputs, and dependencies. See **User Interview**.
4. **Research in parallel** when useful. See **Research**.
5. **Choose a structure** based on the skill's complexity. See **Structure Selection**.
6. **Write or revise the SKILL.md entrypoint**. See **SKILL.md Writing Guide**.
7. **Add bundled resources** when the skill needs scripts, references, or assets. See **Bundled Resources**.
8. **Draft initial test prompts** and save them to `evals/evals.json`. See **Test Prompts**.
9. **Validate** the skill frontmatter and structure. See **Validation**.
10. **Return a brief in-chat summary** using `references/chat-response-template.md` and list the files written or changed.

If the user's task does not map cleanly to these steps, use your native planning tool to build a step-by-step plan from the available writing guidance and the user's request, then execute the plan.

## Skill Home

Use the skill home explicitly provided by the user. Agent runtimes typically discover skills at runtime through `.agents/skills/`, which may be a real folder or a symlink to a committed skill location such as `skillset/`.

- If the user provides a target path, use it as the skill home.
- Otherwise, default to `.agents/skills/<skill-name>/` under the current project root.
- If the directory does not exist, create it.

## Intent Capture

Start by understanding what the user wants the skill to do. If the current conversation already contains a workflow the user wants to capture (for example, "turn this into a skill"), extract answers from the conversation history first: the tools used, the sequence of steps, corrections the user made, and input/output formats observed.

Resolve these questions before writing:

1. What should this skill enable the agent to do?
2. When should this skill be invoked? (user phrases or contexts)
3. What is the expected output format?
4. Does this skill need objectively verifiable test cases? Suggest test cases for file transforms, data extraction, code generation, or fixed workflow steps. For subjective outputs such as writing style or art, suggest skipping test cases unless the user wants them.

Confirm the answers with the user before proceeding to the next step.

## User Interview

Proactively ask questions about edge cases, input/output formats, example files, success criteria, and dependencies. Wait to write test prompts until this part is clear.

Use the user's answers to fill in the SKILL.md sections and to draft realistic test prompts.

## Research

If the skill depends on external tools, file formats, or best practices, research in parallel via subagents or web search. Come prepared with context so the user does not have to repeat information.

Do not let research delay the interview. Run research while the user is considering your questions when possible.

## Structure Selection

Choose the simplest structure that fits the skill:

| Complexity | Structure |
| --- | --- |
| Single workflow | `SKILL.md` only |
| Multiple subcommands or modes | `SKILL.md` router + `references/<subcommand>.md` detail pages |
| Reusable scripts | `SKILL.md` + `scripts/` |
| Large reference docs | `SKILL.md` + `references/` |
| Output templates | `SKILL.md` + `assets/` |

Keep the entrypoint small. Move detailed procedures into referenced files.

## SKILL.md Writing Guide

### Required Frontmatter

```yaml
---
name: <skill-name>
description: <what the skill does and when to invoke it; be specific and a little pushy>
---
```

Rules for the frontmatter:

- `name` must be kebab-case lowercase letters, digits, and hyphens.
- `name` should match the directory name when the skill is project-scoped.
- `description` should state what the skill does and when to invoke it. The description guides the agent's decision to invoke the skill. Make it specific and distinctive.
- Keep `description` under 1024 characters.

### Required Sections

1. **## Workflow** near the top. Write it as numbered steps. End with a fallback for freeform tasks.
2. **Overview** or **Invocation Contract** so the agent knows what the skill is for.
3. **Output Contract** describing what files, edits, or chat output the skill produces.

### Writing Patterns

- Use the imperative form.
- Explain why an instruction matters rather than using all-caps MUSTs.
- Define output formats with explicit templates when the skill must produce a specific structure.
- Include examples for input/output formats when they reduce ambiguity.
- Keep the entrypoint under 500 lines. Move long detail into referenced files.

### Progressive Disclosure

Skills load in three levels:

1. Frontmatter metadata — always in context.
2. SKILL.md body — loaded when the skill is invoked.
3. Bundled resources — loaded on demand.

Reference bundled files from SKILL.md with clear guidance on when to read them.

## Bundled Resources

Add bundled resources only when they reduce repetition or handle deterministic tasks.

- `scripts/` — executable code for deterministic or repetitive tasks.
- `references/` — docs loaded into context as needed.
- `assets/` — files used in output such as templates, icons, or fonts.

Keep references one level from SKILL.md when the entrypoint needs them.

## Test Prompts

After writing the skill draft, create 2-3 realistic test prompts — the kind of thing a real user would actually say. Save them to `evals/evals.json` in the skill directory:

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

Do not write assertions yet — just the prompts. Share the prompts with the user for review before running evals.

## Validation

Validate the skill before finishing:

1. Confirm `SKILL.md` exists and has valid YAML frontmatter with `name` and `description`.
2. Confirm the `name` matches the directory name for project-scoped skills.
3. Confirm the workflow section exists and uses numbered steps.
4. Confirm the workflow ends with a freeform fallback.
5. If a skill validator such as `skill-creator/scripts/quick_validate.py` is available, run it on the target skill folder.

Report any validation failures and fix them before returning the summary.

## Output Contract

By default, `write-skill` writes or edits files inside the target skill folder and returns a brief chat summary. It does not produce analysis reports under `<output-dir>`.

The chat summary must include:

- The skill folder path.
- Files written or changed.
- Validation results.
- Next recommended step (for example, run evals or review the skill).
