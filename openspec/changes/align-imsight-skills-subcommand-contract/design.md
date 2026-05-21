## Context

The Imsight skills have been grouped under `skillset/imsight-skills/` and now share a suite README that describes invocation contracts. The individual skill entrypoints already tend to act as indexes, but they use mixed terminology such as `Operations`, `Setup Index`, `Reference Index`, `Actions`, and `Subskills`, and they do not consistently define `help`, no-subcommand behavior, or task-only subcommand selection.

The main stakeholders are agents and humans invoking Imsight workflows. They need predictable command-like behavior while preserving each skill's existing detailed workflow files and reference pages.

## Goals / Non-Goals

**Goals:**

- Make every `imsight-*` skill entrypoint follow the suite-level subcommand contract.
- Preserve existing workflow behavior while making invocation semantics explicit.
- Keep `SKILL.md` compact and use it as the command router and subcommand index.
- Ensure task-only invocations can map to one subcommand or a sequence of subcommands.
- Keep detailed procedure content in existing subskill, invocation, workflow, primitive, or reference files.

**Non-Goals:**

- Do not redesign the underlying OpenSpec, networking, Python, or installation workflows.
- Do not add new runtime dependencies.
- Do not require all skills to use the same physical folder name, as existing skills already use `workflows/`, `invocations/`, `primitives/`, `subskills/`, and `references/` appropriately.
- Do not change Houmao-managed agent messaging behavior.

## Decisions

1. Use a common entrypoint section model.

   Each `SKILL.md` should include a `Subcommands` section with named commands, a `Workflow` or `Entrypoint Workflow` section that chooses subcommands from explicit names or task prompts, and guardrails or maintenance notes as needed. This keeps the contract visible without forcing detailed workflow pages into the entrypoint.

   Alternative considered: add only the suite-level README contract. That leaves individual skills ambiguous when loaded directly.

2. Treat `help` as an entrypoint behavior, not a separate file by default.

   The `help` subcommand should be satisfied by summarizing the `SKILL.md` subcommand index unless a skill later needs a richer help page. This avoids creating many low-value files while still making `help` universal.

   Alternative considered: create `subskills/help.md` in every skill. That would duplicate the index content and increase maintenance overhead.

3. Preserve existing detailed resource layout.

   Autodev master can continue using `workflows/`, `invocations/`, and `primitives/`; dev-box and Python skills can continue using `references/`; autodev slave can continue using `subskills/`. The new contract governs naming and routing at the entrypoint level, not the internal directory taxonomy.

   Alternative considered: move every detailed workflow into `subskills/`. That would be a noisy migration with little functional gain.

4. Normalize implicit invocation metadata.

   Skills that are intended for explicit Imsight context should prefer `policy.allow_implicit_invocation: false` in `agents/openai.yaml`, matching the suite's "normally should not trigger automatically" posture. Their frontmatter descriptions should still mention `imsight` context and explicit naming so agents know when to load them.

   Alternative considered: leave UI metadata unchanged. That could conflict with the suite contract by encouraging generic automatic triggering.

## Risks / Trade-offs

- Entry point drift -> Keep subcommand names and descriptions in `SKILL.md` authoritative; update linked references when adding subcommands.
- Over-normalization -> Do not force every skill into identical internals; only normalize invocation and router semantics.
- Help duplication -> Implement `help` as a behavior over the subcommand index instead of duplicated help files.
- Accidental trigger broadening -> Keep frontmatter and `agents/openai.yaml` aligned with explicit naming, internal routing, or relevant `imsight` context.
