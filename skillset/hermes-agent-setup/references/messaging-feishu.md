# Feishu / Lark Messaging Setup

Connect Hermes Agent to Feishu/Lark as a bot using the App ID + App Secret path. This is the manual setup path; no QR code scanning is required.

## When To Use

- User says "connect to Feishu", "link Feishu", "set up Lark", or "configure Feishu bot".
- User already has a Feishu/Lark app and has `app_id` plus `app_secret`.
- User prefers manual credential input over scan-to-create.

## Prerequisites

- Feishu/Lark app already created at `https://open.feishu.cn/` or `https://open.larksuite.com/`.
- App has bot messaging permissions.
- App ID starts with `cli_`.
- App secret is available.

## Collect Credentials

Check the prompt for:

- `app_id=cli_xxxx` or `id=cli_xxxx`
- `app_secret=xxxx` or `secret=xxxx`
- `domain=feishu`, `domain=lark`, or `domain=larksuite`
- `mode=websocket` or `mode=webhook`

If values are missing, ask the user for:

```text
Please provide your Feishu/Lark app credentials:
1. App ID (starts with cli_):
2. App Secret:
3. Domain: feishu or larksuite? [default: feishu]
4. Connection mode: websocket or webhook? [default: websocket]
```

## Write Config to `~/.hermes/.env`

Feishu/Lark credentials go in `~/.hermes/.env` as environment variables. Do not put them in `~/.hermes/config.yaml`; the gateway reads them from env vars at startup.

```bash
cat >> ~/.hermes/.env << 'EOF'

# Feishu / Lark Configuration
FEISHU_APP_ID=cli_xxxxx
FEISHU_APP_SECRET=xxxxx
FEISHU_DOMAIN=feishu
FEISHU_CONNECTION_MODE=websocket
EOF
```

Required env vars:

| Variable | Description |
|----------|-------------|
| `FEISHU_APP_ID` | App ID from Feishu developer console, starting with `cli_` |
| `FEISHU_APP_SECRET` | App secret from Feishu developer console |
| `FEISHU_DOMAIN` | `feishu` for China or `lark`/`larksuite` for international; default `feishu` |
| `FEISHU_CONNECTION_MODE` | `websocket` or `webhook`; default `websocket` |

Optional env vars:

| Variable | Description |
|----------|-------------|
| `FEISHU_ALLOWED_USERS` | Comma-separated `ou_xxx` IDs; restrict bot to specific users |
| `FEISHU_HOME_CHANNEL` | `oc_xxx` chat ID for cron delivery and notifications |
| `FEISHU_ENCRYPT_KEY` | Encryption key for webhook mode |
| `FEISHU_VERIFICATION_TOKEN` | Verification token for webhook mode |
| `FEISHU_WEBHOOK_HOST` | Webhook bind host, default `127.0.0.1` |
| `FEISHU_WEBHOOK_PORT` | Webhook bind port, default `8765` |
| `FEISHU_WEBHOOK_PATH` | Webhook URL path, default `/feishu/webhook` |
| `GATEWAY_ALLOW_ALL_USERS` | Set `true` to allow all users without allowlist |

## Allow Users

By default, the gateway may deny unauthorized users. To allow anyone to message the bot:

```bash
echo "GATEWAY_ALLOW_ALL_USERS=true" >> ~/.hermes/.env
```

Or restrict to specific users:

```bash
echo "FEISHU_ALLOWED_USERS=ou_xxx,ou_yyy" >> ~/.hermes/.env
```

## Verify Config

```bash
grep "FEISHU\|GATEWAY_ALLOW" ~/.hermes/.env
```

Do not paste app secrets into summaries.

## Start Gateway

Do not use `hermes gateway restart`; it sends a reload signal that can conflict with systemd auto-restart and cause exit code 75. Use stop and start:

```bash
hermes gateway stop
sleep 3
hermes gateway start
sleep 3
hermes gateway status
```

Expected successful logs include a Lark websocket connection such as:

```text
[Lark] [INFO] connected to wss://msg-frontier.feishu.cn/ws/v2?...
```

If logs show "No messaging platforms enabled", the gateway did not pick up the env vars. Check that they are in `~/.hermes/.env`, not `config.yaml`, and that the file has no extra quotes or spaces around `=`.

## Connection Modes

`websocket` is recommended. Hermes opens an outbound connection to Feishu/Lark, no public webhook endpoint is needed, and it works behind NAT/firewall.

`webhook` requires Feishu/Lark to push events to a server. It needs a public URL or `FEISHU_WEBHOOK_HOST`, `FEISHU_WEBHOOK_PORT`, and `FEISHU_WEBHOOK_PATH`.

## Domain Notes

- `feishu` means `https://open.feishu.cn`.
- `larksuite` or `lark` means `https://open.larksuite.com`.
- Apps created on one domain cannot be used on the other.

## Pitfalls

- Credentials go in `~/.hermes/.env`, not under a `platforms:` block in `~/.hermes/config.yaml`.
- Use `hermes gateway stop`, wait, then `hermes gateway start`; avoid `hermes gateway restart`.
- Do not use `hermes gateway setup` scan-to-create if the user already has an app; it creates a new one.
- Do not log or summarize `app_secret`.
- Webhook mode requires additional env vars if not using the default localhost port/path.

## Verification Checklist

1. `~/.hermes/.env` contains `FEISHU_APP_ID` and `FEISHU_APP_SECRET`.
2. `FEISHU_APP_ID` starts with `cli_`.
3. `FEISHU_DOMAIN` matches the platform where the app was created.
4. Gateway stop/start connects without auth errors.
5. Gateway logs show a Lark websocket connection.
6. Bot responds in DMs and when mentioned in groups.
