---
name: hermes-link-to-feishu
description: "Connect Hermes Agent to Feishu/Lark via App ID + App Secret (manual setup). Handles credential collection, config writing, and optional gateway start."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [feishu, lark, gateway, messaging, setup]
    related_skills: [hermes-agent]
---

# Hermes Link to Feishu / Lark

Connect Hermes Agent to Feishu/Lark as a bot using the App ID + App Secret approach. This is the manual setup path — no QR code scanning required.

## When to Use

- User says "connect to feishu", "link feishu", "setup lark", "configure feishu bot"
- User already has a Feishu/Lark app created and has `app_id` + `app_secret`
- User prefers manual credential input over scan-to-create

## Prerequisites

- Feishu/Lark app already created at https://open.feishu.cn/ or https://open.larksuite.com/
- App has the necessary permissions (at minimum: bot messaging)
- `app_id` (starts with `cli_`) and `app_secret` known

## Procedure

### 1. Collect Credentials

**Check if credentials are in the prompt:**

Look for patterns like:
- `app_id=cli_xxxx` or `id=cli_xxxx`
- `app_secret=xxxx` or `secret=xxxx`
- `domain=feishu` or `domain=larksuite`
- `mode=websocket` or `mode=webhook`

**If found, extract and use them directly.**

**If not found, ask the user:**

```
Please provide your Feishu/Lark app credentials:
1. App ID (starts with cli_): 
2. App Secret: 
3. Domain — feishu (China) or larksuite (International)? [default: feishu]
4. Connection mode — websocket (recommended) or webhook? [default: websocket]
```

### 2. Write Config to `~/.hermes/config.yaml`

Use `patch` tool to insert the `platforms:` block after `credential_pool_strategies:` and before `toolsets:`.

**Minimal config:**
```yaml
platforms:
  feishu:
    app_id: <app_id>
    app_secret: <app_secret>
    domain: <feishu|larksuite>
    connection_mode: <websocket|webhook>
```

**Example patch context:**
```yaml
providers: {}
fallback_providers: []
credential_pool_strategies: {}
toolsets:
- hermes-cli
```

Replace with:
```yaml
providers: {}
fallback_providers: []
credential_pool_strategies: {}
platforms:
  feishu:
    app_id: cli_xxxxx
    app_secret: xxxxx
    domain: feishu
    connection_mode: websocket
    # Optional but strongly recommended
    # allowed_users: ou_xxx,ou_yyy
    # home_channel: oc_xxx
toolsets:
- hermes-cli
```

### 3. Optional Settings

Ask user if they want to add any of these:

| Setting | Description |
|---------|-------------|
| `allowed_users` | Comma-separated `ou_xxx` IDs. Restrict bot to specific users only. |
| `home_channel` | `oc_xxx` chat ID. Channel where cron job results are sent. |
| `group_sessions_per_user` | `true` (default) = isolate session history per user in group chats. |
| `encrypt_key` | For webhook mode with encrypted payloads. |
| `verification_token` | For webhook mode payload verification. |

### 4. Verify Config

```bash
grep -A 10 "platforms:" ~/.hermes/config.yaml
```

### 5. Start Gateway (Optional)

Ask user if they want to start the gateway now:

```bash
# Option A: Interactive setup wizard
hermes gateway setup

# Option B: Start directly if already configured
hermes gateway start
```

## Connection Modes

**websocket** (recommended):
- Hermes opens outbound connection to Feishu
- No public webhook endpoint needed
- Works behind NAT/firewall

**webhook**:
- Feishu pushes events to your server
- Requires public URL or `FEISHU_WEBHOOK_HOST` / `FEISHU_WEBHOOK_PORT` / `FEISHU_WEBHOOK_PATH`
- Useful for custom routing or multi-tenant setups

## Domain Notes

- **feishu** = https://open.feishu.cn (China version)
- **larksuite** = https://open.larksuite.com (International version)
- App created on one domain cannot be used on the other

## Pitfalls

- Do NOT use `hermes gateway setup` scan-to-create if user already has an app — it creates a new one
- Always use `patch` tool for config edits, not `sed` or `echo`
- If `platforms:` block already exists, update it rather than creating a duplicate
- `app_secret` is sensitive — never log it or include in session summaries
- Webhook mode requires additional env vars if not using default localhost:8765

## Verification Checklist

After setup, confirm:
1. `~/.hermes/config.yaml` contains `platforms.feishu` block
2. `app_id` starts with `cli_`
3. `domain` matches the platform where app was created
4. `hermes gateway start` connects without auth errors
5. Bot responds in DMs and when @mentioned in groups

## References

- https://hermes-agent.nousresearch.com/docs/user-guide/messaging/feishu
- https://open.feishu.cn/document/home/introduction-to-custom-app-development/self-built-application-development-process
