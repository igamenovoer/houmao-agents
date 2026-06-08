# Imsight Skills

This directory collects engineering automation skills written in the Imsight style.

These skills encode Imsight's taste in software engineering practice: standard operating procedures, artifact naming, project structure, architecture preferences, preferred libraries, favored implementation patterns, and the conventions used to keep repeated development work consistent.

Use these skills when a task should follow Imsight-authored workflows rather than generic defaults. They are intended to make automation behave like a reusable engineering playbook: explicit about process, consistent about outputs, and opinionated where consistency matters.

The skills in this directory are designed to work as a suite. Individual skills may route to, invoke, or rely on other Imsight skills for sub-workflows. Installing only part of the suite can leave some functionality unavailable or incomplete.

## Contracts

- Invocation by Imsight context: `imsight-*` skills are eligible when `imsight` is mentioned in the prompt or surrounding context and the task is relevant to one of the covered workflows. Examples include `use imsight skills`, `in imsight's style`, `follow imsight SOP`, or a request for an Imsight-authored process.
- Invocation by routing or name: these skills may also be invoked by internal routing from another Imsight skill, or when the user explicitly names the skill.
- Default triggering posture: outside explicit naming, internal routing, or relevant prompts that mention `imsight`, these skills normally should not trigger automatically for generic tasks.
- Command shape: organize each `imsight-*` skill like a main command with many subcommands. The preferred invocation style is `$imsight-<what> use <subcommand-name> to do <task>`.
- Task-only invocation: invoking a skill with a task prompt, such as `$imsight-<what> <task prompt>`, asks the agent to inspect the task and select the applicable subcommand.
- Universal `help` subcommand: every `imsight-*` skill should support `help`. `help` explains what the skill does and lists available subcommands with short explanations.
- Default subcommand: invoking an `imsight-*` skill without a subcommand means `help` by default.
- Output directory discovery: when an `imsight-*` skill writes artifacts, first respect an output location explicitly provided by the user. If none is provided, check `IMSIGHT_SKILL_OUTPUT_DIR` and use the relative or absolute directory named there. If that variable is unset, write under `<project-dir>/.imsight-arts/<subdir>`, where `<subdir>` is chosen by the skill or subcommand.
- Implementation style: most Imsight skills use `SKILL.md` as a compact entrypoint, command router, and subcommand index. `SKILL.md` should describe what each subcommand does, and its entrypoint workflow should tell the agent to choose the right subcommand or sequence of subcommands based on the given task. Detailed workflows, subcommands, references, and reusable procedures should live in subskills or reference files linked from that entrypoint.

## Skill Index

- [`imsight-autodev-master`](imsight-autodev-master/SKILL.md): Master-agent dispatch entrypoint for sending OpenSpec-oriented development requests to Houmao-managed slave agents. It chooses maintained workflows, raw OpenSpec invocations, or slave-skill invocations and then dispatches without taking over the slave's work.
- [`imsight-autodev-slave`](imsight-autodev-slave/SKILL.md): Slave-agent automation entrypoint for Houmao-managed agents that receive explicit master requests. It owns maintained request-processing workflows such as OpenSpec initialization and one-pass OpenSpec explore/propose/apply/sync/archive flows.
- [`imsight-dev-box-init`](imsight-dev-box-init/SKILL.md): Development host setup and installation index for Imsight-preferred tooling. It covers software installs, development packages, CLI tooling, Houmao tooling, Tavily setup, `claude-kimi`, and related dev-box bootstrap work.
- [`imsight-dev-box-network`](imsight-dev-box-network/SKILL.md): Development box networking guide for Imsight machines. It covers proxy setup and repair, SSH forward and reverse tunnels, relay access, exposed ports, systemd user tunnel services, and host-to-host access patterns.
- [`imsight-info-gathering`](imsight-info-gathering/SKILL.md): Online information gathering workflow for searching, extracting, downloading, source-ledger building, and synthesizing cited reports from multiple sources.
- [`imsight-dev-project-mgr`](imsight-dev-project-mgr/SKILL.md): Git worktree and isolated implementation branch manager. It creates clean worktrees with shared local state and implements changes on fresh local branches inside dedicated worktrees without disturbing the active checkout.
- [`imsight-python-general`](imsight-python-general/SKILL.md): General Python development operations standard for Imsight-style Python projects. It covers Pixi-managed project structure, packaging layout, source/test/docs/context organization, dependency workflow, and lint/type/test operations.
