<div align="center">

# Crazyrouter Codex CLI

**Run OpenAI Codex CLI through Crazyrouter with a clean one-command setup for Windows, macOS, and Linux.**

[English](./README.en.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Русский](./README.ru.md)

![OpenAI Compatible](https://img.shields.io/badge/API-OpenAI%20compatible-111111?style=flat-square)
![Codex CLI](https://img.shields.io/badge/Tool-Codex%20CLI-111111?style=flat-square)
![Windows](https://img.shields.io/badge/Windows-PowerShell-2563eb?style=flat-square)
![macOS Linux](https://img.shields.io/badge/macOS%20%2F%20Linux-Bash-16a34a?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-111111?style=flat-square)

</div>

---

## Project In Four Languages

| Language | Introduction |
| --- | --- |
| 中文 | 本项目帮助你把 OpenAI Codex CLI 快速连接到 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community)，并通过 Crazyrouter 的 OpenAI-compatible API 调用支持的模型。 |
| 日本語 | OpenAI Codex CLI を [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) に接続し、Crazyrouter の OpenAI-compatible API 経由で対応モデルを利用できます。 |
| Русский | Проект помогает подключить OpenAI Codex CLI к [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) и использовать модели Crazyrouter через OpenAI-совместимый API. |
| English | Connect OpenAI Codex CLI to [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community), then use Crazyrouter-supported models through an OpenAI-compatible API. |

---

## Choose Your Guide

| Language | Full guide |
| --- | --- |
| English | [README.en.md](./README.en.md) |
| 简体中文 | [README.zh-CN.md](./README.zh-CN.md) |
| 日本語 | [README.ja.md](./README.ja.md) |
| Русский | [README.ru.md](./README.ru.md) |

---

## What You Get

| Need | Included file or flow |
| --- | --- |
| Windows installer | `install-crazyrouter-codex.ps1` |
| Windows double-click entry | `install-crazyrouter-codex.bat` |
| macOS / Linux installer | `install-crazyrouter-codex.sh` |
| Existing Codex CLI users | Switch mode, config backup, Crazyrouter provider rewrite |
| New users | Full setup for Git, Node.js, Codex CLI, environment variables, test project |

The scripts write a consistent OpenAI-compatible Base URL:

```text
https://cn.crazyrouter.com/v1
```

Do not add UTM parameters to API endpoints. UTM parameters are only for links opened by people.

---

## Fast Start

### Existing Codex CLI, Switch To Crazyrouter

Windows PowerShell:

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

### New Machine, Full Setup

Windows PowerShell:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

---

## Configuration Written By The Scripts

The scripts ask for your Crazyrouter API key and preferred model, then configure:

```text
OPENAI_API_KEY=your-crazyrouter-api-key
OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

They also write a Codex provider block similar to:

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

Codex CLI options can change between versions. After installation, run:

```bash
codex --help
```

---

## Important Notes

- Keep `/v1` in the Base URL.
- Do not use tracking parameters in `OPENAI_BASE_URL`.
- Node.js 22+ is recommended for Codex CLI.
- Model availability depends on your Crazyrouter account, enabled routes, and upstream model status.
- If the script finds an existing Codex config, it creates a timestamped backup first.

---

## Useful Links

- Crazyrouter: https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Crazyrouter model list: https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- OpenAI-compatible Base URL explanation: https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- API error troubleshooting: https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- OpenAI Codex CLI: https://github.com/openai/codex
- Telegram: https://t.me/crzrouter

---

## Use gpt-5.5-pro

`gpt-5.5-pro` is the higher-capability Pro model. Select it in any of these ways.

1. One-off run, without changing config:

```bash
codex --model gpt-5.5-pro
```

2. Set it as the default in `config.toml`:

```toml
model = "gpt-5.5-pro"
model_provider = "crazyrouter"
```

3. When running the installer, enter `gpt-5.5-pro` at the default model name step.

4. Switch inside a running session with the `/model` command (depending on your Codex CLI version).

Availability depends on your Crazyrouter account, enabled routes, and upstream status. Confirm the exact name on the [model list](https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community) if you get a model error. Per-language guides: [English](./README.en.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Русский](./README.ru.md).

## License

MIT
