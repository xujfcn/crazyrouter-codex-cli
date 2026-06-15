# Crazyrouter で OpenAI Codex CLI を使う

言語: [English](./README.en.md) | [简体中文](./README.zh-CN.md) | [日本語](./README.ja.md) | [Русский](./README.ru.md)

このガイドでは、OpenAI Codex CLI を [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) に接続する方法を説明します。Crazyrouter は OpenAI-compatible API を提供しているため、Codex CLI では通常、API key、Base URL、モデル名を設定するだけで利用できます。

推奨 Base URL:

```text
https://cn.crazyrouter.com/v1
```

`OPENAI_BASE_URL` に UTM パラメータを追加しないでください。UTM は人がクリックする Web リンク用であり、API endpoint には使いません。

---

## どのモードを選ぶべきか

| 状況 | 推奨モード |
| --- | --- |
| すでに `codex --version` が動く | モード A: 既存の Codex CLI を Crazyrouter に切り替える |
| 新しい環境、または Codex CLI 未インストール | モード B: フルセットアップ |
| スクリプトを実行したくない | 手動セットアップ |

---

## モード A: 既存の Codex CLI を Crazyrouter に切り替える

`codex` がすでにインストール済みで、接続先だけを Crazyrouter にしたい場合に使います。スクリプトは次を行います。

- `codex` コマンドが存在するか確認;
- Crazyrouter API key を確認;
- デフォルトモデル名を確認;
- `OPENAI_API_KEY` と `OPENAI_BASE_URL` を書き込み;
- Codex の `config.toml` を更新;
- 既存設定を自動バックアップ。

Windows PowerShell:

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

---

## モード B: 新規ユーザー向けフルセットアップ

新しい環境から始める場合に使います。スクリプトは自動で次をインストールまたは確認します。

- Git;
- Node.js + npm;
- OpenAI Codex CLI;
- Crazyrouter API key と Base URL;
- Codex provider 設定;
- テスト用のローカルプロジェクトディレクトリ。

Windows PowerShell:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

ダウンロードしてダブルクリックすることもできます。

```text
install-crazyrouter-codex.bat
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

フルセットアップがデフォルトで、次と同じです。

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

Windows スクリプトをローカルにダウンロードした場合は、モードを明示できます。

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

---

## 手動セットアップ

### 1. Codex CLI をインストール

フルセットアップでは Codex CLI が自動でインストールされます。手動でインストールする場合:

```bash
npm install -g @openai/codex
```

Node.js 22+ を推奨します。nvm を使う場合:

```bash
nvm install 22
nvm use 22
```

### 2. 環境変数を設定

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

Windows で `setx` を使った後は、ターミナルを開き直してください。

### 3. Codex を起動

```bash
codex
```

---

## 永続設定

### macOS / Linux

zsh の場合:

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
CONF
source ~/.zshrc
```

Bash の場合は、同じ内容を `~/.bashrc` に書き込みます。

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

---

## Codex config.toml の例

設定パス:

- Windows: `%USERPROFILE%\.codex\config.toml`
- macOS / Linux: `~/.codex/config.toml`

例:

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

次のエラーが出た場合:

```text
wire_api = "chat" is no longer supported
```

古い設定の:

```toml
wire_api = "chat"
```

を次に変更してください。

```toml
wire_api = "responses"
```

---

## モデル選択

```bash
codex                              # config のデフォルトモデルを使用
codex --model gpt-5.5              # デフォルトモデルの例
codex --model gpt-4o-mini          # 低コストモデルの例
codex --model claude-sonnet-4-6    # Claude モデルの例。アカウントとルート対応状況による
```

モデルの利用可否は、Crazyrouter アカウント、モデルルート、上流モデルの状態、現在の Codex CLI 互換性によって変わります。利用前にモデル一覧を確認してください。

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## セットアップ確認

```bash
codex --version
codex --help
```

プロジェクトディレクトリで起動:

```bash
cd your-project
codex
```

Codex CLI のオプションはバージョンによって変わる場合があります。利用可能なオプションは `codex --help` で確認してください。

---

## どの Base URL を使うべきか

推奨デフォルト:

```text
https://cn.crazyrouter.com/v1
```

global endpoint を明示的に使いたい場合:

```text
https://crazyrouter.com/v1
```

`/v1` を省略しないでください。

誤り:

```text
https://cn.crazyrouter.com
```

正しい例:

```text
https://cn.crazyrouter.com/v1
```

---

## トラブルシューティング

### 1. `codex` コマンドが見つからない

確認:

```bash
codex --version
npm list -g @openai/codex
```

Codex CLI が未インストールの場合:

```bash
npm install -g @openai/codex
```

Windows ユーザーは通常、インストール後に PowerShell を開き直す必要があります。macOS / Linux ユーザーは、スクリプト末尾に表示される `source ~/.zshrc`、`source ~/.bashrc`、または `source ~/.profile` を実行してください。

### 2. API Key が効かない

環境変数を確認します。

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

確認項目:

- API key が Crazyrouter コンソールの key である;
- Base URL に `/v1` が含まれている;
- ターミナルを再起動している;
- アカウント残高が十分にある。

### 3. モデルが利用できない

別のモデルを試します。

```bash
codex --model gpt-5.5
```

または、モデルページでモデル名を確認してください。

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

### 4. 500 / 502 / 524 エラー

これらのエラーは通常、上流モデル、ルートの不安定さ、タイムアウト、長いコンテキストに関係します。

推奨手順:

1. 一度リトライする。
2. 近いモデルに切り替える。
3. prompt を短くする。
4. Base URL を確認する。
5. 継続する場合は、モデル名、エラーコード、リクエスト時刻をサポートに送る。

参考:

https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## FAQ

### Codex CLI は Crazyrouter を直接使えますか?

はい。Crazyrouter は OpenAI-compatible endpoint を提供しています。Codex CLI がカスタム OpenAI endpoint をサポートしていれば、Base URL 経由で接続できます。

### `OPENAI_BASE_URL` に UTM パラメータを付けてもよいですか?

いいえ。

誤り:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1?utm_source=github
```

正しい例:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

### Claude / Gemini / DeepSeek / Qwen は使えますか?

はい。Crazyrouter 経由で対応する非 OpenAI モデルを使えます。ただし、利用可否はアカウント、モデルルート、現在の Codex CLI 互換性によって異なります。

### 必ず `cn.crazyrouter.com` を使う必要がありますか?

いいえ。`https://cn.crazyrouter.com/v1` をデフォルトとして推奨しますが、global endpoint の方が適している場合は `https://crazyrouter.com/v1` を使えます。

### Node.js のバージョン要件は?

Node.js 22+ を推奨します。

---

## リンク

- Crazyrouter: https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- モデル一覧: https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Base URL の解説: https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- API エラーのトラブルシューティング: https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Codex CLI: https://github.com/openai/codex
- Telegram: https://t.me/crzrouter

## License

MIT
