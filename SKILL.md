---
name: hermes-install-tavily-cli
description: Install Tavily CLI (tvly) and all tavily skills for Hermes Agent. Handles CLI installation, authentication, and skill setup. Prompts for API key if not provided.
license: MIT
---

# Hermes Install Tavily CLI

Install the Tavily CLI (`tvly`) and all associated skills for web search, extraction, crawling, mapping, and research within Hermes Agent.

## When to Use

- User says "install tavily", "setup tavily", "get tavily skills", "install tvly"
- Tavily CLI is missing or not authenticated
- Need to set up web search capabilities via Tavily

## Prerequisites

- `curl` for the installer
- `git` for cloning skills
- Internet connection

## Procedure

### 1. Check if already installed

```bash
command -v tvly && tvly --status
```

If both succeed and show authenticated status, skip to step 4 (skills installation).

### 2. Install Tavily CLI

Preferred method using `uv`:

```bash
uv tool install tavily-cli
```

If `uv` is not available, fall back to the official install script:
```bash
curl -fsSL https://cli.tavily.com/install.sh | bash
```

Do NOT use `pip` to install tavily-cli. The `uv` tool installation is the recommended approach.

### 3. Authenticate

**Get API key from user:**

If the user provided an API key in the prompt (e.g., "install tavily key=tvly-xxx"), extract it and use it directly.

If no key was provided, ask the user:
```
Please provide your Tavily API key (get one at https://tavily.com):
```

**Authenticate:**
```bash
tvly login --api-key <API_KEY>
```

Verify:
```bash
tvly --status
```

### 4. Install Skills

Clone the official tavily skills repository:

```bash
cd ~/.hermes/skills/research
git clone https://github.com/tavily-ai/skills.git tavily-skills
```

Verify skills are available:
```bash
ls ~/.hermes/skills/research/tavily-skills/skills/
```

Expected skills:
- tavily-cli
- tavily-search
- tavily-extract
- tavily-crawl
- tavily-map
- tavily-research
- tavily-dynamic-search
- tavily-best-practices

### 5. Test

Run a quick search to verify everything works:
```bash
tvly search "tavily cli test" --json | head -20
```

## API Key Handling

- **From prompt**: Extract if user includes `key=tvly-...` or `api-key=tvly-...`
- **From environment**: Check `TAVILY_API_KEY` env var
- **Interactive**: Prompt user if not provided
- **Storage**: `tvly login` saves to `~/.tavily/config.json`

## Verification

After installation, confirm:
1. `tvly --help` works
2. `tvly --status` shows authenticated
3. `tvly search "test" --json` returns results
4. Skills exist in `~/.hermes/skills/research/tavily-skills/skills/`

## Pitfalls

- Always prefer `uv tool install tavily-cli` over `pip install tavily-cli`
- The install script is a fallback when `uv` is not available
- API keys starting with `tvly-` are required; validate format if provided by user
- If skills directory already exists, git clone will fail; remove or update existing
- `tvly login` requires the key immediately; cannot defer authentication

## See Also

- https://github.com/tavily-ai/skills
- https://docs.tavily.com/documentation/tavily-cli
- https://tavily.com
