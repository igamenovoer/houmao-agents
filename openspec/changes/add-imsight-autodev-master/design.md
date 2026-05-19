## Context

`houmao-agents` already has an `imsight-autodev-slave` skill that acts as a slave-side request processor. The missing companion is a master-side skill for any capable master agent to inspect a Houmao-managed slave, render the correct request command, deliver that request, and stop without waiting for follow-up unless explicitly asked.

The workspace `AGENTS.md` defines two hard constraints for this design:

- Direct OpenSpec prompts to Houmao-managed agents must use `$openspec-*` for Codex-based agents and `/openspec-*` for Claude-based agents.
- After sending prompts, mail, raw input, or other messages to Houmao-managed agents, the sender must not wait for or inspect follow-up by default.

## Goals / Non-Goals

**Goals:**

- Add `imsight-autodev-master` as a mega-skill entrypoint with subskills that behave like subcommands.
- Support master agents that are not themselves Houmao-managed.
- Inspect Houmao-managed slave metadata through supported Houmao read-only surfaces before rendering commands.
- Route OpenSpec-oriented requests to slave agents with the correct Codex or Claude command prefix.
- Make send-and-stop behavior the default after delivery.

**Non-Goals:**

- Launch, stop, relaunch, or repair slave agents.
- Poll the slave for results or inspect TUI/mail/gateway output after dispatch unless the user explicitly asks.
- Replace `imsight-autodev-slave`; the slave skill remains responsible for processing master requests locally.
- Add new Houmao CLI commands, mailbox protocols, or runtime dependencies.

## Decisions

### Decision: Master Skill Owns Dispatch, Slave Skill Owns Execution

`imsight-autodev-master` will focus on selecting a subcommand, inspecting the slave, rendering the request, and delivering it. The slave-side `imsight-autodev-slave` skill remains the execution owner for reusable slave workflows such as `openspec-one-pass`.

Alternative considered: duplicate the full OpenSpec lifecycle workflow inside the master skill. This would blur responsibility and encourage the master to monitor downstream execution.

### Decision: Use a Required `inspect-slave` Subskill Before Dispatch

Every dispatch subskill will first use `inspect-slave` guidance to recover the slave's supported metadata: `agent_name` or `agent_id`, `tool`, lifecycle state, gateway posture, mailbox posture when relevant, working directory, and manifest path when exposed by `houmao-mgr agents state`.

Alternative considered: accept the target tool and delivery lane as user-provided flags only. That is faster but fragile, because a master can misroute Codex versus Claude command syntax.

### Decision: Prefer Supported Houmao Surfaces Over Runtime File Guessing

The master skill will teach this evidence ladder:

1. `houmao-mgr agents list`
2. `houmao-mgr agents state --agent-name <slave>` or `--agent-id <id>`
3. `houmao-mgr agents gateway status --agent-name <slave>`
4. `houmao-mgr agents mail resolve-live --agent-name <slave>` only when mail delivery is relevant
5. Read `manifest.json` only when state exposes `manifest_path` or `session_root` and manifest metadata is needed

Alternative considered: directly search `.houmao/runtime/**/manifest.json`. This is not stable enough as a first choice and bypasses managed-agent identity resolution.

### Decision: Direct OpenSpec Subcommands Use Native OpenSpec Triggers

Atomic OpenSpec subskills render direct OpenSpec commands:

- Codex slave: `$openspec-explore`, `$openspec-propose`, `$openspec-apply-change`, `$openspec-archive-change`
- Claude slave: `/openspec-explore`, `/openspec-propose`, `/openspec-apply-change`, `/openspec-archive-change`

The `openspec-one-pass` master subskill targets the slave mega skill:

- Codex slave: `$imsight-autodev-slave openspec-one-pass <request>`
- Claude slave: `/imsight-autodev-slave openspec-one-pass <request>`

Alternative considered: always target `imsight-autodev-slave`. Direct OpenSpec commands remain useful when the master wants one bounded phase rather than the full slave workflow.

## Risks / Trade-offs

- Slave tool metadata may be missing or ambiguous -> require clarification rather than guessing the command prefix.
- Gateway may be unavailable -> use supported Houmao messaging guidance to select a different delivery lane or report the blocker.
- Manifest fields may drift over time -> treat CLI state/gateway/mail surfaces as primary and manifest inspection as supplemental.
- A user may expect the master to watch results -> document that follow-up inspection is opt-in to preserve the workspace send-and-stop rule.
