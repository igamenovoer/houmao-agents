---
name: hermes-agent-setup
description: Install, bootstrap, and configure Hermes Agent, including Kimi/Moonshot provider setup, Feishu/Lark gateway setup, Houmao system skills installation, and Tavily CLI/search skills. Use when the user asks to install Hermes, configure Hermes, connect Hermes to Feishu or Lark, add Houmao skills to Hermes, set up Kimi for Hermes, or install Tavily for Hermes.
---

# Hermes Agent Setup

Use this skill for Hermes Agent installation and related setup tasks. Keep `SKILL.md` as the routing layer; load only the reference file needed for the user's requested setup path.

## Route

- Core Hermes install, source checkout, initial setup, config file locations: read `references/install.md`.
- Kimi / Moonshot provider config, `kimi-coding`, Kimi API key troubleshooting: read `references/provider-kimi.md`.
- Feishu / Lark bot, App ID + App Secret setup, gateway env vars, gateway start flow: read `references/messaging-feishu.md`.
- Houmao system skills copied into Hermes skill storage: read `references/houmao-skills.md`.
- Tavily CLI, Tavily API key login, and Tavily skills for Hermes: read `references/tavily.md`.

## Full Setup Order

When the user asks for a complete Hermes environment, use this order:

1. Install Hermes or verify it already exists.
2. Configure the requested model provider.
3. Install requested local skill/tool bundles.
4. Configure messaging gateway if requested.
5. Verify with relevant commands such as `hermes --version`, `hermes config check`, `hermes skills list`, `tvly --status`, and `hermes gateway status`.

## Operating Rules

- Keep secrets in `~/.hermes/.env`; do not log API keys, Feishu/Lark app secrets, or copied credential values.
- Prefer appending missing env vars over overwriting `~/.hermes/.env`, unless the user explicitly asks to replace it.
- For Feishu/Lark gateway changes, use `hermes gateway stop`, wait a few seconds, then `hermes gateway start`; avoid `hermes gateway restart`.
- If workspace instructions require a proxy for non-git network downloads, apply it to `curl`, `uv`, package installs, and dependency resolution. Do not add, change, or unset proxy variables for git commands.
- Ask for missing API keys or app secrets only when they cannot be discovered from the prompt or environment.

## Verification

Always finish by running the lightest useful checks for the path used:

- Hermes installed: `hermes --version`
- Provider config: `hermes config check`
- One-shot model call: `hermes -z "hello"`
- Skills installed: `hermes skills list`
- Tavily installed: `tvly --status`
- Gateway configured: `hermes gateway status`
