# ⚡ 使用 Crazyrouter 运行 OpenAI Codex CLI / Use OpenAI Codex CLI with Crazyrouter

> 中文优先说明：本仓库默认面向国内用户，先看中文教程即可。English guide is available below.

用一条命令把 OpenAI Codex CLI 接到 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community)，通过 Crazyrouter 的 OpenAI-compatible API 使用 Codex CLI。

Crazyrouter 提供 OpenAI 兼容接口，所以 Codex CLI 通常只需要配置：

1. API Key
2. Base URL
3. 模型名

> 重要：API endpoint 不能加 UTM 参数。UTM 只用于人点击的网页链接，不用于 `OPENAI_BASE_URL`。

---

## 🇨🇳 中文使用指南

### 适合谁用？

如果你想：

- 在国内/内地环境更稳定地使用 Codex CLI；
- 用一个 API Key 接入多个模型；
- 在 Codex CLI 里使用 Crazyrouter 支持的 GPT / Claude / Gemini / DeepSeek / Qwen 等模型；
- 避免每个工具单独配置不同 provider；
- 用 OpenAI-compatible 方式快速接入；

这个仓库就是给你用的。

---

## 🚀 两种一键模式

### 模式 A：已有 Codex，只切换到本站

适合已经安装过 `codex`、只想把 Codex CLI 接到 Crazyrouter 的用户。脚本会：

- 检查 `codex` 命令是否存在；
- 询问 Crazyrouter API Key 和默认模型；
- 写入 `OPENAI_API_KEY` / `OPENAI_BASE_URL`；
- 更新 `~/.codex/config.toml` 或 `%USERPROFILE%\.codex\config.toml`；
- 自动备份已有 Codex 配置。

Windows PowerShell：

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

### 模式 B：新手完整一键安装

适合完全没有环境的新用户。脚本会自动安装/检查：

- Git；
- Node.js + npm；
- OpenAI Codex CLI；
- Crazyrouter API Key 和 Base URL；
- Codex provider 配置；
- 一个可测试的本地项目目录。

Windows PowerShell：

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

或者下载后双击：

```text
install-crazyrouter-codex.bat
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

默认模式就是完整安装，等同于：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

Windows 本地下载后也可以指定模式：

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

> 新手直接用“模式 B”。已经能正常运行 `codex --version` 的用户，用“模式 A”更快。

---

## ⚡ 手动配置教程

### 1. 安装 Codex CLI

新手完整模式会自动安装 Codex CLI。手动安装可以用：

```bash
npm install -g @openai/codex
```

建议使用 Node.js 22+。

如果你用 nvm：

```bash
nvm install 22
nvm use 22
```

### 2. 设置环境变量

macOS / Linux：

```bash
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

Windows PowerShell：

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

Windows 使用 `setx` 后，需要重新打开终端。

### 3. 启动 Codex

```bash
codex
```

---

## 🔧 持久化配置

### macOS / Linux

如果你用 zsh：

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
CONF
source ~/.zshrc
```

如果你用 Bash，把同样内容写入 `~/.bashrc`。

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

---

## 🧩 Codex config.toml 配置方式

部分 Codex CLI 版本支持 provider 配置文件。

配置路径：

- Windows：`%USERPROFILE%\.codex\config.toml`
- macOS / Linux：`~/.codex/config.toml`

示例：

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

注意：新版 Codex CLI 可能要求：

```toml
wire_api = "responses"
```

如果你看到：

```text
wire_api = "chat" is no longer supported
```

把旧配置里的：

```toml
wire_api = "chat"
```

改成：

```toml
wire_api = "responses"
```

---

## 🎯 模型选择

```bash
codex                              # 使用 config 里的默认模型
codex --model gpt-5.5              # 推荐默认模型
codex --model gpt-4o-mini          # 低成本模型
codex --model claude-sonnet-4-6    # 通过 Crazyrouter 使用 Claude（取决于账户/线路支持）
```

模型是否可用可能随账户、供应商线路、模型状态变化。

使用前建议查看 Crazyrouter 模型列表：

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## 🧪 常用命令

### 进入交互模式

```bash
codex
```

### 指定模型

```bash
codex --model gpt-5.5
```

### 查看帮助

```bash
codex --help
```

### 在项目目录里启动

```bash
cd your-project
codex
```

---

## 🔒 安全模式说明

Codex CLI 的不同版本参数可能略有变化，可先用：

```bash
codex --help
```

查看当前版本支持的选项。

常见模式大致包括：

```bash
codex --approval-mode suggest      # 只给建议，更安全
codex --approval-mode auto-edit    # 可自动改文件，命令需确认
codex --approval-mode full-auto    # 更自动化，风险更高
```

建议新手先用保守模式，不要一上来就 full-auto。

---

## 🌐 Base URL 怎么选？

推荐默认使用：

```text
https://cn.crazyrouter.com/v1
```

如果你明确要使用 global endpoint，可以改成：

```text
https://crazyrouter.com/v1
```

两者都是 OpenAI-compatible endpoint。

**不要漏掉 `/v1`。**

错误示例：

```text
https://cn.crazyrouter.com
```

正确示例：

```text
https://cn.crazyrouter.com/v1
```

---

## 🛠️ 排错指南

### 1. Codex 找不到命令

如果你用的是新手完整模式，脚本会自动安装 Codex CLI。安装后如果新终端里仍然找不到 `codex`，先检查：

```bash
codex --version
```

检查是否安装成功：

```bash
npm list -g @openai/codex
```

如果没有，重新安装：

```bash
npm install -g @openai/codex
```

Windows 用户安装后通常需要重新打开 PowerShell；macOS / Linux 用户可以执行脚本最后提示的 `source ~/.zshrc`、`source ~/.bashrc` 或 `source ~/.profile`。

### 2. API Key 不生效

检查环境变量：

macOS / Linux：

```bash
echo $OPENAI_API_KEY
echo $OPENAI_BASE_URL
```

Windows PowerShell：

```powershell
echo $env:OPENAI_API_KEY
echo $env:OPENAI_BASE_URL
```

确认：

- API Key 是 Crazyrouter 控制台里的 key；
- Base URL 包含 `/v1`；
- 终端已经重启；
- 账户余额充足。

### 3. 模型不可用

换一个模型测试，例如：

```bash
codex --model gpt-5.5
```

或者到模型页确认模型名：

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

### 4. 500 / 502 / 524 错误

这类错误通常和上游模型、线路波动、超时、长上下文有关。

建议：

1. 重试一次；
2. 换一个相近模型；
3. 缩短 prompt；
4. 检查 Base URL；
5. 如果持续出现，把模型名、错误码、请求时间发给支持。

参考文章：

https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## ❓ 中文 FAQ

### Codex CLI 可以直接用 Crazyrouter 吗？

可以。Crazyrouter 提供 OpenAI-compatible endpoint，Codex CLI 只要支持自定义 OpenAI endpoint，就可以通过 Base URL 接入。

### `OPENAI_BASE_URL` 可以加 UTM 参数吗？

不可以。

错误：

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1?utm_source=github
```

正确：

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

### 可以用 Claude / Gemini / DeepSeek 吗？

可以通过 Crazyrouter 使用支持的非 OpenAI 模型，但具体可用性取决于账户、模型线路和 Codex CLI 当前兼容情况。

### 一定要用 `cn.crazyrouter.com` 吗？

不一定。默认推荐 `https://cn.crazyrouter.com/v1`，如果你更适合 global endpoint，也可以使用 `https://crazyrouter.com/v1`。

### Node.js 版本要求？

建议 Node.js 22+。

---

## 🔗 中文相关链接

- Crazyrouter：https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- 模型列表：https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Base URL 详解：https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- API 错误排查：https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Codex CLI：https://github.com/openai/codex
- Telegram：https://t.me/crzrouter

---

## 🇺🇸 English Guide

Run OpenAI Codex CLI through [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) with one command.

Crazyrouter provides an OpenAI-compatible API endpoint, so Codex CLI can use Crazyrouter by setting the API key and base URL.

> Important: API endpoints should **not** include UTM parameters. Use UTM only on human-facing links.

## 🚀 Two One-Click Modes

### Mode A: Switch An Existing Codex Install

Use this if `codex` is already installed and you only want to route Codex CLI through Crazyrouter. The script will:

- check that the `codex` command exists
- ask for your Crazyrouter API key and default model
- save `OPENAI_API_KEY` / `OPENAI_BASE_URL`
- update `~/.codex/config.toml` or `%USERPROFILE%\.codex\config.toml`
- back up your existing Codex config

Windows PowerShell:

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

### Mode B: Full Setup For New Users

Use this if you are starting from a fresh machine. The script will install/check:

- Git
- Node.js + npm
- OpenAI Codex CLI
- Crazyrouter API key and base URL
- Codex provider config
- a local test project directory

Windows PowerShell:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

Or download and double-click:

```text
install-crazyrouter-codex.bat
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

Full setup is the default mode. It is equivalent to:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

If you downloaded the Windows script locally, you can also choose a mode:

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

New users should run Mode B. Users who can already run `codex --version` can use Mode A.

## ⚡ Manual quick start

### 1. Install Codex CLI

The full setup mode installs Codex CLI automatically. For manual installation:

```bash
npm install -g @openai/codex
```

### 2. Set environment variables

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

Restart your terminal after using `setx`.

### 3. Run Codex

```bash
codex
```

## 🧩 Codex config.toml option

Some Codex versions support provider configuration in `%USERPROFILE%\.codex\config.toml` on Windows or `~/.codex/config.toml` on macOS/Linux.

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
A: Yes. Crazyrouter exposes an OpenAI-compatible endpoint. Use `https://cn.crazyrouter.com/v1` as the base URL.

**Q: Should I add UTM parameters to `OPENAI_BASE_URL`?**  
A: No. Never add UTM parameters to API endpoints. This is wrong:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1?utm_source=github
```

Use this instead:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

**Q: Codex says `wire_api = "chat" is no longer supported`. What should I do?**  
A: Update your Codex provider config to use the Responses API:

```toml
[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "https://cn.crazyrouter.com/v1"
env_key = "OPENAI_API_KEY"
wire_api = "responses"
```

If you installed with an older version of this script, edit your Codex config file and replace `wire_api = "chat"` with `wire_api = "responses"`.

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
