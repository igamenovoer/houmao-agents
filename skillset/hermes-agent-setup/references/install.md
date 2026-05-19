# Core Hermes Install

Install Hermes Agent from the Nous Research repository and configure it for use.

## One-Line Install

Use the official installer when the user wants the default setup:

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

This handles Python, Node.js, dependencies, venv, and the global `hermes` command.

## Source Checkout + uv Install

When working inside a project that manages external tools under `extern/`:

```bash
git clone --depth=1 https://github.com/NousResearch/hermes-agent.git extern/orphan/hermes-agent
uv tool install --editable extern/orphan/hermes-agent
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
| `~/.hermes/config.yaml` | Main config: model, display, terminal, and similar non-secret settings |
| `~/.hermes/.env` | Secrets, API keys, and gateway environment variables |
| `~/.hermes/auth.json` | Provider auth state and credential pool |

## Verify

```bash
hermes --version
hermes config check
```

For Kimi / Moonshot setup after installation, read `provider-kimi.md`.
