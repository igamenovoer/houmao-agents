---
name: call-codex-with-openspec-cmd
description: How to invoke OpenSpec skills for a Codex-based Houmao managed agent using the $openspec-* command syntax via gateway prompt.
license: MIT
---

# Call Codex with OpenSpec Commands

Use this skill when you need to instruct a Codex-based Houmao managed agent to use OpenSpec skills. The correct invocation is via **gateway prompt** with the `$openspec-<skill-name>` command prefix.

## Available OpenSpec Commands

| Command | Skill | Purpose |
|---------|-------|---------|
| `$openspec-explore` | `openspec-explore` | Explore openspec/ directory and understand change artifacts |
| `$openspec-propose` | `openspec-propose` | Create a new OpenSpec change proposal |
| `$openspec-apply-change` | `openspec-apply-change` | Implement an OpenSpec change |
| `$openspec-ext-explain` | `openspec-ext-explain` | Create/update Q&A docs under explain/ directory |
| `$openspec-ext-hack-through-test` | `openspec-ext-hack-through-test` | Propose, revise, or run hack-through-test mode |
| `$openspec-ext-respond-to-review` | `openspec-ext-respond-to-review` | Read review report and decide open questions |
| `$openspec-ext-review-plan` | `openspec-ext-review-plan` | Review current OpenSpec change and write report |
| `$openspec-ext-revise-by-decision` | `openspec-ext-revise-by-decision` | Push review decisions into change artifacts |

## Invocation Syntax

```bash
houmao-mgr agents gateway prompt \
  --agent-name <agent-name> \
  --prompt "$openspec-<command> <arguments>"
```

## Examples

### Explore an issue
```bash
houmao-mgr agents gateway prompt \
  --agent-name hm-worker \
  --prompt "$openspec-explore igamenovoer/houmao#60: env vars from launch profiles not propagated to Codex TUI processes"
```

### Propose a new change
```bash
houmao-mgr agents gateway prompt \
  --agent-name hm-worker \
  --prompt "$openspec-propose implement-foo-bar"
```

### Apply an existing change
```bash
houmao-mgr agents gateway prompt \
  --agent-name hm-worker \
  --prompt "$openspec-apply-change openspec/changes/2026-04-30-implement-foo-bar"
```

### Respond to review
```bash
houmao-mgr agents gateway prompt \
  --agent-name hm-worker \
  --prompt "$openspec-ext-respond-to-review openspec/changes/2026-04-30-implement-foo-bar/review/review-20260430-120000.md"
```

### Revise by decision
```bash
houmao-mgr agents gateway prompt \
  --agent-name hm-worker \
  --prompt "$openspec-ext-revise-by-decision openspec/changes/2026-04-30-implement-foo-bar"
```

## Prerequisites

- Agent must be **Codex-based** Houmao managed agent (TUI transport)
- Agent must have a **live gateway** (`gateway_health: healthy`)
- Agent's workdir should contain `openspec/` directory
- Agent should have OpenSpec skills in its skillset

## Verification

Check gateway status before sending:

```bash
houmao-mgr agents gateway status --agent-name <agent-name>
```

Expected:
- `gateway_health: healthy`
- `managed_agent_connectivity: connected`
- `request_admission: open`

## Pitfalls

- **Always use `gateway prompt`**, not `agents prompt` — the latter bypasses TUI skill loading
- **Always include `$` prefix** — `$openspec-*` is the magic trigger
- **Use `--prompt` flag**, not `--message`
- If agent returns `not_ready`, the TUI may be in modal state — wait or interrupt first

## Related Skills

- `houmao-agent-messaging` — general agent communication patterns
- `houmao-agent-inspect` — checking agent liveness and gateway status
