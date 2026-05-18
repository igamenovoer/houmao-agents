# Tavily CLI and Skills Setup

Use this reference to install Tavily CLI (`tvly`), authenticate it, and install Tavily skills into the requested agent skill home. This is intentionally not specific to Hermes.

## Prerequisites

- `uv` for the preferred CLI installation path.
- `curl` for the fallback installer.
- `git` for cloning Tavily skills.
- A Tavily API key, usually starting with `tvly-`.
- Network access to Tavily and GitHub.

## Check Existing Install

```bash
command -v tvly && tvly --status
```

If `tvly` exists and `tvly --status` shows an authenticated account, skip to skill installation.

## Install Tavily CLI

Prefer installing the CLI as a uv tool:

```bash
uv tool install tavily-cli
```

If `uv` is not available, use the official installer:

```bash
curl -fsSL https://cli.tavily.com/install.sh | bash
```

Do not use `pip install tavily-cli` unless the user explicitly requests pip. The Imsight-preferred path is `uv tool install tavily-cli`.

## Authenticate

Use an API key provided by the user, the prompt, or the environment.

Check the environment first:

```bash
[ -n "${TAVILY_API_KEY:-}" ] && echo "TAVILY_API_KEY is set"
```

If no key is available, ask the user for a Tavily API key:

```text
Please provide your Tavily API key.
```

Authenticate:

```bash
tvly login --api-key "$TAVILY_API_KEY"
```

Verify:

```bash
tvly --status
```

## Install Tavily Skills

Install Tavily skills into the target agent's skill home. Choose the destination from the user's requested agent/tool:

| Target | Suggested destination |
| --- | --- |
| Codex | `${CODEX_HOME:-$HOME/.codex}/skills/research/tavily-skills` |
| Hermes | `$HOME/.hermes/skills/research/tavily-skills` |
| Other agent | The agent's native skills directory, preferably under `research/tavily-skills` |

For Codex by default:

```bash
DEST="${CODEX_HOME:-$HOME/.codex}/skills/research/tavily-skills"
mkdir -p "$(dirname "$DEST")"
git clone https://github.com/tavily-ai/skills.git "$DEST"
```

If the destination already exists, update it instead of cloning over it:

```bash
DEST="${CODEX_HOME:-$HOME/.codex}/skills/research/tavily-skills"
git -C "$DEST" pull --ff-only
```

Verify the skills are present:

```bash
ls "$DEST/skills"
```

Expected skill directories include:

- `tavily-cli`
- `tavily-search`
- `tavily-extract`
- `tavily-crawl`
- `tavily-map`
- `tavily-research`
- `tavily-dynamic-search`
- `tavily-best-practices`

## Test

Run a small search:

```bash
tvly search "tavily cli test" --json | head -20
```

## API Key Handling

- Extract keys from the prompt when the user provides `key=tvly-...`, `api-key=tvly-...`, or similar.
- Prefer `TAVILY_API_KEY` when it is already set.
- Ask the user when no key is available.
- `tvly login` stores auth under Tavily's local config, typically `~/.tavily/config.json`.
- Do not print API keys in final responses or logs.

## Verification

Confirm:

1. `tvly --help` works.
2. `tvly --status` shows authenticated status.
3. `tvly search "test" --json` returns results.
4. Tavily skill directories exist under the selected agent skill home.

## Pitfalls

- `tvly login` requires the key immediately; do not defer authentication if the user asked for a complete setup.
- If the skills directory already exists, use `git -C "$DEST" pull --ff-only` or inspect before replacing it.
- Keep the skill destination agent-specific; do not assume Hermes unless the user asks for Hermes.
- Prefer the Imsight `uv` installation path unless the user explicitly requests another method.

## Source References

- Tavily skills repository: `https://github.com/tavily-ai/skills`
- Tavily CLI docs: `https://docs.tavily.com/documentation/tavily-cli`
- Tavily site: `https://tavily.com`
