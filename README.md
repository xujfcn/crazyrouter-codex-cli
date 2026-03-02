# ⚡ Use OpenAI Codex CLI with Crazyrouter

> **Save 45% on Codex CLI costs** — Route through Crazyrouter for cheaper API access.

[Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community?ref=github) — One API key, 300+ models, 45% cheaper.

## 💰 Price Comparison

| Model | Official (In/Out per 1M) | Crazyrouter | Savings |
|-------|--------------------------|-------------|---------|
| GPT-4o | $2.50 / $10 | $1.38 / $5.50 | **45%** |
| o3-mini | $1.10 / $4.40 | $0.61 / $2.42 | **45%** |
| GPT-4o-mini | $0.15 / $0.60 | $0.08 / $0.33 | **45%** |

## ⚡ Quick Start

### 1. Install Codex CLI
```bash
npm install -g @openai/codex
```

### 2. Configure Crazyrouter
```bash
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community/v1
```

### 3. Run
```bash
codex
```

## 🔧 Persistent Config

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community/v1
CONF
source ~/.zshrc
```

## 🎯 Model Selection

```bash
codex                              # Default: GPT-4o
codex --model o3-mini              # Cheaper reasoning
codex --model gpt-4o-mini          # Budget option
codex --model claude-sonnet-4-20250514  # Claude via Crazyrouter
```

## 🔒 Safety Modes

```bash
codex --approval-mode suggest      # Read-only suggestions
codex --approval-mode auto-edit    # Auto-edit, confirm commands
codex --approval-mode full-auto    # Full autonomous mode
```

## ❓ FAQ

**Q: Does Codex CLI work with Crazyrouter?**
A: Yes, 100% compatible. Just set `OPENAI_BASE_URL`.

**Q: Can I use non-OpenAI models?**
A: Yes! Through Crazyrouter you can use Claude, Gemini, Llama, etc.

**Q: Node.js version requirement?**
A: Node.js 22+ required. Use `nvm install 22` if needed.

## 🔗 Links
- 🌐 [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community?ref=github) | 📦 [Codex CLI](https://github.com/openai/codex) | 💬 [Telegram](https://t.me/crzrouter)

## 📄 License
MIT
