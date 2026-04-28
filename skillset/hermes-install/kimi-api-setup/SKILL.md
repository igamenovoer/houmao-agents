---
name: kimi-api-setup
description: Configure Hermes Agent to use the Kimi / Moonshot AI coding API. Use when the user wants to connect Hermes to Kimi, set up a Kimi API key, or troubleshoot Kimi provider configuration.
---

# Kimi API Setup for Hermes Agent

Configure Hermes Agent to use the Kimi / Moonshot AI coding API endpoint.

## Prerequisites

- Hermes Agent installed (`hermes` command available)
- A Kimi API key (starts with `sk-kimi-` for the coding endpoint)

## Configuration Steps

### 1. Set the API key

Write `KIMI_API_KEY` to the Hermes secrets file:

```bash
cat > ~/.hermes/.env << 'EOF'
KIMI_API_KEY=sk-kimi-your-key-here
EOF
```

Hermes reads `~/.hermes/.env` automatically. Do **not** use `ANTHROPIC_API_KEY` for Kimi — that causes Hermes to treat it as an Anthropic provider and route to the wrong endpoint.

### 2. Set provider and model in config.yaml

```bash
cat > ~/.hermes/config.yaml << 'EOF'
model:
  provider: kimi-coding
  default: kimi-k2.6
EOF
```

Supported models include `kimi-k2.6`, `kimi-k2.5`, `kimi-k2-turbo-preview`, etc.

### 3. Ensure auth.json points to the right provider

If Hermes previously auto-detected an `anthropic` credential from a `ANTHROPIC_API_KEY` env var, clean it:

```bash
# Remove the incorrect anthropic entry from credential_pool
# and set active_provider to "kimi-coding"
```

Or simply run:
```bash
hermes model
```
and select **Kimi / Moonshot** interactively.

### 4. Verify

```bash
hermes config check
```

You should see `✓ KIMI_API_KEY` in the output.

Test with a one-off message:
```bash
hermes -z "hello"
```

## How It Works

- Provider ID: `kimi-coding` (alias: `kimi`, `moonshot`, `kimi-for-coding`)
- Endpoint: `https://api.kimi.com/coding/v1` (auto-routed for `sk-kimi-` prefixed keys)
- Env vars checked: `KIMI_API_KEY`, `KIMI_CODING_API_KEY`
- Optional: `KIMI_BASE_URL` to override the endpoint

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Anthropic` key still shown in config | `ANTHROPIC_API_KEY` set in shell env | `unset ANTHROPIC_API_KEY` or remove from `~/.bashrc` |
| Key not detected | Wrong env var name | Use `KIMI_API_KEY`, not `MOONSHOT_API_KEY` |
| Provider not found | Outdated Hermes | Upgrade to v0.8.0+ |
