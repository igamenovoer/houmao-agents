# Kimi / Moonshot Provider Setup

Configure Hermes Agent to use the Kimi / Moonshot AI coding API endpoint.

## Prerequisites

- Hermes Agent installed and `hermes` available.
- A Kimi API key for the coding endpoint, usually prefixed with `sk-kimi-`.

## Set API Key

Write or append `KIMI_API_KEY` in the Hermes secrets file:

```bash
cat >> ~/.hermes/.env << 'EOF'

KIMI_API_KEY=sk-kimi-your-key-here
EOF
```

Hermes reads `~/.hermes/.env` automatically. Do not use `ANTHROPIC_API_KEY` for Kimi; that can cause Hermes to treat it as an Anthropic provider and route to the wrong endpoint.

## Set Provider and Model

Write the model provider in `~/.hermes/config.yaml`:

```bash
cat > ~/.hermes/config.yaml << 'EOF'
model:
  provider: kimi-coding
  default: kimi-k2.6
EOF
```

Known model examples include `kimi-k2.6`, `kimi-k2.5`, and `kimi-k2-turbo-preview`.

## Fix Incorrect Provider Detection

If Hermes previously auto-detected an `anthropic` credential from an `ANTHROPIC_API_KEY` environment variable, clean that stale state by either:

- removing the incorrect `anthropic` entry from `credential_pool` and setting `active_provider` to `kimi-coding` in `~/.hermes/auth.json`, or
- running `hermes model` and selecting Kimi / Moonshot interactively.

## How It Works

- Provider ID: `kimi-coding`
- Aliases: `kimi`, `moonshot`, `kimi-for-coding`
- Endpoint: `https://api.kimi.com/coding/v1`
- Env vars checked: `KIMI_API_KEY`, `KIMI_CODING_API_KEY`
- Optional override: `KIMI_BASE_URL`

## Verify

```bash
hermes config check
hermes -z "hello"
```

`hermes config check` should report `KIMI_API_KEY`.

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Anthropic key still shown in config | `ANTHROPIC_API_KEY` set in shell env | `unset ANTHROPIC_API_KEY` or remove it from shell startup files |
| Key not detected | Wrong env var name | Use `KIMI_API_KEY`, not `MOONSHOT_API_KEY` |
| Provider not found | Outdated Hermes | Upgrade Hermes to a version with `kimi-coding` support |
