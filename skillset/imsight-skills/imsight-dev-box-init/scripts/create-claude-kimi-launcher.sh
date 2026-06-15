#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: create-claude-kimi-launcher.sh [options]

Creates a Unix claude-kimi launcher that runs Claude Code against Kimi Code.
The generated launcher reads a shared kimi-api-key file from the launcher dir.
If the key file is missing, the launcher prompts once and writes it there.

Options:
  --api-key KEY       Optional Kimi API key to seed the shared key file.
                     Defaults to KIMI_API_KEY, then ANTHROPIC_API_KEY.
  --output PATH      Launcher path. Default: $HOME/.local/bin/claude-kimi.
  --key-file PATH    Shared key file. Default: <launcher-dir>/kimi-api-key.
  --base-url URL     Anthropic-compatible Kimi endpoint. Default: https://api.kimi.com/coding/.
  --model MODEL      Default Claude Code model argument. Default: kimi-for-coding.
  --claude-bin PATH  Optional fixed Claude Code executable path.
  -h, --help         Show this help.
EOF
}

api_key="${KIMI_API_KEY:-${ANTHROPIC_API_KEY:-}}"
output="$HOME/.local/bin/claude-kimi"
key_file=""
base_url="https://api.kimi.com/coding/"
model="kimi-for-coding"
claude_bin=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --api-key)
      api_key="${2:?missing value for --api-key}"
      shift 2
      ;;
    --api-key=*)
      api_key="${1#*=}"
      shift
      ;;
    --output)
      output="${2:?missing value for --output}"
      shift 2
      ;;
    --output=*)
      output="${1#*=}"
      shift
      ;;
    --key-file)
      key_file="${2:?missing value for --key-file}"
      shift 2
      ;;
    --key-file=*)
      key_file="${1#*=}"
      shift
      ;;
    --base-url)
      base_url="${2:?missing value for --base-url}"
      shift 2
      ;;
    --base-url=*)
      base_url="${1#*=}"
      shift
      ;;
    --model)
      model="${2:?missing value for --model}"
      shift 2
      ;;
    --model=*)
      model="${1#*=}"
      shift
      ;;
    --claude-bin)
      claude_bin="${2:?missing value for --claude-bin}"
      shift 2
      ;;
    --claude-bin=*)
      claude_bin="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

output_dir="$(dirname "$output")"
if [[ -z "$key_file" ]]; then
  key_file="$output_dir/kimi-api-key"
fi

shell_quote() {
  printf '%q' "$1"
}

base_url_q="$(shell_quote "$base_url")"
model_q="$(shell_quote "$model")"
claude_bin_q="$(shell_quote "$claude_bin")"
key_file_q="$(shell_quote "$key_file")"

mkdir -p "$output_dir"
umask 077

if [[ -n "$api_key" ]]; then
  mkdir -p "$(dirname "$key_file")"
  printf '%s\n' "$api_key" > "$key_file"
  chmod 600 "$key_file"
fi

cat > "$output" <<SH
#!/usr/bin/env bash
set -euo pipefail

key_file=$key_file_q
if [[ ! -r "\$key_file" ]]; then
  if [[ ! -t 0 ]]; then
    echo "claude-kimi: missing \$key_file and cannot prompt for a key without a terminal" >&2
    exit 2
  fi
  read -r -s -p "Kimi API key: " ANTHROPIC_API_KEY
  echo >&2
  if [[ -z "\$ANTHROPIC_API_KEY" ]]; then
    echo "claude-kimi: empty Kimi API key" >&2
    exit 2
  fi
  mkdir -p "\$(dirname "\$key_file")"
  umask 077
  printf '%s\n' "\$ANTHROPIC_API_KEY" > "\$key_file"
  chmod 600 "\$key_file" 2>/dev/null || true
else
  IFS= read -r ANTHROPIC_API_KEY < "\$key_file" || true
  if [[ -z "\$ANTHROPIC_API_KEY" ]]; then
    echo "claude-kimi: empty Kimi API key in \$key_file" >&2
    exit 2
  fi
fi

export ANTHROPIC_API_KEY
export ANTHROPIC_BASE_URL=$base_url_q
unset ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_OAUTH_TOKEN
export CLAUDE_CODE_AUTO_COMPACT_WINDOW="\${CLAUDE_CODE_AUTO_COMPACT_WINDOW:-262144}"
KIMI_MODEL="\${CLAUDE_KIMI_MODEL:-$model_q}"

if command -v node >/dev/null 2>&1; then
  node --eval "
    const fs = require('fs');
    const os = require('os');
    const path = require('path');
    const filePath = path.join(os.homedir(), '.claude.json');
    const content = fs.existsSync(filePath)
      ? JSON.parse(fs.readFileSync(filePath, 'utf-8'))
      : {};
    fs.writeFileSync(
      filePath,
      JSON.stringify({ ...content, hasCompletedOnboarding: true }, null, 2),
      'utf-8'
    );
  "
fi

claude_bin=$claude_bin_q
if [[ -z "\$claude_bin" ]]; then
  for candidate in "\$HOME"/.nvm/versions/node/*/bin/claude "\$HOME"/.bun/bin/claude "\$HOME"/.local/bin/claude; do
    if [[ -x "\$candidate" ]]; then
      claude_bin="\$candidate"
      break
    fi
  done
fi
if [[ -z "\$claude_bin" ]]; then
  claude_bin="\$(command -v claude || true)"
fi
if [[ -z "\$claude_bin" ]]; then
  echo "claude-kimi: claude binary not found" >&2
  exit 127
fi

add_model=1
for arg in "\$@"; do
  # Runtime args belong to Claude Code. The launcher only observes them to avoid
  # injecting duplicate defaults; it must not consume or reinterpret Claude flags.
  case "\$arg" in
    --model|--model=*|--help|-h|--version|-v)
      add_model=0
      ;;
  esac
done

if [[ "\$add_model" -eq 1 ]]; then
  exec "\$claude_bin" --dangerously-skip-permissions --model "\$KIMI_MODEL" "\$@"
fi
exec "\$claude_bin" --dangerously-skip-permissions "\$@"
SH

chmod 700 "$output"
echo "created $output"
echo "key file: $key_file"
