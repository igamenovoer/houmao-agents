---
name: imsight-autodev-master
description: Manual invocation only; Imsight-authored layered master-agent dispatch entrypoint for sending OpenSpec-oriented development requests to Houmao-managed slave agents. Use when explicitly invoked as imsight-autodev-master, routed from another Imsight skill, or when `imsight` context asks for a maintained master workflow, raw OpenSpec invocation, or imsight-autodev-slave invocation.
---

# Imsight Autodev Master

Use this skill only when the user explicitly invokes `imsight-autodev-master` or asks to use this exact skill. Do not activate it implicitly for ordinary development tasks.

This skill is a master-agent entrypoint. The master agent may be any capable caller, but the target slave is expected to be a Houmao-managed agent. Keep this file small; reusable behavior belongs in the layered pages below.

## Invocation Contract

- Preferred explicit form: `$imsight-autodev-master use <subcommand> to do <task>`.
- Task-only form: `$imsight-autodev-master <task prompt>` means choose the applicable subcommand or sequence from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes master-side notes, reports, manifests, or other skill-owned artifacts, choose the output directory in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/autodev-master/`.

This contract does not move slave-owned OpenSpec artifacts or target-workdir mutations; those remain in the target slave workspace selected by the dispatched workflow.

## Layers

### Workflows

Use workflows when the user describes an outcome and the master must decide which invocation to send.

- [commands/workflows/prepare-slave-for-openspec.md](commands/workflows/prepare-slave-for-openspec.md): Ask the slave to ensure `openspec/` exists in its own workdir.
- [commands/workflows/delegated-openspec-lifecycle.md](commands/workflows/delegated-openspec-lifecycle.md): Choose whole-lifecycle delegation versus a bounded phase.
- [commands/workflows/bounded-openspec-phase.md](commands/workflows/bounded-openspec-phase.md): Dispatch one explicit OpenSpec phase.
- [commands/workflows/continue-existing-change.md](commands/workflows/continue-existing-change.md): Continue an existing OpenSpec change from known state.
- [commands/workflows/recover-or-finalize-change.md](commands/workflows/recover-or-finalize-change.md): Recover, sync, or archive partially completed OpenSpec work.

### Raw OpenSpec Invocations

Use raw invocation leaves when the master already knows the exact OpenSpec skill to invoke on the slave.

- [commands/invocations/raw-openspec/explore.md](commands/invocations/raw-openspec/explore.md): Dispatch `$openspec-explore` or `/openspec-explore`.
- [commands/invocations/raw-openspec/propose.md](commands/invocations/raw-openspec/propose.md): Dispatch `$openspec-propose` or `/openspec-propose`.
- [commands/invocations/raw-openspec/apply-change.md](commands/invocations/raw-openspec/apply-change.md): Dispatch `$openspec-apply-change` or `/openspec-apply-change`.
- [commands/invocations/raw-openspec/sync-specs.md](commands/invocations/raw-openspec/sync-specs.md): Dispatch `$openspec-sync-specs` or `/openspec-sync-specs`.
- [commands/invocations/raw-openspec/archive-change.md](commands/invocations/raw-openspec/archive-change.md): Dispatch `$openspec-archive-change` or `/openspec-archive-change`.

### Slave Skill Invocations

Use slave-skill invocation leaves for predefined `imsight-autodev-slave` operations.

- [commands/invocations/slave-skill/init-openspec.md](commands/invocations/slave-skill/init-openspec.md): Dispatch `imsight-autodev-slave init-openspec`.
- [commands/invocations/slave-skill/openspec-one-pass.md](commands/invocations/slave-skill/openspec-one-pass.md): Dispatch `imsight-autodev-slave openspec-one-pass`.

### Shared Primitives

All workflows and invocation leaves should reuse these primitives instead of duplicating dispatch rules.

- [references/primitives/inspect-slave.md](references/primitives/inspect-slave.md): Recover supported slave metadata.
- [references/primitives/render-invocation.md](references/primitives/render-invocation.md): Render Codex `$...` versus Claude `/...` command syntax.
- [references/primitives/deliver-to-slave.md](references/primitives/deliver-to-slave.md): Deliver through supported Houmao messaging surfaces.
- [references/primitives/mail-notifier-policy.md](references/primitives/mail-notifier-policy.md): Treat mail-notifier appendix text as persistent policy, not one-off mail steering.

## Subcommands

These user-facing subcommands route into the layered pages:

- `help`: Explain this master dispatch skill and list available subcommands.
- `inspect-slave`: Recover supported slave metadata with [references/primitives/inspect-slave.md](references/primitives/inspect-slave.md).
- `init-slave-for-openspec`: Ask the slave to initialize `openspec/` by using [commands/workflows/prepare-slave-for-openspec.md](commands/workflows/prepare-slave-for-openspec.md).
- `openspec-one-pass`: Dispatch the slave-owned one-pass OpenSpec lifecycle with [commands/invocations/slave-skill/openspec-one-pass.md](commands/invocations/slave-skill/openspec-one-pass.md).
- `openspec-explore`: Dispatch `$openspec-explore` or `/openspec-explore` with [commands/invocations/raw-openspec/explore.md](commands/invocations/raw-openspec/explore.md).
- `openspec-propose`: Dispatch `$openspec-propose` or `/openspec-propose` with [commands/invocations/raw-openspec/propose.md](commands/invocations/raw-openspec/propose.md).
- `openspec-apply-change`: Dispatch `$openspec-apply-change` or `/openspec-apply-change` with [commands/invocations/raw-openspec/apply-change.md](commands/invocations/raw-openspec/apply-change.md).
- `openspec-sync-specs`: Dispatch `$openspec-sync-specs` or `/openspec-sync-specs` with [commands/invocations/raw-openspec/sync-specs.md](commands/invocations/raw-openspec/sync-specs.md).
- `openspec-archive-change`: Dispatch `$openspec-archive-change` or `/openspec-archive-change` with [commands/invocations/raw-openspec/archive-change.md](commands/invocations/raw-openspec/archive-change.md).

## Workflow

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, follow that subcommand's linked page.
3. If the request is task-only, choose the applicable subcommand or sequence of subcommands from the task; for higher-level outcomes, read the matching workflow page first.
4. For explicit raw OpenSpec skill calls, read the matching raw invocation page.
5. For explicit `imsight-autodev-slave` actions, read the matching slave-skill invocation page.
6. Before any dispatch, use [references/primitives/inspect-slave.md](references/primitives/inspect-slave.md) to recover the slave metadata needed for rendering and delivery.
7. If the operation, target slave, or request body is missing or ambiguous, ask for the smallest clarification needed.
8. After a request is accepted or delivered to the slave, finish the turn by default.

## Guardrails

- Do not guess the slave agent selector, tool lane, gateway posture, mailbox posture, or delivery lane.
- Prefer supported Houmao inspection and messaging surfaces over direct runtime file searches; see [references/primitives/inspect-slave.md](references/primitives/inspect-slave.md) and [references/primitives/deliver-to-slave.md](references/primitives/deliver-to-slave.md).
- For Codex-based slaves, render OpenSpec commands with `$openspec-*` and the slave mega-skill command as `$imsight-autodev-slave`; see [references/primitives/render-invocation.md](references/primitives/render-invocation.md).
- For Claude-based slaves, render OpenSpec commands with `/openspec-*` and the slave mega-skill command as `/imsight-autodev-slave`; see [references/primitives/render-invocation.md](references/primitives/render-invocation.md).
- For mail-based messaging, include the rendered invocation command in the mail body for one-off behavior; see [references/primitives/mail-notifier-policy.md](references/primitives/mail-notifier-policy.md).
- Do not initialize or copy files into the slave workdir directly; dispatch the initialization request to the slave.
- Do not wait for or inspect the slave's follow-up, gateway state, mailbox state, TUI output, or results unless the user explicitly asks.
