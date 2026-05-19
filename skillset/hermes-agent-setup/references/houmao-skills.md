# Houmao System Skills in Hermes

Install `houmao-mgr` system skills into Hermes Agent's skill repository. Do not use `houmao-mgr system-skills install --tool <tool>` for this; it writes to the target tool's own home, such as `~/.codex/skills/`, not to Hermes.

Instead, copy the skill assets directly from the houmao Python package into `~/.hermes/skills/` using `/tmp` as a staging area.

## Why Stage Through `/tmp`

- The houmao package is installed in a `uv` tool environment and paths may have restricted permissions.
- Staging lets you verify the file list before moving to the final destination.
- It reduces the chance of partial installs if something fails mid-copy.

## Prerequisites

- `houmao-mgr` is installed and available in `PATH`.
- Hermes Agent is installed and `~/.hermes/skills/` exists.

## Discover Houmao Package Location

```bash
HOUMAO_PYTHON="$(head -n 1 "$(which houmao-mgr)" | sed 's|#!/||')"
"$HOUMAO_PYTHON" -c "import houmao; print(houmao.__file__)"
```

Typical path:

```text
/home/<user>/.local/share/uv/tools/houmao/lib/python3.13/site-packages/houmao
```

## Stage Skills

```bash
HOUMAO_PYTHON="$(head -n 1 "$(which houmao-mgr)" | sed 's|#!/||')"
HOUMAO_PKG="$("$HOUMAO_PYTHON" -c 'import houmao, os; print(os.path.dirname(houmao.__file__))')"
SOURCE="$HOUMAO_PKG/agents/assets/system_skills"
STAGING="/tmp/houmao-skills-$(date +%s)"

cp -r "$SOURCE" "$STAGING"
ls "$STAGING"
ls "$STAGING/system_skills/"
```

The staged directory should contain skill directories such as `houmao-agent-definition`, `houmao-agent-instance`, `houmao-agent-messaging`, and similar system skills.

## Install Into Hermes

```bash
DEST="$HOME/.hermes/skills/houmao"
mkdir -p "$DEST"
rm -rf "$DEST"/*
cp -r "$STAGING/system_skills"/* "$DEST/"
```

## One-Shot Script

```bash
#!/bin/bash
set -e

if ! command -v houmao-mgr >/dev/null 2>&1; then
    echo "houmao-mgr not found in PATH"
    exit 1
fi

HOUMAO_PYTHON="$(head -n 1 "$(which houmao-mgr)" | sed 's|#!/||')"
HOUMAO_PKG="$("$HOUMAO_PYTHON" -c 'import houmao, os; print(os.path.dirname(houmao.__file__))')"
SOURCE="$HOUMAO_PKG/agents/assets/system_skills"
STAGING="/tmp/houmao-skills-$$"
DEST="$HOME/.hermes/skills/houmao"

if [ ! -d "$SOURCE" ]; then
    echo "Cannot find houmao system skills at: $SOURCE"
    exit 1
fi

echo "Staging from $SOURCE to $STAGING..."
cp -r "$SOURCE" "$STAGING"

echo "Installing to $DEST..."
mkdir -p "$DEST"
rm -rf "$DEST"/*
cp -r "$STAGING/system_skills"/* "$DEST/"
rm -rf "$STAGING"

echo "Done. Verifying..."
hermes skills list | grep houmao || true
echo "Installed $(ls -1 "$DEST" | wc -l) skills."
```

## Available Skill Sets

Run `houmao-mgr system-skills list` to see current offerings.

Known core examples:

- `houmao-process-emails-via-gateway`
- `houmao-agent-email-comms`
- `houmao-mailbox-mgr`
- `houmao-memory-mgr`
- `houmao-adv-usage-pattern`
- `houmao-touring`
- `houmao-project-mgr`
- `houmao-specialist-mgr`
- `houmao-credential-mgr`
- `houmao-agent-definition`
- `houmao-agent-instance`
- `houmao-agent-inspect`
- `houmao-agent-messaging`
- `houmao-agent-gateway`
- `houmao-utils-llm-wiki`
- `houmao-utils-workspace-mgr`

## Verify

```bash
hermes skills list | grep houmao
```

All copied skills should show as enabled and local. If they show as disabled, run:

```bash
hermes skills config
```

## Pitfalls

- Do not use `houmao-mgr system-skills install --tool codex`; it writes to `~/.codex/skills/`, invisible to Hermes.
- Always verify with `hermes skills list` after copying.
- If a skill directory already exists in `~/.hermes/skills/houmao/`, remove it first to avoid stale files.
- Discover the houmao package dynamically; Python versioned paths can change.
