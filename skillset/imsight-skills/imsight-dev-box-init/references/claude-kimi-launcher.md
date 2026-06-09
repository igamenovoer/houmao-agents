# Claude-Kimi Launcher Setup

Use this reference when the user wants a local `claude-kimi` launcher that runs Claude Code against the Kimi Code Anthropic-compatible endpoint.

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
- Model ID: `kimi-for-coding`
- Compact window: `CLAUDE_CODE_AUTO_COMPACT_WINDOW=262144`

These defaults follow Kimi Code's official third-party coding-agent guide for Claude Code. Imsight's local launcher additionally runs Claude Code with `--dangerously-skip-permissions` by default.

## Official Kimi References

- Kimi Code official third-party coding-agent guide: `https://www.kimi.com/code/docs/en/third-party-tools/other-coding-agents.html`
  - Relevant Claude Code settings: `ANTHROPIC_BASE_URL=https://api.kimi.com/coding/`, `ANTHROPIC_API_KEY=<key>`, and `CLAUDE_CODE_AUTO_COMPACT_WINDOW=262144`.
  - The page also includes a Node one-liner that marks Claude Code onboarding complete before first launch.
- Kimi Code overview: `https://www.kimi.com/code/docs/en/`
  - When calling the Kimi Code API from third-party tools, use model ID `kimi-for-coding`.
- Kimi API Platform integration guide: `https://platform.kimi.ai/docs/guide/agent-support`
  - Older K2.5-oriented API-platform guide. Do not use its `ANTHROPIC_AUTH_TOKEN`, `ANTHROPIC_MODEL`, Claude default model vars, `CLAUDE_CODE_SUBAGENT_MODEL`, or `ENABLE_TOOL_SEARCH=false` pattern for the current Kimi Code membership endpoint unless the user explicitly asks for that older lane.
- Kimi Code provider docs: `https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/providers.html`
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
unset ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_OAUTH_TOKEN
export CLAUDE_CODE_AUTO_COMPACT_WINDOW="${CLAUDE_CODE_AUTO_COMPACT_WINDOW:-262144}"
KIMI_MODEL="${CLAUDE_KIMI_MODEL:-kimi-for-coding}"

claude_bin="${CLAUDE_BIN:-}"
if [[ -z "$claude_bin" ]]; then
  for candidate in "$HOME"/.nvm/versions/node/*/bin/claude "$HOME"/.bun/bin/claude "$HOME"/.local/bin/claude; do
    if [[ -x "$candidate" ]]; then
      claude_bin="$candidate"
      break
    fi
  done
fi
if [[ -z "$claude_bin" ]]; then
  claude_bin="$(command -v claude || true)"
fi
if [[ -z "$claude_bin" ]]; then
  echo "claude-kimi: claude binary not found" >&2
  exit 127
fi

add_model=1
for arg in "$@"; do
  case "$arg" in
    --model|--model=*|--help|-h|--version|-v)
      add_model=0
      ;;
  esac
done

if [[ "$add_model" -eq 1 ]]; then
  exec "$claude_bin" --dangerously-skip-permissions --model "$KIMI_MODEL" "$@"
fi
exec "$claude_bin" --dangerously-skip-permissions "$@"
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
- Prefer `ANTHROPIC_API_KEY` for Kimi Code. Clear `ANTHROPIC_AUTH_TOKEN` and `CLAUDE_CODE_OAUTH_TOKEN` so Claude Code does not choose an older auth lane.
- The default model is `kimi-for-coding`. Override it only when needed with `CLAUDE_KIMI_MODEL=<model> claude-kimi ...` or pass an explicit Claude Code `--model`.
- If `claude` is not on `PATH`, install Claude Code first before testing the launcher.
- If first launch gets stuck in Claude Code onboarding, run the official Kimi guide's Node onboarding-complete script before starting `claude-kimi`.
- The launcher intentionally uses `--dangerously-skip-permissions` as Imsight's default Claude Code posture. Remove that flag only when the user explicitly asks for a permission-prompting launcher.
