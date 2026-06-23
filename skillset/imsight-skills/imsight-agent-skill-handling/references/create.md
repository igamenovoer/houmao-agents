# Create Skill

## Workflow

Use this reference to create a new skill from a user request using test-driven skill authoring. The core rule is: **no skill without a failing baseline first**.

1. **Confirm the task and locate the skill home**. See **Skill Home**.
2. **Capture intent** from the user's request and conversation history. See **Intent Capture**.
3. **Classify the skill type** based on what it must do. See **Skill Type**.
4. **Design a pressure scenario** that exposes the failure the skill must prevent. See **Baseline Scenario**.
5. **Run the scenario without the skill** and capture the failure and rationalizations. See **RED Phase**.
6. **Write a minimal SKILL.md** that addresses the observed failures. See **GREEN Phase**.
7. **Apply format practices** to the new skill before testing it. See **Apply Format Practices**.
8. **Run the scenario with the skill** and verify the agent now complies. See **Verify GREEN**.
9. **Close loopholes** if the agent finds new rationalizations. See **REFACTOR Phase**.
10. **Validate** the skill frontmatter and structure. See **Validation**.
11. **Return a brief in-chat summary** using `references/chat-response-template.md` and list the files written.

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

Confirm the answers with the user before proceeding to the next step.

## Skill Type

Choose the type that best matches the skill's purpose:

| Type | Description | Example |
| --- | --- | --- |
| Technique | Concrete method with steps to follow | condition-based-waiting |
| Pattern | Way of thinking about problems | flatten-with-flags |
| Reference | API docs, syntax guides, tool documentation | office docs |
| Discipline-enforcing | Rules that agents might rationalize away | TDD, verify-before-completion |

The skill type determines how you test and harden it.

## Baseline Scenario

Before writing the skill, design a realistic pressure scenario that would cause an agent to fail without the skill.

A good scenario:

- Uses concrete constraints: real paths, times, consequences.
- Forces the agent to act, not just describe.
- Combines 2-3 pressures for discipline skills (time, sunk cost, authority, exhaustion).
- Targets the exact failure the skill must prevent.

Write the scenario into a file under the skill's `tests/` or `scenarios/` directory, or keep it in a temporary workspace file if the skill has no test directory yet.

## RED Phase

Run the baseline scenario **without** the skill.

1. Spawn a subagent with the scenario prompt.
2. Do not give it the skill.
3. Document:
   - What choice the agent made.
   - What rationalizations it used, verbatim.
   - Which pressures triggered the failure.

This is the failing test. If the agent does not fail, the scenario is not pressurized enough — redesign it before writing the skill.

## GREEN Phase

Write a minimal `SKILL.md` that addresses the specific failures observed in the RED phase.

### Required Frontmatter

```yaml
---
name: <skill-name>
description: Use when <specific triggering conditions and symptoms>
---
```

Rules for the frontmatter:

- `name` must use letters, numbers, and hyphens only.
- `description` must start with "Use when..." and describe triggering conditions only. Do not summarize the workflow.
- Keep the description under 500 characters if possible, 1024 maximum.
- Write in third person.

### Required Sections

1. **## Overview** — core principle in 1-2 sentences.
2. **## When to Use** — symptoms and contexts that trigger this skill. Include when NOT to use.
3. **## Workflow** or **Core Pattern** — the technique, pattern, or rule the agent must follow.
4. **## Common Mistakes** — what goes wrong and how to fix it.

For discipline-enforcing skills, also include:

- A foundational principle such as "Violating the letter of the rules is violating the spirit of the rules."
- A rationalization table.
- A red flags list.

### Form That Matches the Failure

Choose the guidance form based on the baseline failure:

| Baseline failure | Right form |
| --- | --- |
| Skips/violates a rule under pressure | Prohibition + rationalization table + red flags |
| Output has wrong shape | Positive recipe or contract: state what the output IS |
| Omits a required element | Structural: REQUIRED field or slot in template |
| Behavior should depend on a condition | Conditional keyed to an observable predicate |

Keep the skill concise. One excellent example beats many mediocre ones.

## Apply Format Practices

Immediately after writing the first draft, apply the practices from `references/format.md` before running the verification scenario:

1. **Check structure**. Ensure the skill has a concise `## Workflow` written as numbered steps, with a fallback for freeform tasks.
2. **Move detail out of the workflow**. Task-specific procedures, examples, edge cases, and configuration notes should live in dedicated sections or `references/<page>.md` files.
3. **Optimize the description**. Confirm the frontmatter description starts with "Use when...", describes triggering conditions only, is written in third person, and does not summarize the workflow.
4. **Run the available validator** if one exists.

Fix any format issues now. A well-formatted skill is easier to verify and harder to misinterpret.

## Verify GREEN

Run the same scenario **with** the skill loaded.

1. Spawn a subagent with the scenario prompt.
2. Give it access to the skill.
3. Verify the agent now complies and cites the skill.

If the agent still fails, revise the skill and re-test.

## REFACTOR Phase

If the agent complies but finds a new rationalization, add an explicit counter and re-test.

- Add the new excuse to the rationalization table.
- Add a matching red flag.
- Tighten the rule or add a conditional.

Repeat until the skill is bulletproof for the scenario.

## Validation

Validate the skill before finishing:

1. Confirm `SKILL.md` exists and has valid YAML frontmatter with `name` and `description`.
2. Confirm `name` matches the directory name for project-scoped skills.
3. Confirm the description starts with "Use when..." and does not summarize the workflow.
4. Confirm the overview, when-to-use, and workflow/core-pattern sections exist.
5. If a skill validator such as `skill-creator/scripts/quick_validate.py` is available, run it on the target skill folder.

Report any validation failures and fix them before returning the summary.

## Output Contract

By default, `create` writes files inside the target skill folder and returns a brief chat summary. It does not produce analysis reports under `<output-dir>`.

The chat summary must include:

- The skill folder path.
- The skill type chosen.
- Files written or changed.
- Baseline failure observed.
- Verification result.
- Next recommended step (for example, run additional pressure scenarios or hand off for review).
