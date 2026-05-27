---
name: imsight-dev-box-network
description: Imsight-authored development box networking command guide. Use when explicitly invoked as imsight-dev-box-network, routed from another Imsight skill, or when the prompt or context mentions `imsight` and the user is configuring, auditing, repairing, or documenting dev-box networking services, SSH reverse tunnels, SSH forward tunnels, SSH-based proxy access, proxy services, relay access, exposed ports, systemd user tunnel services, or host-to-host access patterns for Imsight development machines. Do not invoke for generic networking, proxy, tunnel, or dev-box tasks that do not mention `imsight`.
---

# Imsight Dev Box Network

Use this skill as the entrypoint for development box networking tasks. Keep `SKILL.md` as a command router and load the specific networking reference needed for the task.

## Invocation Contract

- Preferred explicit form: `$imsight-dev-box-network use <subcommand> to do <task>`.
- Proxy setup second-level form: `$imsight-dev-box-network use proxy-setup <subcommand> to do <task>`.
- Task-only form: `$imsight-dev-box-network <task prompt>` means choose the applicable networking subcommand or sequence from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Output Contract

When this skill writes networking notes, scan reports, manifests, or other skill-owned artifacts, choose the output directory in this order:

1. Use the output location explicitly provided by the user.
2. Otherwise, use `IMSIGHT_SKILL_OUTPUT_DIR` when set; relative values are resolved from the current project directory and absolute values are used as-is.
3. Otherwise, use `<project-dir>/.imsight-arts/dev-box-network/`.

This contract does not replace intentional operational destinations such as copied helper scripts, shell startup files, or user systemd service files required by a networking setup workflow.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this dev-box networking skill and list available subcommands | This entrypoint |
| `ssh-tunnels` | Set up, inspect, repair, or remove SSH reverse/forward tunnels | `references/ssh-tunnels.md` |
| `proxy-setup` | Set up proxy access, install proxy environment scripts, or scan proxy candidates | `references/proxy-setup.md` |

## Bundled Scripts

Use the bundled scripts instead of rewriting tunnel loops:

- `scripts/setup-ssh-reverse-tunnel.sh`
- `scripts/setup-ssh-forward-tunnel.sh`
- `scripts/scan-proxy-candidates.py`
- `scripts/setup-proxy.sh`
- `scripts/unset-proxy.sh`

Copy them to the target dev box when missing or stale, make them executable, then create or update the matching user systemd service.

## Operating Procedure

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, load that subcommand's reference or script guidance.
3. If the request is task-only, choose the applicable networking subcommand or sequence from the task.
4. If the selected subcommand has second-level subcommands, load its reference file and choose the applicable second-level subcommand from that page.
5. If the selected proxy setup second-level subcommand is `proxy-scan`, ask for the port or port range when the user has not provided one, run `scripts/scan-proxy-candidates.py` on the target host, then update the managed shell startup proxy candidate block when the user wants persisted proxy discovery.
6. If the selected proxy setup second-level subcommand is `via-ssh`, distinguish SSH dynamic SOCKS5 forwarding from forwarding an existing proxy service before choosing commands or service units.
7. If the user asks vaguely, such as "setup ssh tunnel", ask for the required tunnel details before changing anything.
8. Inspect existing services and ports before changing anything.
9. Prefer user systemd services for persistent tunnels unless the user wants tmux/foreground operation.
10. For systemd tunnel services, keep both startup and shutdown non-blocking: use foreground `--block` under `Type=simple`, do not use `network-online.target`, `ExecStartPre` connectivity checks, readiness waits, `--background`, or `nohup`; keep shutdown fast with `TimeoutStopSec=1`, `KillMode=control-group`, `KillSignal=SIGKILL`, and `SendSIGKILL=yes`.
11. For destructive cleanup, remove only the stale service/process requested and verify the intended reverse SSH access tunnel remains healthy.

## Safety Rules

- Do not store real host inventory, private IPs, public IPs, live ports, usernames, relay aliases, or service names from the current machine in this skill.
- Do not expose SSH login tunnels on `0.0.0.0` unless the user explicitly asks.
- Do not remove working reverse SSH login tunnels while cleaning unrelated forward tunnels.
- Do not embed credentials or private keys in service files or docs.
- Use `BatchMode=yes` for non-interactive connectivity checks.
- Do not create tunnel units that can delay boot, shutdown, or reboot while waiting for SSH readiness or graceful disconnect.
