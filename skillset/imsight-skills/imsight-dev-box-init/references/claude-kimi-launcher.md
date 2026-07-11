# Claude-Kimi Launcher Setup

Use this reference when the user wants a local `claude-kimi` launcher that runs Claude Code against the Kimi Code Anthropic-compatible endpoint.

## Workflow

1. Resolve API-key handling under **Required Input** without printing or hard-coding the key.
2. Apply the platform-specific paths and values in **Defaults**.
3. Create the launcher and preserve **Runtime Argument Contract**.
4. Run every applicable check in **Verification**.

If the task does not map cleanly to these steps, plan only from this page's inputs, defaults, launcher contract, and verification rules; keep credentials out of commands and responses.

## Required Input

You can provide a Kimi API key during setup, or let the generated launcher prompt for it on first run. Prefer an existing `KIMI_API_KEY` or `ANTHROPIC_API_KEY` only when the user explicitly wants to seed the shared Kimi key file during setup. If no key is available, still create the launcher; the launcher will prompt interactively on first use.

```text
Please provide your Kimi API key for the shared Kimi launcher key file, or confirm that the launcher should prompt on first run.
```

Do not print the key. Do not include it in final responses. Avoid echoing full commands that contain the key.

The generated launcher must not hard-code the API key and must not rely on shell-specific automatic env loading. It reads the shared key file directly at runtime, assigns `ANTHROPIC_API_KEY` for the launched Claude process only, and prompts/writes the key file if the file is missing.

## Defaults

- Unix launcher path: `$HOME/.local/bin/claude-kimi`
- Unix shared key file: `$HOME/.local/bin/kimi-api-key`
- Windows launcher path: `%LOCALAPPDATA%\Programs\kimi-launchers\claude-kimi.ps1`
- Windows command shim path: `%LOCALAPPDATA%\Programs\kimi-launchers\claude-kimi.cmd`
- Windows shared key file: `%LOCALAPPDATA%\Programs\kimi-launchers\kimi-api-key`
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

Use the bundled scripts from this skill. Resolve `<skill-dir>` to the `imsight-dev-box-init` skill directory that contains this reference.

## Runtime Argument Contract

`claude-kimi` runtime arguments are Claude Code arguments by default. The launcher may observe arguments only to avoid injecting duplicate defaults, such as not adding its default `--model` when the user already passed `--model`. It must not consume, rename, reorder, or reinterpret underlying Claude CLI arguments.

If a future launcher needs its own runtime flags, use launcher-prefixed names such as `--claude-kimi-key-file` or `--claude-kimi-no-default-model`, and strip only those prefixed launcher flags before calling `claude`.

### Unix Or Linux Shell

Create the launcher and, when available, seed the shared key file:

```bash
<skill-dir>/scripts/create-claude-kimi-launcher.sh --api-key "$KIMI_API_KEY"
```

If no key is available during setup, omit `--api-key`; the generated launcher will prompt for the key the first time it runs:

```bash
<skill-dir>/scripts/create-claude-kimi-launcher.sh
```

The script also accepts `--output`, `--key-file`, `--base-url`, `--model`, and `--claude-bin` when the user wants non-default values.

### Windows PowerShell

The PowerShell script creates a `.ps1` launcher and adjacent `.cmd` shim in a common `kimi-launchers` directory. The `.cmd` shim lets users run `claude-kimi` from `cmd.exe`, PowerShell, or other launchers when the directory is on `PATH`.

```powershell
& <skill-dir>\scripts\create-claude-kimi-launcher.ps1 -ApiKey $env:KIMI_API_KEY
```

If no key is available during setup, omit `-ApiKey`; the generated launcher will prompt for the key the first time it runs:

```powershell
& <skill-dir>\scripts\create-claude-kimi-launcher.ps1
```

## Verification

Verify the Unix launcher exists:

```bash
command -v claude-kimi
test -x "$HOME/.local/bin/claude-kimi"
ls -l "$HOME/.local/bin/claude-kimi"
test -f "$HOME/.local/bin/kimi-api-key" || echo "key file will be created on first run"
```

Verify the Windows launcher exists:

```powershell
Test-Path "$env:LOCALAPPDATA\Programs\kimi-launchers\claude-kimi.ps1"
Test-Path "$env:LOCALAPPDATA\Programs\kimi-launchers\claude-kimi.cmd"
Test-Path "$env:LOCALAPPDATA\Programs\kimi-launchers\kimi-api-key"
```

Inspect generated launchers and key files only with redaction:

```bash
rg -n 'kimi-api-key|ANTHROPIC_BASE_URL|CLAUDE_CODE_AUTO_COMPACT_WINDOW' "$HOME/.local/bin/claude-kimi"
test -f "$HOME/.local/bin/kimi-api-key" && sed 's/.*/<redacted>/' "$HOME/.local/bin/kimi-api-key"
```

```powershell
Select-String -Path "$env:LOCALAPPDATA\Programs\kimi-launchers\claude-kimi.ps1" -Pattern 'kimi-api-key|ANTHROPIC_BASE_URL|CLAUDE_CODE_AUTO_COMPACT_WINDOW'
if (Test-Path "$env:LOCALAPPDATA\Programs\kimi-launchers\kimi-api-key") { '<redacted>' }
```

## Notes

- Store the Kimi key in the shared `kimi-api-key` file next to the launcher, not in the launcher script itself.
- The shared key file is intentionally named generically so future launchers such as `codex-kimi` and `opencode-kimi` can live in the same directory and read the same file directly.
- Keep launcher generator scripts in `<skill-dir>/scripts/`; do not place generated helper scripts in `references/`.
- Prefer `ANTHROPIC_API_KEY` for Kimi Code. Clear `ANTHROPIC_AUTH_TOKEN` and `CLAUDE_CODE_OAUTH_TOKEN` so Claude Code does not choose an older auth lane.
- The default model is `kimi-for-coding`. Override it only when needed with `CLAUDE_KIMI_MODEL=<model> claude-kimi ...` or pass an explicit Claude Code `--model`.
- If `claude` is not on `PATH`, install Claude Code first before testing the launcher.
- If first launch gets stuck in Claude Code onboarding, run the official Kimi guide's Node onboarding-complete script before starting `claude-kimi`.
- The launcher intentionally uses `--dangerously-skip-permissions` as Imsight's default Claude Code posture. Remove that flag only when the user explicitly asks for a permission-prompting launcher.
