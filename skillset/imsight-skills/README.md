# Imsight Skills

This directory collects engineering automation skills written in the Imsight style.

These skills encode Imsight's taste in software engineering practice: standard operating procedures, artifact naming, project structure, architecture preferences, preferred libraries, favored implementation patterns, and the conventions used to keep repeated development work consistent.

Use these skills when a task should follow Imsight-authored workflows rather than generic defaults. They are intended to make automation behave like a reusable engineering playbook: explicit about process, consistent about outputs, and opinionated where consistency matters.

The skills in this directory are designed to work as a suite. Individual skills may route to, invoke, or rely on other Imsight skills for sub-workflows. Installing only part of the suite can leave some functionality unavailable or incomplete.

## Skill Index

- [`imsight-autodev-master`](imsight-autodev-master/SKILL.md): Master-agent dispatch entrypoint for sending OpenSpec-oriented development requests to Houmao-managed slave agents. It chooses maintained workflows, raw OpenSpec invocations, or slave-skill invocations and then dispatches without taking over the slave's work.
- [`imsight-autodev-slave`](imsight-autodev-slave/SKILL.md): Slave-agent automation entrypoint for Houmao-managed agents that receive explicit master requests. It owns maintained request-processing workflows such as OpenSpec initialization and one-pass OpenSpec explore/propose/apply/sync/archive flows.
- [`imsight-dev-box-init`](imsight-dev-box-init/SKILL.md): Development host setup and installation index for Imsight-preferred tooling. It covers software installs, development packages, CLI tooling, Houmao tooling, Tavily setup, `claude-kimi`, and related dev-box bootstrap work.
- [`imsight-dev-box-network`](imsight-dev-box-network/SKILL.md): Development box networking guide for Imsight machines. It covers proxy setup and repair, SSH forward and reverse tunnels, relay access, exposed ports, systemd user tunnel services, and host-to-host access patterns.
- [`imsight-info-gathering`](imsight-info-gathering/SKILL.md): Online information gathering workflow for searching, extracting, downloading, source-ledger building, and synthesizing cited reports from multiple sources.
- [`imsight-python-general`](imsight-python-general/SKILL.md): General Python development operations standard for Imsight-style Python projects. It covers Pixi-managed project structure, packaging layout, source/test/docs/context organization, dependency workflow, and lint/type/test operations.
