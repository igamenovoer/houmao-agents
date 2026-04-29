---
name: hermes-add-houmao-skill
description: "Install houmao-mgr system skills into Hermes Agent's skill repository using /tmp as staging."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [houmao, hermes, skills, migration, codex, claude, copilot, gemini]
    related_skills: [hermes-agent]
---

# Install Houmao Skills into Hermes

When a user asks to install houmao-mgr system skills into Hermes, **do not** use `houmao-mgr system-skills install --tool <tool>` — that writes to the tool's own home (e.g. `~/.codex/skills/`), not Hermes's. Instead, copy the skill assets directly from the houmao Python package into `~/.hermes/skills/` using `/tmp` as a staging area.

## Why /tmp as Middle Ground

- The houmao package is installed in a `uv` tool environment with restricted permissions.
- Copying through `/tmp` avoids permission issues and lets you verify the file list before moving to the final destination.
- It also prevents partial installs if something goes wrong mid-copy.

## Prerequisites

- `houmao-mgr` is installed and available in PATH.
- Hermes Agent is installed (`~/.hermes/skills/` exists).

## Steps

### 1. Discover houmao package location

```bash
# Find the uv tool python
HOUMAO_PYTHON=$(head -n 1 $(which houmao-mgr) | sed 's|#!/||')
# Or directly:
HOUMAO_PYTHON="$HOME/.local/share/uv/tools/houmao/bin/python3"

# Find the package root
$HOUMAO_PYTHON -c "import houmao; print(houmao.__file__)"
```

Typical path:
```
/home/<user>/.local/share/uv/tools/houmao/lib/python3.13/site-packages/houmao
```

### 2. Stage skills to /tmp

```bash
SOURCE="/home/<user>/.local/share/uv/tools/houmao/lib/python3.13/site-packages/houmao/agents/assets/system_skills"
STAGING="/tmp/houmao-skills-$(date +%s)"

cp -r "$SOURCE" "$STAGING"
ls "$STAGING"
```

### 3. Verify staged contents

```bash
ls "$STAGING/system_skills/"
# Should show ~21 directories like:
#   houmao-adv-usage-pattern
#   houmao-agent-definition
#   houmao-agent-email-comms
#   ...
```

### 4. Install into Hermes

```bash
DEST="$HOME/.hermes/skills/houmao"
mkdir -p "$DEST"

# Remove old copies first
rm -rf "$DEST"/*

# Copy from staging
cp -r "$STAGING/system_skills"/* "$DEST/"
```

### 5. Verify installation

```bash
hermes skills list | grep houmao
```

All should show `enabled` and `local`.

## One-Shot Script

```bash
#!/bin/bash
set -e

HOUMAO_PKG="$HOME/.local/share/uv/tools/houmao/lib/python3.13/site-packages/houmao"
SOURCE="$HOUMAO_PKG/agents/assets/system_skills"
STAGING="/tmp/houmao-skills-$$"
DEST="$HOME/.hermes/skills/houmao"

if [ ! -d "$SOURCE" ]; then
    echo "Source not found: $SOURCE"
    echo "Trying to auto-detect houmao package..."
    HOUMAO_PYTHON="$(head -n 1 "$(which houmao-mgr)" | sed 's|#!/||')"
    HOUMAO_PKG="$($HOUMAO_PYTHON -c 'import houmao, os; print(os.path.dirname(houmao.__file__))')"
    SOURCE="$HOUMAO_PKG/agents/assets/system_skills"
fi

if [ ! -d "$SOURCE" ]; then
    echo "Cannot find houmao system skills. Is houmao-mgr installed?"
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

Run `houmao-mgr system-skills list` to see current offerings. As of houmao-mgr 0.9.1:

**Core set (20 skills):**
- houmao-process-emails-via-gateway
- houmao-agent-email-comms
- houmao-mailbox-mgr
- houmao-memory-mgr
- houmao-adv-usage-pattern
- houmao-touring
- houmao-project-mgr
- houmao-specialist-mgr
- houmao-credential-mgr
- houmao-agent-definition
- houmao-agent-loop-pairwise
- houmao-agent-loop-pairwise-v2
- houmao-agent-loop-pairwise-v3
- houmao-agent-loop-pairwise-v4
- houmao-agent-loop-generic
- houmao-agent-instance
- houmao-agent-inspect
- houmao-agent-messaging
- houmao-agent-gateway

**Extra (2 skills, part of `all` set):**
- houmao-utils-llm-wiki
- houmao-utils-workspace-mgr

## Pitfalls

- **Do not** use `houmao-mgr system-skills install --tool codex` — it writes to `~/.codex/skills/`, invisible to Hermes.
- Always verify with `hermes skills list` after copying.
- If skills show as `disabled`, run `hermes skills config` to enable them per platform.
- If a skill directory already exists in `~/.hermes/skills/houmao/`, remove it first to avoid stale files.
- The houmao package path may change with Python version updates — always discover dynamically rather than hardcoding.
