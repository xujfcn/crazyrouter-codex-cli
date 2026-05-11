#!/usr/bin/env bash
set -euo pipefail

echo "Crazyrouter Codex CLI installer"
echo "This will configure Codex CLI to use https://crazyrouter.com/v1"
echo

CODEX_DIR="$HOME/.codex"
CONFIG_PATH="$CODEX_DIR/config.toml"
mkdir -p "$CODEX_DIR"

if [ -f "$CONFIG_PATH" ]; then
  TS="$(date +%Y%m%d_%H%M%S)"
  BACKUP_PATH="$CONFIG_PATH.bak.$TS"
  cp "$CONFIG_PATH" "$BACKUP_PATH"
  echo "Backed up existing config to: $BACKUP_PATH"
fi

printf "Paste your Crazyrouter API key: "
read -r API_KEY
if [ -z "${API_KEY// }" ]; then
  echo "API key is empty." >&2
  exit 1
fi

printf "Model name [default: gpt-5.5]: "
read -r MODEL
MODEL="${MODEL:-gpt-5.5}"

cat > "$CONFIG_PATH" <<EOF
model = "$MODEL"
model_provider = "crazyrouter"

[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "https://crazyrouter.com/v1"
env_key = "OPENAI_API_KEY"
wire_api = "chat"

[model_providers.crazyrouter.query_params]
EOF

SHELL_RC=""
case "${SHELL:-}" in
  */zsh) SHELL_RC="$HOME/.zshrc" ;;
  */bash) SHELL_RC="$HOME/.bashrc" ;;
  *) SHELL_RC="$HOME/.profile" ;;
esac

{
  echo ""
  echo "# Codex CLI via Crazyrouter"
  echo "export OPENAI_API_KEY='$API_KEY'"
  echo "export OPENAI_BASE_URL='https://crazyrouter.com/v1'"
} >> "$SHELL_RC"

echo
echo "Done. Codex CLI is now configured to use Crazyrouter."
echo "Config: $CONFIG_PATH"
echo "Model: $MODEL"
echo "Base URL: https://crazyrouter.com/v1"
echo "Shell config updated: $SHELL_RC"
echo
echo "Run this now, or restart your terminal:"
echo "  source $SHELL_RC"
