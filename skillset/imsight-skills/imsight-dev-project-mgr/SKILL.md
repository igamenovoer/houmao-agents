---
name: imsight-dev-project-mgr
description: Manual invocation only; Imsight-authored project management skill for git worktree operations. Use when explicitly invoked as imsight-dev-project-mgr, routed from another Imsight skill, or when an Imsight-scoped request asks to create a clean git worktree or implement a change in an isolated local worktree without disturbing the active checkout.
---

# Imsight Dev Project Manager

Use this skill only when the user explicitly invokes `imsight-dev-project-mgr` or asks to use this exact skill. Do not activate it implicitly for ordinary development tasks.

This skill manages isolated git worktree workflows: creating clean worktrees with shared local state, and implementing changes on fresh local branches inside dedicated worktrees. Keep this file small; reusable behavior belongs in the subskill pages below.

## Invocation Contract

- Preferred explicit form: `$imsight-dev-project-mgr use <subcommand> to do <task>`.
- Task-only form: `$imsight-dev-project-mgr <task prompt>` means choose the applicable subcommand or sequence from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes skill-owned artifacts, reports, or manifests, resolve the output directory in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values resolve from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/dev-project-mgr/`.

Worktree paths and implementation branches follow their own subskill defaults, which are also rooted under `<project-dir>/.imsight-arts/`.

## Subcommands

- `help`: Explain this skill and list available subcommands.
- `create-worktree`: Create a clean git worktree with shared local-state symlinks. See [subskills/create-worktree.md](subskills/create-worktree.md).
- `impl-in-worktree`: Implement a change on a fresh local branch inside an isolated worktree. See [subskills/impl-in-worktree.md](subskills/impl-in-worktree.md).

## Workflow

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, follow that subcommand's linked page.
3. If the request is task-only, choose the applicable subcommand or sequence of subcommands from the task.
4. If the operation, target, or request body is missing or ambiguous, ask for the smallest clarification needed.

## Guardrails

- Do not switch branches or edit files in the developer's original checkout after an isolated worktree exists.
- Never copy the repository manually; use `git worktree`.
- Never push, open a PR, or delete a branch or worktree unless the developer explicitly asks.
- Never treat a missing local resource as a product bug before checking whether it should simply be bridged into the worktree.
- For OpenSpec targets inside `impl-in-worktree`, never bypass OpenSpec CLI discovery by hard-coding artifact layouts.
