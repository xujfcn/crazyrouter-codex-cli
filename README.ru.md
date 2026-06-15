<div align="center">

# Использование OpenAI Codex CLI с Crazyrouter

**Подключите Codex CLI к Crazyrouter и используйте поддерживаемые модели через OpenAI-совместимый API.**

[English](./README.en.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Русский](./README.ru.md)

![OpenAI Compatible](https://img.shields.io/badge/API-OpenAI%20compatible-111111?style=flat-square)
![Codex CLI](https://img.shields.io/badge/Tool-Codex%20CLI-111111?style=flat-square)
![Base URL](https://img.shields.io/badge/Base%20URL-%2Fv1-2563eb?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-111111?style=flat-square)

</div>

---

## Кратко

| Пункт | Значение |
| --- | --- |
| Цель | Подключить OpenAI Codex CLI к [Crazyrouter](https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community) |
| Формат API | OpenAI-compatible |
| Рекомендуемый Base URL | `https://cn.crazyrouter.com/v1` |
| Что нужно настроить | `OPENAI_API_KEY`, `OPENAI_BASE_URL`, имя модели |
| Важное правило | Не добавляйте UTM-параметры в `OPENAI_BASE_URL` |

---

## Выберите Способ Установки

| Ситуация | Рекомендуемый режим |
| --- | --- |
| `codex --version` уже работает | Режим A: переключить существующий Codex CLI на Crazyrouter |
| Новый компьютер или Codex CLI еще не установлен | Режим B: полная установка одной командой |
| Вы не хотите запускать скрипты | Ручная настройка |

---

## Режим A: Codex CLI Уже Установлен, Нужно Переключиться На Crazyrouter

Используйте этот режим, если `codex` уже установлен и нужно только направить Codex CLI через Crazyrouter. Скрипт:

- проверит наличие команды `codex`;
- запросит Crazyrouter API key;
- запросит модель по умолчанию;
- запишет `OPENAI_API_KEY` и `OPENAI_BASE_URL`;
- обновит Codex `config.toml`;
- автоматически создаст резервную копию текущей конфигурации.

Windows PowerShell:

```powershell
$env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --switch
```

---

## Режим B: Полная Установка Для Новых Пользователей

Используйте этот режим на чистой машине. Скрипт автоматически установит или проверит:

- Git;
- Node.js + npm;
- OpenAI Codex CLI;
- Crazyrouter API key и Base URL;
- конфигурацию provider для Codex;
- локальную директорию проекта для тестирования.

Windows PowerShell:

```powershell
iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
```

Также можно скачать файл и запустить двойным щелчком:

```text
install-crazyrouter-codex.bat
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash
```

Полная установка является режимом по умолчанию и эквивалентна:

```bash
curl -fsSL https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.sh | bash -s -- --full
```

Если Windows-скрипт скачан локально, режим можно указать явно:

```powershell
.\install-crazyrouter-codex.ps1 -Mode full
.\install-crazyrouter-codex.ps1 -Mode switch
```

---

## Ручная Настройка

### 1. Установите Codex CLI

Режим полной установки устанавливает Codex CLI автоматически. Для ручной установки:

```bash
npm install -g @openai/codex
```

Рекомендуется Node.js 22+. Если вы используете nvm:

```bash
nvm install 22
nvm use 22
```

### 2. Задайте Переменные Окружения

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

После `setx` в Windows заново откройте терминал.

### 3. Запустите Codex

```bash
codex
```

---

## Постоянная Конфигурация

### macOS / Linux

Если вы используете zsh:

```bash
cat >> ~/.zshrc << 'CONF'
# Codex CLI via Crazyrouter
export OPENAI_API_KEY=sk-your-crazyrouter-key
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
CONF
source ~/.zshrc
```

Если вы используете Bash, добавьте те же строки в `~/.bashrc`.

### Windows PowerShell

```powershell
setx OPENAI_API_KEY "sk-your-crazyrouter-key"
setx OPENAI_BASE_URL "https://cn.crazyrouter.com/v1"
```

---

## Пример Codex config.toml

Путь к конфигурации:

- Windows: `%USERPROFILE%\.codex\config.toml`
- macOS / Linux: `~/.codex/config.toml`

Пример:

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

Если вы видите:

```text
wire_api = "chat" is no longer supported
```

замените:

```toml
wire_api = "chat"
```

на:

```toml
wire_api = "responses"
```

---

## Выбор Модели

```bash
codex                              # модель по умолчанию из config
codex --model gpt-5.5              # пример модели по умолчанию
codex --model gpt-4o-mini          # пример более дешевой модели
codex --model claude-sonnet-4-6    # пример Claude, зависит от аккаунта и поддержки маршрута
```

Доступность моделей зависит от аккаунта Crazyrouter, включенных маршрутов, статуса upstream-моделей и текущей совместимости Codex CLI. Перед использованием проверьте список моделей:

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## Проверка Настройки

```bash
codex --version
codex --help
```

Запустите Codex в директории проекта:

```bash
cd your-project
codex
```

Параметры Codex CLI могут отличаться между версиями. Используйте `codex --help` как источник актуальных опций для вашей установленной версии.

---

## Какой Base URL Использовать?

Рекомендуемый вариант по умолчанию:

```text
https://cn.crazyrouter.com/v1
```

Если вам явно нужен global endpoint:

```text
https://crazyrouter.com/v1
```

Не пропускайте `/v1`.

Неправильно:

```text
https://cn.crazyrouter.com
```

Правильно:

```text
https://cn.crazyrouter.com/v1
```

---

## Устранение Неполадок

### 1. Команда `codex` Не Найдена

Проверьте:

```bash
codex --version
npm list -g @openai/codex
```

Если Codex CLI не установлен:

```bash
npm install -g @openai/codex
```

Пользователям Windows обычно нужно заново открыть PowerShell после установки. Пользователи macOS / Linux могут выполнить команду `source ~/.zshrc`, `source ~/.bashrc` или `source ~/.profile`, которую покажет скрипт.

### 2. API Key Не Работает

Проверьте переменные окружения.

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

Убедитесь, что:

- API key взят из консоли Crazyrouter;
- Base URL содержит `/v1`;
- терминал был перезапущен;
- на аккаунте достаточно баланса.

### 3. Модель Недоступна

Попробуйте другую модель:

```bash
codex --model gpt-5.5
```

Или проверьте имя модели на странице моделей:

https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community

### 4. Ошибки 500 / 502 / 524

Такие ошибки обычно связаны с upstream-моделями, нестабильностью маршрута, таймаутами или длинным контекстом.

Рекомендуемые действия:

1. Повторите запрос один раз.
2. Переключитесь на похожую модель.
3. Сократите prompt.
4. Проверьте Base URL.
5. Если проблема сохраняется, отправьте в поддержку имя модели, код ошибки и время запроса.

Справочная статья:

https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community

---

## FAQ

### Можно ли использовать Codex CLI напрямую с Crazyrouter?

Да. Crazyrouter предоставляет OpenAI-совместимый endpoint. Если Codex CLI поддерживает пользовательский OpenAI endpoint, он может подключаться через Base URL.

### Можно ли добавить UTM-параметры в `OPENAI_BASE_URL`?

Нет.

Неправильно:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1?utm_source=github
```

Правильно:

```bash
export OPENAI_BASE_URL=https://cn.crazyrouter.com/v1
```

### Можно ли использовать Claude / Gemini / DeepSeek / Qwen?

Да. Через Crazyrouter можно использовать поддерживаемые не-OpenAI модели, но доступность зависит от аккаунта, маршрутов модели и текущей совместимости Codex CLI.

### Обязательно ли использовать `cn.crazyrouter.com`?

Нет. `https://cn.crazyrouter.com/v1` рекомендуется по умолчанию. Если global endpoint подходит лучше, используйте `https://crazyrouter.com/v1`.

### Требования к версии Node.js?

Рекомендуется Node.js 22+.

---

## Ссылки

- Crazyrouter: https://crazyrouter.com?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Список моделей: https://crazyrouter.com/models?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Объяснение Base URL: https://crazyrouter.com/blog/openai-compatible-api-base-url-explained?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Устранение API-ошибок: https://crazyrouter.com/blog/how-to-fix-ai-api-500-502-524-errors?utm_source=github&utm_medium=github&utm_campaign=dev_community
- Codex CLI: https://github.com/openai/codex
- Telegram: https://t.me/crzrouter

## Лицензия

MIT
