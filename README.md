# ⚡ Use OpenAI Codex CLI with Crazyrouter

Run OpenAI Codex CLI through [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) with one command.

Crazyrouter provides an OpenAI-compatible API endpoint, so Codex CLI can use Crazyrouter by setting the API key and base URL.

> Important: API endpoints should **not** include UTM parameters. Use UTM only on human-facing links.

## 🚀 One-click setup

### Windows

Open PowerShell as your normal user and run:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

Or download and double-click:

```text
install-crazyrouter-codex.bat
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

The installer will:

- ask for your Crazyrouter API key
- save it as an environment variable
- configure Codex CLI to use `https://crazyrouter.com/v1`
- back up your existing Codex config if one exists

## ⚡ Manual quick start

### 1. Install Codex CLI

```bash
npm install -g @openai/codex
```

### 2. Set environment variables

macOS / Linux:

```bash
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://crazyrouter.com/v1
```

Windows PowerShell:

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://crazyrouter.com/v1"
```

Restart your terminal after using `setx`.

### 3. Run Codex

```bash
codex
```

## 🔧 Persistent config

### macOS / Linux

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://crazyrouter.com/v1
CONF
source ~/.zshrc
```

If you use Bash, write the same lines to `~/.bashrc` instead.

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://crazyrouter.com/v1"
```

## 🧩 Codex config.toml option

Some Codex versions support provider configuration in `%USERPROFILE%\.codex\config.toml` on Windows or `~/.codex/config.toml` on macOS/Linux.

```toml
model = "gpt-5.5"
model_provider = "crazyrouter"

[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "https://crazyrouter.com/v1"
env_key = "OPENAI_API_KEY"
wire_api = "chat"

[model_providers.crazyrouter.query_params]
```

## 🎯 Model selection

```bash
codex                              # default model from config
codex --model gpt-5.5              # Crazyrouter default recommendation
codex --model gpt-4o-mini          # budget option
codex --model claude-sonnet-4-6    # Claude via Crazyrouter, if enabled in your account
```

Model availability may vary by account and provider route. Check the Crazyrouter model list before using a model name in production.

## 🔒 Safety modes

```bash
codex --approval-mode suggest      # read-only suggestions
codex --approval-mode auto-edit    # auto-edit, confirm commands
codex --approval-mode full-auto    # full autonomous mode
```

## ❓ FAQ

**Q: Does Codex CLI work with Crazyrouter?**  
A: Yes. Crazyrouter exposes an OpenAI-compatible endpoint. Use `https://crazyrouter.com/v1` as the base URL.

**Q: Should I add UTM parameters to `OPENAI_BASE_URL`?**  
A: No. Never add UTM parameters to API endpoints. This is wrong:

```bash
export OPENAI_BASE_URL=https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community/v1
```

Use this instead:

```bash
export OPENAI_BASE_URL=https://crazyrouter.com/v1
```

**Q: Can I use non-OpenAI models?**  
A: Yes. Through Crazyrouter, you can use supported Claude, Gemini, Llama, Qwen, DeepSeek, and other models with compatible routes.

**Q: Node.js version requirement?**  
A: Node.js 22+ is recommended. Use `nvm install 22` if needed.

## 🔗 Links

- 🌐 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community)
- 📦 [Codex CLI](https://github.com/openai/codex)
- 💬 [Telegram](https://t.me/crzrouter)

## 📄 License

MIT
