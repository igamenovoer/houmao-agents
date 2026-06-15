# Codex CLI Third-Party API Providers

Use this reference for configuring Codex CLI to call third-party OpenAI-compatible APIs through Codex model provider settings.

Codex CLI currently expects the OpenAI Responses wire protocol for custom providers. Do not configure `wire_api = "chat"`; current Codex rejects it. Use provider endpoints that support `/v1/responses`.

Never bake API keys into this skill, generated documentation, git-tracked config, or launcher scripts. Store keys in environment variables, a local untracked secret file, or a shell-specific secret manager chosen by the user.

## Subcommand: codex-cli-3rd-party

Use this top-level subcommand to add or repair a Codex CLI third-party provider configuration.

## Provider: Yunwu

Yunwu has two OpenAI-compatible endpoint roots:

| Region | Endpoint Root | Codex/OpenAI Base URL |
| --- | --- | --- |
| Chinese mainland | `https://api3.wlai.vip` | `https://api3.wlai.vip/v1` |
| International | `https://yunwu.ai` | `https://yunwu.ai/v1` |

Always append `/v1` for Codex/OpenAI-compatible provider config.

Recommended environment variable:

```bash
YUNWU_OPENAI_API_KEY
```

Recommended default model:

```text
gpt-5.2
```

If the user needs a Codex-specific model and it is listed by the chosen Yunwu endpoint, use:

```text
gpt-5.2-codex
```

## Global Config

Edit `~/.codex/config.toml` and preserve unrelated settings.

Chinese mainland endpoint:

```toml
[model_providers.yunwu]
name = "yunwu-api"
base_url = "https://api3.wlai.vip/v1"
env_key = "YUNWU_OPENAI_API_KEY"
wire_api = "responses"
request_max_retries = 4
stream_max_retries = 5
stream_idle_timeout_ms = 300000

[profiles.yunwu]
model_provider = "yunwu"
model = "gpt-5.2"
model_reasoning_effort = "high"
model_reasoning_summary = "auto"
```

International endpoint:

```toml
[model_providers.yunwu]
name = "yunwu-api"
base_url = "https://yunwu.ai/v1"
env_key = "YUNWU_OPENAI_API_KEY"
wire_api = "responses"
request_max_retries = 4
stream_max_retries = 5
stream_idle_timeout_ms = 300000

[profiles.yunwu]
model_provider = "yunwu"
model = "gpt-5.2"
model_reasoning_effort = "high"
model_reasoning_summary = "auto"
```

Use the profile:

```bash
export YUNWU_OPENAI_API_KEY='<set locally, do not commit>'
codex -p yunwu
```

For one-shot testing without editing `config.toml`:

```bash
export YUNWU_OPENAI_API_KEY='<set locally, do not commit>'
codex exec --skip-git-repo-check \
  -c model_provider=yunwu-test \
  -c model_providers.yunwu-test.name=Yunwu \
  -c model_providers.yunwu-test.base_url=https://yunwu.ai/v1 \
  -c model_providers.yunwu-test.env_key=YUNWU_OPENAI_API_KEY \
  -c model_providers.yunwu-test.wire_api=responses \
  -m gpt-5.2 \
  "Reply with exactly: yunwu-ok"
```

## Validation

Verify the key and endpoint can list models:

```bash
curl -sS --fail-with-body \
  -H "Authorization: Bearer $YUNWU_OPENAI_API_KEY" \
  https://yunwu.ai/v1/models
```

For Chinese mainland:

```bash
curl -sS --fail-with-body \
  -H "Authorization: Bearer $YUNWU_OPENAI_API_KEY" \
  https://api3.wlai.vip/v1/models
```

Then run a small Codex request:

```bash
codex exec -p yunwu --skip-git-repo-check "Reply with exactly: yunwu-ok"
```

Expected success: Codex returns `yunwu-ok`.

If Codex reports `429 Too Many Requests`, the provider configuration is reaching Yunwu but the key, quota, model access, or rate limit is blocking completion. If Codex reports `404` for `/responses`, the selected endpoint or model path does not support Codex's required Responses API.

## Notes

- Keep provider IDs stable, such as `yunwu`, so profiles and historical Codex sessions remain understandable.
- Prefer `env_key` over `experimental_bearer_token`; do not store bearer tokens in tracked config.
- Avoid `--ignore-user-config` except for tests. Normal setup should update `~/.codex/config.toml` or add a named profile.
- Current Codex model listing may log errors if a third-party `/models` response shape differs from Codex's expected catalog schema. A small `codex exec` request is the decisive validation.
