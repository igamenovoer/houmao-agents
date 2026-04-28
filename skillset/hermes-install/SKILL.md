---
name: hermes-install
description: Install and configure Hermes Agent (Nous Research) as a global uv tool, including source checkout and basic provider setup. Use when the user asks to install, set up, or configure Hermes Agent.
---

# Hermes Agent Installation

Install Hermes Agent from the Nous Research repository and configure it for use.

## One-line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

This handles Python, Node.js, dependencies, venv, and the global `hermes` command.

## Source Checkout + uv Install (In-repo Workflow)

When working inside a project that manages external tools under `extern/`:

1. Clone with depth=1:
   ```bash
   git clone --depth=1 https://github.com/NousResearch/hermes-agent.git extern/orphan/hermes-agent
   ```

2. Install as an editable uv tool:
   ```bash
   uv tool install --editable extern/orphan/hermes-agent
   ```

3. Verify:
   ```bash
   hermes --version
   ```

Installed executables: `hermes`, `hermes-agent`, `hermes-acp`.

## Initial Configuration

Run the setup wizard:
```bash
hermes setup
```

Or set the model provider interactively:
```bash
hermes model
```

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.hermes/config.yaml` | Main config (model, display, terminal, etc.) |
| `~/.hermes/.env` | Secrets and API keys |
| `~/.hermes/auth.json` | Provider auth state and credential pool |

## Sub-skills

- **kimi-api-setup** — Configure Hermes to use the Kimi / Moonshot coding API.
