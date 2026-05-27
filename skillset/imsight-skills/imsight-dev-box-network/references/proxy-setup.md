# Proxy Setup

Use this reference as the subskill page for Imsight proxy setup tasks.

## Second-Level Subcommands

Use these subcommands under `proxy-setup`, for example: `$imsight-dev-box-network use proxy-setup proxy-scan to scan ports 7890-7897`.

| Subcommand | Use For | Load |
| --- | --- | --- |
| `via-ssh` | Use an SSH host as a middle host for proxy access, including SOCKS5 dynamic forwarding and local forwarding of remote proxy ports | `references/proxy-via-ssh.md` |
| `install-proxy-scripts` | Install proxy environment scripts and populate grouped proxy candidates from local, remote, or tunneled proxy ports | `references/install-proxy-scripts.md` |
| `proxy-scan` | Discover candidate proxy ports, then optionally update the managed shell startup proxy candidate block | `references/install-proxy-scripts.md` and `scripts/scan-proxy-candidates.py` |

## Procedure

1. If the request names a second-level subcommand, load the matching reference from the table.
2. If the request is task-only, choose the applicable second-level subcommand from the task.
3. For `proxy-scan`, ask for the port or port range when the user has not provided one, run `scripts/scan-proxy-candidates.py` on the target host, then update the managed shell startup proxy candidate block when the user wants persisted proxy discovery.
4. For `via-ssh`, distinguish SSH dynamic SOCKS5 forwarding from forwarding an existing proxy service before choosing commands or service units.
5. For `install-proxy-scripts`, copy the bundled scripts and configure candidate groups as described in `references/install-proxy-scripts.md`.
