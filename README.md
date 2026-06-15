# Crazyrouter Codex CLI

Languages: [English](./README.en.md) | [简体中文](./README.zh-CN.md) | [日本語](./README.ja.md) | [Русский](./README.ru.md)

## Multilingual Introduction

**中文**

本项目帮助你把 OpenAI Codex CLI 快速连接到 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community)。你可以使用 Crazyrouter 的 OpenAI-compatible API，在 Codex CLI 中调用 Crazyrouter 支持的模型。仓库提供 Windows、macOS、Linux 的一键脚本，也提供手动配置说明，适合新用户安装，也适合已有 Codex CLI 的用户切换 Base URL。

**日本語**

このプロジェクトは、OpenAI Codex CLI を [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) にすばやく接続するためのセットアップガイドとスクリプトです。Crazyrouter の OpenAI-compatible API を使い、Codex CLI から Crazyrouter 対応モデルを利用できます。Windows、macOS、Linux 向けのワンクリックスクリプトと手動設定手順を用意しています。

**Русский**

Этот проект помогает быстро подключить OpenAI Codex CLI к [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community). Через OpenAI-совместимый API Crazyrouter вы можете использовать в Codex CLI модели, доступные в Crazyrouter. Репозиторий содержит скрипты установки для Windows, macOS и Linux, а также инструкции для ручной настройки.

**English**

This project helps you connect OpenAI Codex CLI to [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community). Crazyrouter provides an OpenAI-compatible API, so Codex CLI can use Crazyrouter-supported models by setting an API key, a Base URL, and a model name. The repository includes one-command scripts for Windows, macOS, and Linux, plus manual setup instructions.

---

## Choose Your Guide

| Language | Full guide |
| --- | --- |
| English | [README.en.md](./README.en.md) |
| 简体中文 | [README.zh-CN.md](./README.zh-CN.md) |
| 日本語 | [README.ja.md](./README.ja.md) |
| Русский | [README.ru.md](./README.ru.md) |

---

## What This Repository Provides

- Windows PowerShell installer: `install-crazyrouter-codex.ps1`
- Windows double-click launcher: `install-crazyrouter-codex.bat`
- macOS / Linux installer: `install-crazyrouter-codex.sh`
- Two setup modes:
  - **Full setup**: install or check Git, Node.js, Codex CLI, then configure Crazyrouter.
  - **Switch mode**: keep your existing Codex CLI installation and only switch it to Crazyrouter.
- Codex config backup before rewriting `config.toml`.
- A consistent OpenAI-compatible Base URL:

```text
https://cn.crazyrouter.com/v1
```

Do not add UTM parameters to API endpoints. UTM parameters are only for web links opened by people.

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

## License

MIT
