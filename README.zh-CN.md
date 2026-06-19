<div align="center">

# 使用 Crazyrouter 运行 OpenAI Codex CLI

**几分钟内把 Codex CLI 接入 Crazyrouter，通过 OpenAI-compatible API 使用 Crazyrouter 支持的模型。**

[English](./README.en.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Русский](./README.ru.md)

![OpenAI Compatible](https://img.shields.io/badge/API-OpenAI%20compatible-111111?style=flat-square)
![Codex CLI](https://img.shields.io/badge/Tool-Codex%20CLI-111111?style=flat-square)
![Base URL](https://img.shields.io/badge/Base%20URL-%2Fv1-2563eb?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-111111?style=flat-square)

</div>

---

## 快速理解

| 项目 | 说明 |
| --- | --- |
| 项目目标 | 把 OpenAI Codex CLI 接入 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) |
| API 形态 | OpenAI-compatible |
| 推荐 Base URL | `https://cn.crazyrouter.com/v1` |
| 需要配置 | `OPENAI_API_KEY`、`OPENAI_BASE_URL`、模型名 |
| 重要规则 | `OPENAI_BASE_URL` 不能添加 UTM 参数 |

---

## 选择你的安装路径

| 场景 | 推荐模式 |
| --- | --- |
| 已经可以运行 `codex --version` | 模式 A：只切换到 Crazyrouter |
| 新电脑或没有安装 Codex CLI | 模式 B：完整一键安装 |
| 不想运行脚本 | 手动配置 |

---

## 模式 A：已有 Codex，只切换到 Crazyrouter

适合已经安装过 `codex`、只想把 Codex CLI 的访问地址切到 Crazyrouter 的用户。脚本会：

- 检查 `codex` 命令是否存在；
- 询问 Crazyrouter API Key；
- 询问默认模型名；
- 写入 `OPENAI_API_KEY` 和 `OPENAI_BASE_URL`；
- 更新 Codex 的 `config.toml`；
- 自动备份已有配置。

Windows PowerShell：

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

---

## 模式 B：新用户完整一键安装

适合没有安装环境的新用户。脚本会自动安装或检查：

- Git；
- Node.js + npm；
- OpenAI Codex CLI；
- Crazyrouter API Key 和 Base URL；
- Codex provider 配置；
- 一个用于测试的本地项目目录。

Windows PowerShell：

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

也可以下载后双击：

```text
install-crazyrouter-codex.bat
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

完整安装是默认模式，等同于：

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

如果已经把 Windows 脚本下载到本地，也可以这样指定模式：

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

---

## 手动配置

### 1. 安装 Codex CLI

完整安装模式会自动安装 Codex CLI。手动安装可以使用：

```bash
npm install -g @openai/codex
```

建议使用 Node.js 22+。如果你使用 nvm：

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

## 持久化配置

### macOS / Linux

如果使用 zsh：

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
CONF
source ~/.zshrc
```

如果使用 Bash，把同样内容写入 `~/.bashrc`。

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

---

## Codex config.toml 示例

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

如果看到类似下面的错误：

```text
wire_api = "chat" is no longer supported
```

把旧配置中的：

```toml
wire_api = "chat"
```

改成：

```toml
wire_api = "responses"
```

---

## 模型选择

```bash
codex                              # 使用 config 中的默认模型
codex --model gpt-5.5              # 示例默认模型
codex --model gpt-4o-mini          # 示例低成本模型
codex --model claude-sonnet-4-6    # 示例 Claude 模型，取决于账户和线路支持
```

模型是否可用取决于 Crazyrouter 账户、模型线路、上游状态和当前 Codex CLI 兼容性。使用前建议查看模型列表：

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## 验证是否成功

```bash
codex --version
codex --help
```

进入项目目录后启动：

```bash
cd your-project
codex
```

Codex CLI 的命令行参数可能随版本变化，具体可用选项以 `codex --help` 为准。

---

## Base URL 怎么选？

推荐默认使用：

```text
https://cn.crazyrouter.com/v1
```

如果你明确想使用 global endpoint：

```text
https://crazyrouter.com/v1
```

不要漏掉 `/v1`。

错误：

```text
https://cn.crazyrouter.com
```

正确：

```text
https://cn.crazyrouter.com/v1
```

---

## 排错

### 1. 找不到 `codex` 命令

先检查：

```bash
codex --version
npm list -g @openai/codex
```

如果没有安装：

```bash
npm install -g @openai/codex
```

Windows 用户安装后通常需要重新打开 PowerShell。macOS / Linux 用户可以执行脚本最后提示的 `source ~/.zshrc`、`source ~/.bashrc` 或 `source ~/.profile`。

### 2. macOS 提示无法自动安装 Node.js

如果完整安装模式提示无法自动安装 Node.js，可以任选一种方式手动安装 Node.js 22+，然后重新打开终端再运行安装脚本。

官方安装包：

```text
https://nodejs.org/en/download
```

使用 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node
```

使用 nvm：

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.zshrc
nvm install 22
nvm use 22
```

确认安装成功：

```bash
node --version
npm --version
```

### 3. API Key 不生效

检查环境变量。

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

- API Key 来自 Crazyrouter 控制台；
- Base URL 包含 `/v1`；
- 终端已经重启；
- 账户余额充足。

### 4. 模型不可用

换一个模型测试：

```bash
codex --model gpt-5.5
```

或到模型页确认模型名：

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

### 5. 500 / 502 / 524 错误

这类错误通常与上游模型、线路波动、超时或长上下文有关。建议：

1. 重试一次。
2. 切换到相近模型。
3. 缩短 prompt。
4. 检查 Base URL。
5. 如果持续出现，把模型名、错误码和请求时间发给支持。

参考文章：

https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## FAQ

### Codex CLI 可以直接使用 Crazyrouter 吗？

可以。Crazyrouter 提供 OpenAI-compatible endpoint。只要 Codex CLI 支持自定义 OpenAI endpoint，就可以通过 Base URL 接入。

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

### 可以使用 Claude / Gemini / DeepSeek / Qwen 吗？

可以通过 Crazyrouter 使用支持的非 OpenAI 模型，但具体可用性取决于账户、模型线路和 Codex CLI 当前兼容情况。

### 一定要使用 `cn.crazyrouter.com` 吗？

不一定。默认推荐 `https://cn.crazyrouter.com/v1`。如果 global endpoint 更适合你，也可以使用 `https://crazyrouter.com/v1`。

### Node.js 版本要求是什么？

建议 Node.js 22+。

---

## 相关链接

- Crazyrouter：https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- 模型列表：https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Base URL 详解：https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- API 错误排查：https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Codex CLI：https://github.com/openai/codex
- Telegram：https://t.me/crzrouter

## License

MIT
