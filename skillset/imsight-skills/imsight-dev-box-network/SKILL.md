---
name: imsight-dev-box-network
description: Imsight-authored development box networking command guide. Use when explicitly invoked as imsight-dev-box-network, routed from another Imsight skill, or when the prompt or context mentions `imsight` and the user is configuring, auditing, repairing, or documenting dev-box networking services, SSH reverse tunnels, SSH forward tunnels, proxy services, relay access, exposed ports, systemd user tunnel services, or host-to-host access patterns for Imsight development machines. Do not invoke for generic networking, proxy, tunnel, or dev-box tasks that do not mention `imsight`.
---

# Imsight Dev Box Network

Use this skill as the entrypoint for development box networking tasks. Keep `SKILL.md` as a command router and load the specific networking reference needed for the task.

## Invocation Contract

- Preferred explicit form: `$imsight-dev-box-network use <subcommand> to do <task>`.
- Task-only form: `$imsight-dev-box-network <task prompt>` means choose the applicable networking subcommand or sequence from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- |
| `help` | Explain this dev-box networking skill and list available subcommands | This entrypoint |
| `ssh-tunnels` | Set up, inspect, repair, or remove SSH reverse/forward tunnels | `references/ssh-tunnels.md` |
| `proxy-setup` | Install proxy environment scripts and populate grouped proxy candidates from local, remote, or tunneled proxy ports | `references/install-proxy-script.md` |
| `scan-proxy` | Discover candidate proxy ports, then optionally update the managed shell startup proxy candidate block | `references/install-proxy-script.md` and `scripts/scan-proxy-candidates.py` |

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
4. If the selected subcommand is `scan-proxy`, ask for the port or port range when the user has not provided one, run `scripts/scan-proxy-candidates.py` on the target host, then update the managed shell startup proxy candidate block when the user wants persisted proxy discovery.
5. If the user asks vaguely, such as "setup ssh tunnel", ask for the required tunnel details before changing anything.
6. Inspect existing services and ports before changing anything.
7. Prefer user systemd services for persistent tunnels unless the user wants tmux/foreground operation.
8. For systemd tunnel services, keep startup non-blocking by using foreground `--block` under `Type=simple` without `network-online.target` or background wrappers; keep shutdown fast with `TimeoutStopSec=1` and control-group kill behavior.
9. For destructive cleanup, remove only the stale service/process requested and verify the intended reverse SSH access tunnel remains healthy.

## Safety Rules

- Do not store real host inventory, private IPs, public IPs, live ports, usernames, relay aliases, or service names from the current machine in this skill.
- Do not expose SSH login tunnels on `0.0.0.0` unless the user explicitly asks.
- Do not remove working reverse SSH login tunnels while cleaning unrelated forward tunnels.
- Do not embed credentials or private keys in service files or docs.
- Use `BatchMode=yes` for non-interactive connectivity checks.
- Do not create tunnel units that can delay boot, shutdown, or reboot while waiting for SSH readiness or graceful disconnect.
