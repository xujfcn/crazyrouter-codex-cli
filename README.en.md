<div align="center">

# Use OpenAI Codex CLI With Crazyrouter

**Connect Codex CLI to Crazyrouter in minutes, then use Crazyrouter-supported models through an OpenAI-compatible API.**

[English](./README.en.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Русский](./README.ru.md)

![OpenAI Compatible](https://img.shields.io/badge/API-OpenAI%20compatible-111111?style=flat-square)
![Codex CLI](https://img.shields.io/badge/Tool-Codex%20CLI-111111?style=flat-square)
![Base URL](https://img.shields.io/badge/Base%20URL-%2Fv1-2563eb?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-111111?style=flat-square)

</div>

---

## At A Glance

| Item | Value |
| --- | --- |
| Project goal | Route OpenAI Codex CLI through [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) |
| API style | OpenAI-compatible |
| Recommended Base URL | `https://cn.crazyrouter.com/v1` |
| Required settings | `OPENAI_API_KEY`, `OPENAI_BASE_URL`, model name |
| Important rule | Never add UTM parameters to `OPENAI_BASE_URL` |

---

## Choose Your Setup Path

| Situation | Recommended mode |
| --- | --- |
| `codex --version` already works | Mode A: switch existing Codex CLI to Crazyrouter |
| New machine or no Codex CLI yet | Mode B: full one-command setup |
| You do not want to run scripts | Manual setup |

---

## Mode A: Existing Codex CLI, Switch To Crazyrouter

Use this mode if `codex` is already installed and you only want to route Codex CLI through Crazyrouter. The script will:

- check whether the `codex` command exists;
- ask for your Crazyrouter API key;
- ask for your default model;
- write `OPENAI_API_KEY` and `OPENAI_BASE_URL`;
- update Codex `config.toml`;
- back up your existing config automatically.

Windows PowerShell:

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

---

## Mode B: Full Setup For New Users

Use this mode on a clean machine. The script installs or checks:

- Git;
- Node.js + npm;
- OpenAI Codex CLI;
- Crazyrouter API key and Base URL;
- Codex provider config;
- a local test project directory.

Windows PowerShell:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

You can also download and double-click:

```text
install-crazyrouter-codex.bat
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

Full setup is the default mode, equivalent to:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

If you downloaded the Windows script locally, you can choose a mode explicitly:

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

---

## Manual Setup

### 1. Install Codex CLI

Full setup installs Codex CLI automatically. For manual installation:

```bash
npm install -g @openai/codex
```

Node.js 22+ is recommended. If you use nvm:

```bash
nvm install 22
nvm use 22
```

### 2. Set Environment Variables

macOS / Linux:

```bash
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

Windows PowerShell:

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

After using `setx` on Windows, reopen your terminal.

### 3. Start Codex

```bash
codex
```

---

## Persistent Configuration

### macOS / Linux

If you use zsh:

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
CONF
source ~/.zshrc
```

If you use Bash, write the same lines to `~/.bashrc`.

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

---

## Codex config.toml Example

Config path:

- Windows: `%USERPROFILE%\.codex\config.toml`
- macOS / Linux: `~/.codex/config.toml`

Example:

```toml
model = "gpt-5.5"
model_provider = "crazyrouter"

[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "https://cn.crazyrouter.com/v1"
env_key = "OPENAI_API_KEY"
wire_api = "responses"

[model_providers.crazyrouter.query_params]
```

If you see:

```text
wire_api = "chat" is no longer supported
```

change:

```toml
wire_api = "chat"
```

to:

```toml
wire_api = "responses"
```

---

## Model Selection

```bash
codex                              # use the default model from config
codex --model gpt-5.5              # example default model
codex --model gpt-4o-mini          # example lower-cost model
codex --model claude-sonnet-4-6    # example Claude model, depending on account and route support
```

Model availability depends on your Crazyrouter account, enabled routes, upstream model status, and current Codex CLI compatibility. Check the model list before use:

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## Verify The Setup

```bash
codex --version
codex --help
```

Start Codex from a project directory:

```bash
cd your-project
codex
```

Codex CLI flags may change between versions. Use `codex --help` as the source of truth for your installed version.

---

## Which Base URL Should You Use?

Recommended default:

```text
https://cn.crazyrouter.com/v1
```

If you explicitly want the global endpoint:

```text
https://crazyrouter.com/v1
```

Do not omit `/v1`.

Incorrect:

```text
https://cn.crazyrouter.com
```

Correct:

```text
https://cn.crazyrouter.com/v1
```

---

## Troubleshooting

### 1. `codex` Command Not Found

Check:

```bash
codex --version
npm list -g @openai/codex
```

If Codex CLI is not installed:

```bash
npm install -g @openai/codex
```

Windows users usually need to reopen PowerShell after installation. macOS / Linux users can run the `source ~/.zshrc`, `source ~/.bashrc`, or `source ~/.profile` command shown by the script.

### 2. npm EACCES While Installing Codex CLI On macOS

If you see an error like:

```text
npm error code EACCES
npm error path /usr/local/lib/node_modules/@openai
```

your user cannot write to npm's global install directory. The latest installer automatically switches npm's global prefix to a user-owned directory. Rerun the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

You can also fix it manually:

```bash
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
npm install -g @openai/codex
```

Avoid `sudo npm install -g @openai/codex`; it often causes more permission and PATH issues later.

### 3. macOS Cannot Auto-Install Node.js

If full setup says it could not auto-install Node.js, install Node.js 22+ manually with one of these options, then open a new terminal and rerun the installer.

Official installer:

```text
https://nodejs.org/en/download
```

With Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node
```

With nvm:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.zshrc
nvm install 22
nvm use 22
```

Verify:

```bash
node --version
npm --version
```

### 4. API Key Does Not Work

Check environment variables.

macOS / Linux:

```bash
echo $OPENAI_API_KEY
echo $OPENAI_BASE_URL
```

Windows PowerShell:

```powershell
echo $env:OPENAI_API_KEY
echo $env:OPENAI_BASE_URL
```

Confirm that:

- the API key is from the Crazyrouter console;
- the Base URL includes `/v1`;
- the terminal has been restarted;
- your account has enough balance.

### 5. Model Is Unavailable

Try another model:

```bash
codex --model gpt-5.5
```

Or confirm the model name on the model page:

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

### 6. 500 / 502 / 524 Errors

These errors are usually related to upstream models, route instability, timeouts, or long context.

Suggested steps:

1. Retry once.
2. Switch to a similar model.
3. Shorten the prompt.
4. Check the Base URL.
5. If the issue persists, send the model name, error code, and request time to support.

Reference:

https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## FAQ

### Can Codex CLI use Crazyrouter directly?

Yes. Crazyrouter provides an OpenAI-compatible endpoint. If Codex CLI supports a custom OpenAI endpoint, it can connect through the Base URL.

### Can I add UTM parameters to `OPENAI_BASE_URL`?

No.

Wrong:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1?utm_source=github
```

Correct:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

### Can I use Claude / Gemini / DeepSeek / Qwen?

Yes. You can use supported non-OpenAI models through Crazyrouter, but availability depends on your account, model routes, and the current Codex CLI compatibility.

### Do I have to use `cn.crazyrouter.com`?

No. `https://cn.crazyrouter.com/v1` is the recommended default. If the global endpoint works better for you, use `https://crazyrouter.com/v1`.

### Node.js version requirement?

Node.js 22+ is recommended.

---

## Links

- Crazyrouter: https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Model list: https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Base URL explained: https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- API error troubleshooting: https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Codex CLI: https://github.com/openai/codex
- Telegram: https://t.me/crzrouter

## License

MIT
