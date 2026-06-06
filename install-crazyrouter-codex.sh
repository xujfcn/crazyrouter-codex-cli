#!/usr/bin/env bash
# Crazyrouter + OpenAI Codex CLI setup for macOS / Linux
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch

set -euo pipefail

BASE_URL="https://cn.crazyrouter.com/v1"
DEFAULT_MODEL="gpt-5.5"
MODE="full"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

say() { printf "${CYAN}==> %s${NC}\n" "$1"; }
ok() { printf "${GREEN}[OK] %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}[WARN] %s${NC}\n" "$1"; }
fail() { printf "${RED}[ERROR] %s${NC}\n" "$1" >&2; exit 1; }

usage() {
  cat <<EOF
Crazyrouter Codex CLI installer

Usage:
  install-crazyrouter-codex.sh [--full|--switch]

Modes:
  --full     Install Git, Node.js, Codex CLI, then configure Crazyrouter. Default.
  --switch   Only switch an existing Codex CLI installation to Crazyrouter.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --full) MODE="full" ;;
    --switch|--switch-only) MODE="switch" ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Unknown argument: $1" ;;
  esac
  shift
done

ensure_cmd() {
  command -v "$1" >/dev/null 2>&1
}

require_sudo_if_needed() {
  if [ "$(id -u)" -eq 0 ]; then
    echo ""
  elif ensure_cmd sudo; then
    echo "sudo"
  else
    fail "sudo not found. Please install the missing dependency manually, then rerun."
  fi
}

install_git() {
  if ensure_cmd git; then
    ok "Git already installed: $(git --version)"
    return
  fi

  say "Installing Git"
  local sudo_cmd
  sudo_cmd="$(require_sudo_if_needed)"

  if ensure_cmd brew; then
    brew install git
  elif ensure_cmd apt-get; then
    $sudo_cmd apt-get update
    $sudo_cmd apt-get install -y git
  elif ensure_cmd dnf; then
    $sudo_cmd dnf install -y git
  elif ensure_cmd yum; then
    $sudo_cmd yum install -y git
  elif ensure_cmd pacman; then
    $sudo_cmd pacman -Sy --noconfirm git
  elif ensure_cmd zypper; then
    $sudo_cmd zypper install -y git
  else
    fail "Could not auto-install Git. Please install Git manually, then rerun."
  fi

  ok "Git installed: $(git --version)"
}

node_major_version() {
  node -p "process.versions.node.split('.')[0]" 2>/dev/null || true
}

install_node() {
  if ensure_cmd node && ensure_cmd npm; then
    local major
    major="$(node_major_version)"
    if [ -n "$major" ] && [ "$major" -lt 22 ] 2>/dev/null; then
      warn "Node.js $(node --version) is installed. Node.js 22+ is recommended for Codex CLI."
    else
      ok "Node.js already installed: $(node --version) / npm $(npm --version)"
    fi
    return
  fi

  say "Installing Node.js and npm"
  local sudo_cmd
  sudo_cmd="$(require_sudo_if_needed)"

  if ensure_cmd brew; then
    brew install node
  elif ensure_cmd apt-get; then
    $sudo_cmd apt-get update
    $sudo_cmd apt-get install -y nodejs npm
  elif ensure_cmd dnf; then
    $sudo_cmd dnf install -y nodejs npm
  elif ensure_cmd yum; then
    $sudo_cmd yum install -y nodejs npm
  elif ensure_cmd pacman; then
    $sudo_cmd pacman -Sy --noconfirm nodejs npm
  elif ensure_cmd zypper; then
    $sudo_cmd zypper install -y nodejs npm
  else
    fail "Could not auto-install Node.js. Please install Node.js 22+ manually, then rerun."
  fi

  if ! ensure_cmd node || ! ensure_cmd npm; then
    fail "Node.js installation finished, but node/npm are still not found in PATH."
  fi

  ok "Node.js installed: $(node --version) / npm $(npm --version)"
}

extend_npm_path() {
  local npm_prefix
  npm_prefix="$(npm config get prefix 2>/dev/null || true)"
  if [ -n "$npm_prefix" ]; then
    export PATH="$PATH:$npm_prefix/bin"
  fi
  export PATH="$PATH:$HOME/.npm-global/bin:$HOME/.local/bin"
}

ensure_codex_installed() {
  if ensure_cmd codex; then
    ok "Codex CLI already installed: $(codex --version 2>/dev/null || echo 'present')"
    return
  fi

  say "Installing OpenAI Codex CLI"
  npm install -g @openai/codex
  extend_npm_path

  if ! ensure_cmd codex; then
    fail "Codex CLI installed, but 'codex' is still not found in PATH. Reopen your terminal and run: codex --version"
  fi

  ok "Codex CLI installed: $(codex --version 2>/dev/null || echo 'present')"
}

require_existing_codex() {
  if ! ensure_cmd codex; then
    fail "Codex CLI is not installed or not in PATH. Rerun with --full to install it automatically."
  fi
  ok "Codex CLI detected: $(codex --version 2>/dev/null || echo 'present')"
}

pick_shell_rc() {
  if [ -n "${ZSH_VERSION:-}" ] || [ -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc"
  elif [ -n "${BASH_VERSION:-}" ] || [ -f "$HOME/.bashrc" ]; then
    echo "$HOME/.bashrc"
  else
    echo "$HOME/.profile"
  fi
}

write_shell_exports() {
  local shell_rc="$1"
  local api_key="$2"

  touch "$shell_rc"

  if grep -q "# >>> Crazyrouter Codex CLI >>>" "$shell_rc" 2>/dev/null; then
    local tmpfile
    tmpfile="$(mktemp)"
    awk '
      BEGIN { skip=0 }
      /# >>> Crazyrouter Codex CLI >>>/ { skip=1; next }
      /# <<< Crazyrouter Codex CLI <<</ { skip=0; next }
      skip==0 { print }
    ' "$shell_rc" > "$tmpfile"
    mv "$tmpfile" "$shell_rc"
  fi

  cat >> "$shell_rc" <<EOF

# >>> Crazyrouter Codex CLI >>>
export OPENAI_API_KEY="$api_key"
export OPENAI_BASE_URL="$BASE_URL"
# <<< Crazyrouter Codex CLI <<<
EOF
}

backup_file() {
  local path="$1"
  if [ -f "$path" ]; then
    local ts backup_path
    ts="$(date +%Y%m%d_%H%M%S)"
    backup_path="$path.bak.$ts"
    cp "$path" "$backup_path"
    warn "Backed up existing config to: $backup_path"
  fi
}

write_codex_config() {
  local model="$1"
  local codex_dir="$HOME/.codex"
  local config_path="$codex_dir/config.toml"
  local tmpfile

  mkdir -p "$codex_dir"
  backup_file "$config_path"
  tmpfile="$(mktemp)"

  {
    printf 'model = "%s"\n' "$model"
    printf 'model_provider = "crazyrouter"\n\n'

    if [ -f "$config_path" ]; then
      awk '
        BEGIN { section=""; skip=0 }
        /^[[:space:]]*\[/ {
          if ($0 ~ /^[[:space:]]*\[model_providers\.crazyrouter(\.|\])/) {
            skip=1
            next
          }
          skip=0
          section=$0
        }
        skip { next }
        section == "" && $0 ~ /^[[:space:]]*model[[:space:]]*=/ { next }
        section == "" && $0 ~ /^[[:space:]]*model_provider[[:space:]]*=/ { next }
        { print }
      ' "$config_path"
      printf '\n'
    fi

    cat <<EOF
[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "$BASE_URL"
env_key = "OPENAI_API_KEY"
wire_api = "responses"

[model_providers.crazyrouter.query_params]
EOF
  } > "$tmpfile"

  mv "$tmpfile" "$config_path"
  ok "Codex config written: $config_path"
}

read_from_tty() {
  local prompt="$1"
  local silent="${2:-false}"
  local value=""

  if [ ! -r /dev/tty ]; then
    fail "No interactive terminal found. Rerun this command in a normal terminal."
  fi

  if [ "$silent" = "true" ]; then
    printf "%s" "$prompt" > /dev/tty
    IFS= read -r -s value < /dev/tty
    printf "\n" > /dev/tty
  else
    printf "%s" "$prompt" > /dev/tty
    IFS= read -r value < /dev/tty
  fi

  printf "%s" "$value"
}

collect_settings() {
  API_KEY="$(read_from_tty "Paste your Crazyrouter API key (input hidden): " true)"
  if [ -z "${API_KEY// }" ]; then
    fail "No API key entered. Get one at https://cn.crazyrouter.com"
  fi

  if ! printf "%s" "$API_KEY" | grep -Eq '^(sk-|cr-|rk-)'; then
    warn "Token format looks unusual. Continuing anyway."
  fi

  MODEL="$(read_from_tty "Model name [default: $DEFAULT_MODEL]: " false)"
  MODEL="${MODEL:-$DEFAULT_MODEL}"

  if printf "%s" "$MODEL" | grep -q '"'; then
    fail "Model name cannot contain double quotes."
  fi
}

ensure_test_repo() {
  local repo_path="$1"
  mkdir -p "$repo_path"
  if ensure_cmd git && [ ! -d "$repo_path/.git" ]; then
    git -C "$repo_path" init >/dev/null
    ok "Created test repo at $repo_path"
  else
    ok "Test directory ready: $repo_path"
  fi
}

show_next_steps() {
  local shell_rc="$1"
  local model="$2"
  local repo_path="${3:-}"

  echo
  echo "========================================"
  echo "Crazyrouter Codex CLI setup complete"
  echo "========================================"
  echo
  echo "Mode: $MODE"
  echo "Base URL: $BASE_URL"
  echo "Model: $model"
  echo "Shell config updated: $shell_rc"
  echo
  echo "Next steps:"
  echo "1. Run: source $shell_rc"
  echo "2. Run: codex --version"
  if [ -n "$repo_path" ]; then
    echo "3. Run:"
    echo "   cd \"$repo_path\""
    echo "   codex"
  else
    echo "3. Start Codex in your project directory: codex"
  fi
}

main() {
  echo "Crazyrouter Codex CLI installer"
  echo

  if [ "$MODE" = "full" ]; then
    echo "This mode will install Git, Node.js, Codex CLI, then configure Crazyrouter."
  else
    echo "This mode will only switch your existing Codex CLI configuration to Crazyrouter."
  fi
  echo

  collect_settings

  if [ "$MODE" = "full" ]; then
    install_git
    install_node
    ensure_codex_installed
  else
    require_existing_codex
  fi

  local shell_rc repo_path
  shell_rc="$(pick_shell_rc)"
  say "Saving Crazyrouter environment variables to $shell_rc"
  write_shell_exports "$shell_rc" "$API_KEY"

  export OPENAI_API_KEY="$API_KEY"
  export OPENAI_BASE_URL="$BASE_URL"

  say "Updating Codex provider config"
  write_codex_config "$MODEL"

  repo_path=""
  if [ "$MODE" = "full" ]; then
    repo_path="$HOME/Projects/codex-crazyrouter-test"
    ensure_test_repo "$repo_path"
  fi

  show_next_steps "$shell_rc" "$MODEL" "$repo_path"
}

main "$@"
