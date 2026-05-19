# Tavily CLI and Skills for Hermes

Install the Tavily CLI (`tvly`) and the Tavily skills for web search, extraction, crawling, mapping, and research within Hermes Agent.

## When To Use

- User says "install Tavily", "setup Tavily", "get Tavily skills", or "install tvly".
- Tavily CLI is missing or unauthenticated.
- User wants web search capabilities through Tavily.

## Prerequisites

- `curl` for installer fallback.
- `git` for cloning skills.
- Internet connection.
- Tavily API key for authentication.

## Check Existing Install

```bash
command -v tvly && tvly --status
```

If both succeed and show authenticated status, skip to skills installation.

## Install Tavily CLI

Prefer `uv`:

```bash
uv tool install tavily-cli
```

If `uv` is not available, use the official install script:

```bash
curl -fsSL https://cli.tavily.com/install.sh | bash
```

Do not use `pip` for `tavily-cli` unless there is no practical alternative.

## Authenticate

Check the prompt for `key=tvly-...` or `api-key=tvly-...`. If no key was provided, check `TAVILY_API_KEY`. If still unavailable, ask the user for the Tavily API key.

Authenticate:

```bash
tvly login --api-key <API_KEY>
tvly --status
```

`tvly login` stores auth in `~/.tavily/config.json`.

## Install Tavily Skills

Clone the official Tavily skills repository into Hermes:

```bash
mkdir -p ~/.hermes/skills/research
cd ~/.hermes/skills/research
git clone https://github.com/tavily-ai/skills.git tavily-skills
```

If the directory already exists, update it or remove and re-clone according to user preference.

Verify:

```bash
ls ~/.hermes/skills/research/tavily-skills/skills/
```

Expected skills:

- `tavily-cli`
- `tavily-search`
- `tavily-extract`
- `tavily-crawl`
- `tavily-map`
- `tavily-research`
- `tavily-dynamic-search`
- `tavily-best-practices`

## Test

```bash
tvly search "tavily cli test" --json | head -20
```

## API Key Handling

- From prompt: extract `key=tvly-...` or `api-key=tvly-...`.
- From environment: check `TAVILY_API_KEY`.
- Interactive: ask the user if no key is available.
- Format: Tavily keys usually start with `tvly-`.

## Verification

Confirm:

1. `tvly --help` works.
2. `tvly --status` shows authenticated.
3. `tvly search "test" --json` returns results.
4. Skills exist in `~/.hermes/skills/research/tavily-skills/skills/`.

## Pitfalls

- Prefer `uv tool install tavily-cli` over `pip install tavily-cli`.
- Use the install script only when `uv` is unavailable.
- Validate `tvly-` API key format when the user provides a key.
- `git clone` fails if `tavily-skills` already exists; update or remove the existing directory before retrying.
- `tvly login` requires a key immediately; do not defer authentication when the user asked for a complete install.
