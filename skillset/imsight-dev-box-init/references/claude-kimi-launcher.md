# Claude-Kimi Launcher Setup

Use this reference when the user wants a local `claude-kimi` launcher that runs Claude Code against the Kimi/Moonshot Anthropic-compatible endpoint.

## Required Input

You need a Kimi API key. Prefer an existing `KIMI_API_KEY` or `ANTHROPIC_API_KEY` only when the user explicitly wants to reuse it for Kimi. If no key is available, ask:

```text
Please provide your Kimi API key for the `claude-kimi` launcher.
```

Do not print the key. Do not include it in final responses. Avoid echoing full commands that contain the key.

## Defaults

- Launcher path: `$HOME/.local/bin/claude-kimi`
- Secret env file: `$HOME/.config/claude-kimi/env`
- Base URL: `https://api.kimi.com/coding/`

These defaults follow Kimi Code's official third-party coding-agent guide for Claude Code. Imsight's local launcher additionally runs Claude Code with `--dangerously-skip-permissions` by default.

## Official Kimi References

- Kimi Code official third-party coding-agent guide: `https://www.kimi.com/code/docs/en/third-party-tools/other-coding-agents.html`
  - Relevant Claude Code settings: `ANTHROPIC_BASE_URL=https://api.kimi.com/coding/` and `ANTHROPIC_API_KEY=<key>`.
  - The page also includes a Node one-liner that marks Claude Code onboarding complete before first launch.
- Kimi API Platform integration guide: `https://platform.kimi.ai/docs/guide/agent-support`
  - Older K2.5-oriented guide showing Claude Code environment variables such as `ANTHROPIC_MODEL`, Claude default model vars, `CLAUDE_CODE_SUBAGENT_MODEL`, and `ENABLE_TOOL_SEARCH=false`.
- Kimi Code provider docs: `https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/providers-and-models.html`
  - Confirms Kimi Code's provider endpoint shape: `https://api.kimi.com/coding/v1` for Kimi-native provider configuration.
- Kimi Code environment variable docs: `https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/environment-variables.html`
  - Use for Kimi CLI's own `KIMI_*` variables. Do not substitute these for Claude Code's `ANTHROPIC_*` variables.

## Create The Launcher

Create the secret env file with restrictive permissions:

```bash
mkdir -p "$HOME/.config/claude-kimi"
chmod 700 "$HOME/.config/claude-kimi"
umask 077
printf 'ANTHROPIC_API_KEY=%s\n' "$KIMI_API_KEY" > "$HOME/.config/claude-kimi/env"
```

Create the launcher:

```bash
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/claude-kimi" <<'SH'
#!/usr/bin/env bash
set -euo pipefail

key_file="$HOME/.config/claude-kimi/env"

if [[ ! -r "$key_file" ]]; then
  echo "claude-kimi: missing $key_file" >&2
  exit 1
fi

set -a
source "$key_file"
set +a

if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "claude-kimi: ANTHROPIC_API_KEY is not set" >&2
  exit 1
fi

if command -v node >/dev/null 2>&1; then
  node --eval "
    const fs = require('fs');
    const os = require('os');
    const path = require('path');
    const filePath = path.join(os.homedir(), '.claude.json');
    if (fs.existsSync(filePath)) {
      const content = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
      fs.writeFileSync(
        filePath,
        JSON.stringify({ ...content, hasCompletedOnboarding: true }, null, 2),
        'utf-8'
      );
    } else {
      fs.writeFileSync(
        filePath,
        JSON.stringify({ hasCompletedOnboarding: true }, null, 2),
        'utf-8'
      );
    }
  "
fi

export ANTHROPIC_BASE_URL='https://api.kimi.com/coding/'

exec claude --dangerously-skip-permissions "$@"
SH
chmod +x "$HOME/.local/bin/claude-kimi"
```

## Verification

Verify the launcher exists and the key file is private:

```bash
command -v claude-kimi
test -x "$HOME/.local/bin/claude-kimi"
test -r "$HOME/.config/claude-kimi/env"
ls -l "$HOME/.config/claude-kimi/env"
```

Inspect launcher env names without exposing the key:

```bash
sed -E 's/(ANTHROPIC_API_KEY=).*/\1<redacted>/' "$HOME/.local/bin/claude-kimi"
sed -E 's/(=).*/=<redacted>/' "$HOME/.config/claude-kimi/env"
```

## Notes

- This launcher stores the Kimi key outside the executable script so the launcher can be inspected safely.
- If `claude` is not on `PATH`, install Claude Code first before testing the launcher.
- If first launch gets stuck in Claude Code onboarding, run the official Kimi guide's Node onboarding-complete script before starting `claude-kimi`.
- The launcher intentionally uses `--dangerously-skip-permissions` as Imsight's default Claude Code posture. Remove that flag only when the user explicitly asks for a permission-prompting launcher.
