## Context

`imsight-autodev-master` was introduced as a master-side dispatch skill for Houmao-managed slave agents. It currently has a compact entrypoint plus flat subskill pages for slave inspection, direct OpenSpec dispatch, one-pass slave workflow dispatch, and OpenSpec initialization dispatch.

That flat shape was enough for the first workflows, but the master skill now needs to grow in three different directions:

- raw invocation guidance for skills that live on the slave, such as `openspec-explore` and `openspec-apply-change`;
- slave mega-skill invocation guidance for maintained `imsight-autodev-slave` operations;
- master-side workflows that decide which invocation to use for a higher-level outcome.

Keeping all of these as peer "operations" makes the entrypoint ambiguous and risks duplicating dispatch rules across future pages.

## Goals / Non-Goals

**Goals:**

- Make `SKILL.md` a small router into layered master documentation.
- Separate raw OpenSpec skill invocation pages from `imsight-autodev-slave` invocation pages.
- Add workflow pages that compose invocation leaves and branch by user intent.
- Extract repeated inspection, command rendering, delivery, and mail-notifier policy guidance into shared primitive pages.
- Preserve current dispatch behavior, command syntax, and send-and-stop defaults.

**Non-Goals:**

- Change Houmao CLI behavior or add runtime dependencies.
- Change the slave-side execution semantics of `imsight-autodev-slave`.
- Require the master to inspect slave follow-up after delivery.
- Implement new OpenSpec lifecycle operations beyond documenting the layered routing model.

## Decisions

### Decision: `SKILL.md` Becomes an Entrypoint and Layer Index

The master `SKILL.md` will describe the three layers and route to the right page:

1. workflows for outcome-oriented requests,
2. raw invocation leaves for explicit OpenSpec phase dispatch,
3. slave-skill invocation leaves for predefined `imsight-autodev-slave` actions.

Alternative considered: keep adding flat `subskills/*.md` pages. That would keep the initial structure simple but makes it harder to tell whether a page is a workflow, a raw command, or a slave mega-skill command.

### Decision: Shared Dispatch Primitives Are Separate Pages

Common behavior will move into reusable primitive pages:

- inspect the Houmao-managed slave;
- render native invocation syntax for Codex versus Claude;
- deliver through supported Houmao messaging surfaces;
- handle mail-notifier appendix policy as persistent policy, not one-off mail steering.

Invocation and workflow pages will reference these primitives instead of restating their full rules.

Alternative considered: duplicate inspection and delivery guidance on every invocation page. This is easy to read locally but creates drift, especially around mailbox delivery and notifier appendix side effects.

### Decision: Invocation Pages Are Leaves

Raw invocation pages and slave-skill invocation pages will explain command meaning, prerequisites, implications, and rendering, but they will not decide a broader workflow. For example, a raw `openspec-apply-change` invocation page documents that it requires an existing change and mutates the target repository; it does not decide whether exploration should happen first.

Alternative considered: put "when to use it" branching logic in every invocation page. That makes each page more self-contained but spreads workflow policy across many leaves.

### Decision: Workflows Compose Invocation Leaves

Workflow pages will own branching decisions such as:

- prepare a slave for OpenSpec work;
- delegate a whole OpenSpec lifecycle in one pass;
- send a bounded OpenSpec phase;
- continue, recover, or finalize an existing change.

Each workflow will choose one or more invocation leaves, then stop after accepted delivery unless follow-up inspection is explicitly requested.

Alternative considered: keep workflows implicit in the entrypoint operations list. That does not scale once workflows begin branching by repository state, user intent, or target agent posture.

## Risks / Trade-offs

- More files can make the skill feel harder to browse -> keep `SKILL.md` as a clear layer index and keep leaf pages short.
- Moving flat subskills can break stale internal links -> update all relative links and validate the skill after implementation.
- Duplicated concepts between workflow and invocation pages can still drift -> make workflows reference invocation leaves for command semantics rather than restating them.
- External readers may know the old flat subskill names -> preserve operation names in `SKILL.md` as user-facing commands while changing the internal page layout.
