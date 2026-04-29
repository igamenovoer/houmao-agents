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

### 2. Write Config to `~/.hermes/.env`

**CRITICAL**: Feishu/Lark credentials go in `~/.hermes/.env` as environment variables, NOT in `~/.hermes/config.yaml`. The gateway reads them from env vars at startup.

Append to `~/.hermes/.env`:
```bash
cat >> ~/.hermes/.env << 'EOF'

# Feishu / Lark Configuration
FEISHU_APP_ID=cli_xxxxx
FEISHU_APP_SECRET=xxxxx
FEISHU_DOMAIN=feishu
FEISHU_CONNECTION_MODE=websocket
EOF
```

**Required env vars:**
| Variable | Description |
|----------|-------------|
| `FEISHU_APP_ID` | App ID from Feishu developer console (starts with `cli_`) |
| `FEISHU_APP_SECRET` | App Secret from Feishu developer console |
| `FEISHU_DOMAIN` | `feishu` (China) or `lark` (International). Default: `feishu` |
| `FEISHU_CONNECTION_MODE` | `websocket` (recommended) or `webhook`. Default: `websocket` |

**Optional env vars:**
| Variable | Description |
|----------|-------------|
| `FEISHU_ALLOWED_USERS` | Comma-separated `ou_xxx` IDs. Restrict bot to specific users. |
| `FEISHU_HOME_CHANNEL` | `oc_xxx` chat ID for cron delivery and notifications. |
| `FEISHU_ENCRYPT_KEY` | Encryption key for webhook mode. |
| `FEISHU_VERIFICATION_TOKEN` | Verification token for webhook mode. |
| `FEISHU_WEBHOOK_HOST` | Webhook bind host (default: 127.0.0.1). |
| `FEISHU_WEBHOOK_PORT` | Webhook bind port (default: 8765). |
| `FEISHU_WEBHOOK_PATH` | Webhook URL path (default: /feishu/webhook). |
| `GATEWAY_ALLOW_ALL_USERS` | Set `true` to allow all users without allowlist. |

### 3. Allow All Users (Optional but Recommended)

By default, the gateway denies all unauthorized users. To allow anyone to message the bot:

```bash
echo "GATEWAY_ALLOW_ALL_USERS=true" >> ~/.hermes/.env
```

Or set specific allowed users:
```bash
echo "FEISHU_ALLOWED_USERS=ou_xxx,ou_yyy" >> ~/.hermes/.env
```

### 4. Verify Config

```bash
grep "FEISHU\|GATEWAY_ALLOW" ~/.hermes/.env
```

### 5. Start Gateway

**CRITICAL**: Do NOT use `hermes gateway restart` — it sends a reload signal that conflicts with systemd auto-restart and causes exit code 75 (TEMPFAIL). Use this sequence instead:

```bash
# Correct sequence
hermes gateway stop
sleep 3
hermes gateway start

# Verify after a few seconds
sleep 3
hermes gateway status
```

**Expected log output (success):**
```
[Lark] [INFO] connected to wss://msg-frontier.feishu.cn/ws/v2?...
```

**If you see "No messaging platforms enabled"** — the gateway did not pick up the env vars. Check that they are in `~/.hermes/.env` (not `config.yaml`) and that the file is properly formatted (no extra quotes, no spaces around `=`).

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

- **Config location**: Credentials go in `~/.hermes/.env` as env vars, NOT in `~/.hermes/config.yaml` under a `platforms:` block. The gateway does NOT read `config.yaml` for Feishu settings.
- **Restart bug**: Do NOT use `hermes gateway restart` — it causes exit code 75 (TEMPFAIL) due to reload signal conflicting with systemd auto-restart. Always use `stop` → `start`.
- Do NOT use `hermes gateway setup` scan-to-create if user already has an app — it creates a new one
- `app_secret` is sensitive — never log it or include in session summaries
- Webhook mode requires additional env vars if not using default localhost:8765

## Verification Checklist

After setup, confirm:
1. `~/.hermes/.env` contains `FEISHU_APP_ID` and `FEISHU_APP_SECRET`
2. `FEISHU_APP_ID` starts with `cli_`
3. `FEISHU_DOMAIN` matches the platform where app was created
4. `hermes gateway stop && sleep 3 && hermes gateway start` connects without auth errors
5. Gateway logs show: `[Lark] [INFO] connected to wss://msg-frontier.feishu.cn/ws/v2?...`
6. Bot responds in DMs and when @mentioned in groups

## References

- `references/feishu-env-vars.md` — Official env var list from Hermes docs
- https://hermes-agent.nousresearch.com/docs/user-guide/messaging/feishu
- https://open.feishu.cn/document/home/introduction-to-custom-app-development/self-built-application-development-process
