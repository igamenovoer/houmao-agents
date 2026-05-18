---
name: imsight-dev-box-network
description: Imsight-authored development box networking setup guide. Use when configuring, auditing, repairing, or documenting dev-box networking services, SSH reverse tunnels, SSH forward tunnels, proxy services, relay access, exposed ports, systemd user tunnel services, or host-to-host access patterns for Imsight development machines.
---

# Imsight Dev Box Network

Use this skill as the entrypoint for development box networking tasks. Keep `SKILL.md` as a router and load the specific networking reference needed for the task.

## Reference Index

| Task | Load |
| --- | --- |
| Set up, inspect, repair, or remove SSH reverse/forward tunnels | `references/ssh-tunnels.md` |
| Install proxy environment scripts and populate grouped proxy candidates from local, remote, or tunneled proxy ports | `references/install-proxy-script.md` |

## Actions

- `scan-proxy`: Load `references/install-proxy-script.md`, ask for the port or port range when the user has not provided one, run `scripts/scan-proxy-candidates.py` on the target host, then update the managed shell startup proxy candidate block when the user wants persisted proxy discovery.

## Bundled Scripts

Use the bundled scripts instead of rewriting tunnel loops:

- `scripts/setup-ssh-reverse-tunnel.sh`
- `scripts/setup-ssh-forward-tunnel.sh`
- `scripts/scan-proxy-candidates.py`
- `scripts/setup-proxy.sh`
- `scripts/unset-proxy.sh`

Copy them to the target dev box when missing or stale, make them executable, then create or update the matching user systemd service.

## Operating Procedure

1. Identify the networking task: tunnel, proxy, relay access, port exposure, or service cleanup.
2. Load the relevant reference page.
3. If the user asks vaguely, such as "setup ssh tunnel", ask for the required tunnel details before changing anything.
4. Inspect existing services and ports before changing anything.
5. Prefer user systemd services for persistent tunnels unless the user wants tmux/foreground operation.
6. For systemd tunnel services, keep startup non-blocking by using foreground `--block` under `Type=simple` without `network-online.target` or background wrappers; keep shutdown fast with `TimeoutStopSec=1` and control-group kill behavior.
7. For destructive cleanup, remove only the stale service/process requested and verify the intended reverse SSH access tunnel remains healthy.

## Safety Rules

- Do not store real host inventory, private IPs, public IPs, live ports, usernames, relay aliases, or service names from the current machine in this skill.
- Do not expose SSH login tunnels on `0.0.0.0` unless the user explicitly asks.
- Do not remove working reverse SSH login tunnels while cleaning unrelated forward tunnels.
- Do not embed credentials or private keys in service files or docs.
- Use `BatchMode=yes` for non-interactive connectivity checks.
- Do not create tunnel units that can delay boot, shutdown, or reboot while waiting for SSH readiness or graceful disconnect.
