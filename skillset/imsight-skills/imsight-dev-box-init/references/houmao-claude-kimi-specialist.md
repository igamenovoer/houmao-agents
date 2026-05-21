# Houmao Claude-Kimi Specialist Setup

Use this reference when the user wants a Houmao specialist that launches Claude Code with Kimi/Moonshot credentials.

## Required Input

You need a Kimi API key. Prefer reading it from the existing `claude-kimi` key file when present:

```bash
test -r "$HOME/.config/claude-kimi/env"
```

If there is no readable key file and no explicit key in the environment, ask:

```text
Please provide your Kimi API key for the Houmao Claude+Kimi specialist.
```

Do not print the key. Do not include it in final responses. Avoid echoing full commands that contain the key.

## Optional Proxy Env Prompt

If the user did not already say whether to include proxy settings, ask before creating the specialist:

```text
Do you want this Houmao specialist to inherit the current shell's proxy-related environment variables?
```

Explain that this copies only currently set proxy env records such as `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY`, `NO_PROXY`, and lowercase variants into the specialist's durable launch env. If the user says no, omit proxy env records.

## Defaults

- Specialist name: use the user's requested name, otherwise ask. A common default is `generic-kimi`.
- Tool lane: `claude`
- Credential name: `<specialist-name>-creds`
- Base URL: `https://api.kimi.com/coding/`
- Model: `kimi-k2.6`
- System prompt: omit unless the user requests one.

These defaults align the Houmao specialist with the official Kimi Code Claude Code setup while keeping the Kimi key in Houmao's Claude credential bundle.

## Official Kimi References

- Kimi Code official third-party coding-agent guide: `https://www.kimi.com/code/docs/en/third-party-tools/other-coding-agents.html`
  - Relevant Claude Code settings: `ANTHROPIC_BASE_URL=https://api.kimi.com/coding/` and `ANTHROPIC_API_KEY=<key>`.
  - The guide says `/status` should show the Kimi base URL after launch; model names may still appear Claude-like even though calls go to Kimi.
- Kimi API Platform integration guide: `https://platform.kimi.ai/docs/guide/agent-support`
  - Older K2.5-oriented Claude Code guide showing model override variables: `ANTHROPIC_MODEL`, `ANTHROPIC_DEFAULT_OPUS_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`, `CLAUDE_CODE_SUBAGENT_MODEL`, and `ENABLE_TOOL_SEARCH=false`.
- Kimi Code provider docs: `https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/providers-and-models.html`
  - Confirms the Kimi-native provider endpoint `https://api.kimi.com/coding/v1`; for Claude Code, use the Anthropic-compatible endpoint from the third-party coding-agent guide instead.

## Preconditions

Verify `houmao-mgr` and a Houmao project overlay:

```bash
command -v houmao-mgr
houmao-mgr project status
```

If no project overlay exists and the user wants to create the specialist in the current directory, initialize one:

```bash
houmao-mgr project init
```

## Configure Claude Global Onboarding State

Before creating or launching the specialist, configure Claude Code's global settings for the same Unix user that will run `houmao-mgr`. This mirrors the `claude-kimi` launcher and prevents Houmao-launched Claude Code sessions from stopping at Anthropic's default onboarding/login flow.

Prefer Node when available:

```bash
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
```

If Node is unavailable, update `~/.claude.json` with another JSON-aware tool. Preserve existing keys and set only:

```json
{
  "hasCompletedOnboarding": true
}
```

## Create The Specialist

Load the key from the `claude-kimi` env file when available:

```bash
set -a
. "$HOME/.config/claude-kimi/env"
set +a
```

Then create the specialist. Start with the fixed Kimi launcher flags:

```bash
houmao-mgr project easy specialist create \
  --name "$SPECIALIST_NAME" \
  --tool claude \
  --credential "$SPECIALIST_NAME-creds" \
  --api-key "$ANTHROPIC_API_KEY" \
  --base-url 'https://api.kimi.com/coding/' \
  --model 'kimi-k2.6' \
  --env-set ENABLE_TOOL_SEARCH=false \
  --env-set CLAUDE_CODE_SKIP_BEDROCK_AUTH=1 \
  --env-set CLAUDE_CODE_SKIP_VERTEX_AUTH=1 \
  --env-set DISABLE_TELEMETRY=1 \
  --env-set DISABLE_ERROR_REPORTING=1
```

If the user opted into proxy envs, append every currently set proxy variable to the create command. Build the argument list so unset variables are skipped:

```bash
args=(
  houmao-mgr project easy specialist create
  --name "$SPECIALIST_NAME"
  --tool claude
  --credential "$SPECIALIST_NAME-creds"
  --api-key "$ANTHROPIC_API_KEY"
  --base-url 'https://api.kimi.com/coding/'
  --model 'kimi-k2.6'
  --env-set ENABLE_TOOL_SEARCH=false
  --env-set CLAUDE_CODE_SKIP_BEDROCK_AUTH=1
  --env-set CLAUDE_CODE_SKIP_VERTEX_AUTH=1
  --env-set DISABLE_TELEMETRY=1
  --env-set DISABLE_ERROR_REPORTING=1
)
for key in HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY http_proxy https_proxy all_proxy no_proxy; do
  if [ -n "${!key+x}" ]; then
    args+=(--env-set "$key=${!key}")
  fi
done
"${args[@]}"
```

When replacing an existing specialist intentionally, add `--yes` to the create command only after confirming overwrite with the user.

## Verification

Check the specialist and Claude credential registration:

```bash
houmao-mgr project easy specialist get --name "$SPECIALIST_NAME"
houmao-mgr project credentials claude list
```

Check materialized non-secret launcher settings without revealing the key:

```bash
rg -n 'kimi-k2\.6|ENABLE_TOOL_SEARCH|CLAUDE_CODE_SKIP|DISABLE_TELEMETRY|DISABLE_ERROR_REPORTING|ANTHROPIC_BASE_URL' .houmao
rg -n 'ANTHROPIC_API_KEY' .houmao | sed -E 's/(ANTHROPIC_API_KEY[=:] ?).*/\1<redacted>/'
```

Verify Claude's global onboarding state without exposing unrelated settings:

```bash
node --eval "
  const fs = require('fs');
  const os = require('os');
  const path = require('path');
  const filePath = path.join(os.homedir(), '.claude.json');
  const content = fs.existsSync(filePath)
    ? JSON.parse(fs.readFileSync(filePath, 'utf-8'))
    : {};
  console.log('hasCompletedOnboarding=' + String(content.hasCompletedOnboarding === true));
"
```

## Notes

- Store `ANTHROPIC_API_KEY` and `ANTHROPIC_BASE_URL` in the Houmao credential bundle, not as specialist `--env-set` records.
- Store launcher behavior flags as specialist env records so launched agents inherit the same Kimi-oriented Claude Code posture.
- Claude's global `hasCompletedOnboarding` setting is host-user state, not Houmao specialist metadata. Configure it before launch for the same account that starts Houmao agents.
- Use the same model value as the `claude-kimi` launcher unless the user explicitly asks for a different Kimi model.
- Prefer the official Kimi Code `api.kimi.com/coding/` Anthropic-compatible endpoint for Claude Code. Use the older `platform.kimi.ai` Moonshot endpoint pattern only when the user explicitly asks for that API-platform lane.
- Proxy envs are optional because `--env-set` makes them durable specialist launch defaults. Ask when the user's preference is unknown.
