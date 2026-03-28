# Telegram to Obsidian

Send articles from your phone via Telegram. AI summarizes, tags, and saves them to your Obsidian vault automatically. Free.

**[繁體中文版](#繁體中文)**

---

## What It Does

```
You see an article on your phone
  → Copy & send to Telegram bot
  → AI processes it (summarize, tag, categorize)
  → Saved as structured markdown in your Obsidian vault
  → Synced via Dropbox/iCloud/Git
```

No need to open Obsidian. No need to sit at your computer. Just send and forget.

## Features

- **AI-powered**: Auto-generates summary, tags, and category — not just raw copy-paste
- **Free AI model**: Uses Google Gemini Flash via OpenRouter (free tier)
- **PARA structure**: Auto-organizes into Projects / Areas / Resources / Archive
- **Works offline**: Runs on your own machine via Docker, your data stays local
- **Chinese optimized**: Built for Traditional/Simplified Chinese content (works with English too)
- **Phone-first**: Designed for the "I saw something interesting" moment

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌──────────────┐
│  Telegram    │────>│  OpenClaw    │────>│  OpenRouter  │────>│  Obsidian    │
│  (your phone)│     │  (Docker)    │     │  (Gemini AI) │     │  Vault       │
└─────────────┘     └──────────────┘     └─────────────┘     └──────────────┘
```

## Prerequisites

- Mac or Linux machine (always on, or at least when you send articles)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [OpenClaw](https://openclaw.ai) installed
- Telegram account
- Obsidian vault (any sync method: Dropbox, iCloud, Git, etc.)

## Quick Start

### 1. Clone this repo

```bash
git clone https://github.com/tzongen5168/telegram-to-obsidian.git
cd telegram-to-obsidian
```

### 2. Get your API keys

| Key | Where | Cost |
|-----|-------|------|
| Telegram Bot Token | [@BotFather](https://t.me/BotFather) | Free |
| OpenRouter API Key | [openrouter.ai](https://openrouter.ai) | Free |

### 3. Configure

```bash
cp .env.example .env
```

Edit `.env` with your keys:

```env
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
OPENROUTER_API_KEY=your_openrouter_api_key
OBSIDIAN_VAULT_PATH=/path/to/your/obsidian/vault
```

### 4. Set up Obsidian vault structure

```bash
./scripts/setup-vault.sh /path/to/your/obsidian/vault
```

This creates the PARA folder structure:

```
YourVault/
├── 00-Inbox/          # Default landing zone
├── 10-Projects/       # Active projects
├── 20-Areas/          # Ongoing areas of interest
├── 30-Resources/      # Reference materials & articles
├── 40-Archive/        # Completed/inactive items
└── 50-Templates/      # Note templates
```

### 5. Launch

```bash
docker compose up -d
```

### 6. Pair your Telegram

Message your bot on Telegram. It will ask for pairing. Approve it:

```bash
docker exec openclaw-gateway openclaw pairing list telegram
docker exec openclaw-gateway openclaw pairing approve telegram <CODE>
```

### 7. Start saving

Send any article text or link to your bot with the message:

> 存進 ob

or

> save to ob

Done. Check your Obsidian vault.

## Note Format

Every saved article follows this structure:

```markdown
---
title: Article Title
source: https://source-url.com
date: 2026-03-28
tags: [AI, productivity, tools]
category: 30-Resources/AI
---

## Key Insight
One-sentence core takeaway.

## Summary
- Point 1
- Point 2
- Point 3

## Personal Relevance
How this connects to your work/interests.
```

## Customization

### Change AI model

Edit `config/config.yaml`. Any OpenRouter model works:

```yaml
agent:
  model: google/gemini-2.0-flash-001    # Free
  # model: anthropic/claude-sonnet-4-6  # Paid, higher quality
  # model: meta-llama/llama-4-scout     # Free
```

### Add categories

Edit `config/workspace/skills/obsidian/SKILL.md` to add your own categories under the classification rules.

### Use local AI (no internet needed)

If you have [oMLX](https://github.com/nicobailon/omlx) and a capable local model (14B+):

```yaml
agent:
  model: your-local-model
  baseUrl: http://host.docker.internal:8000/v1
```

Note: Models smaller than 14B may hallucinate instead of actually executing commands.

## Troubleshooting

### Bot says "LLM request timed out"
Your AI model isn't running. Check that Docker is up and the model provider is reachable.

### Bot says "I can't execute commands" / simulates results
The `tools.profile` in `openclaw.json` must be `"full"`. See [config/openclaw.json](config/openclaw.json).

### Bot responds but doesn't actually save files
Check that:
1. The Obsidian vault is mounted in Docker (`docker exec openclaw-gateway ls /obsidian/`)
2. Exec approvals are set up (`docker exec openclaw-gateway openclaw approvals get`)

### 404 status code
The AI model isn't found. Verify your API key and model name in `config.yaml`.

## How It Works (Technical)

1. **Telegram** receives your message via the bot
2. **OpenClaw** (agent framework) routes it to the AI model
3. **Gemini Flash** (via OpenRouter) processes the content:
   - Extracts key information
   - Generates summary and tags
   - Determines the right category
4. **OpenClaw exec tool** writes a `.md` file to the mounted Obsidian vault
5. **Dropbox/iCloud/Git** syncs it to your devices

The key insight: OpenClaw's `tools.profile: "full"` enables the AI to execute real shell commands (like `cat > /obsidian/...`), not just chat. This is what makes actual file creation possible.

## Lessons Learned

Building this, we discovered:
- Small local models (7B) **cannot reliably** use tools — they hallucinate command output instead of executing
- OpenRouter's free Gemini Flash is surprisingly capable for this task
- OpenClaw needs `tools.profile: "full"` AND the OpenRouter provider must be the **bundled plugin** (not a manual `openai-completions` provider) for tool calling to work
- The `exec-approvals` allowlist alone doesn't enable tools — the model needs the tool definitions passed to it

## License

MIT

---

<a name="繁體中文"></a>

## 繁體中文

# Telegram 存文章到 Obsidian

用手機 Telegram 傳文章，AI 自動整理、分類、存進 Obsidian。免費。

## 功能

- **AI 驅動**：自動摘要、標籤、分類，不是簡單複製貼上
- **免費 AI**：使用 Google Gemini Flash（透過 OpenRouter 免費額度）
- **PARA 結構**：自動歸類到 Projects / Areas / Resources / Archive
- **資料在地**：透過 Docker 在你的電腦上運行，資料不外傳
- **中文優化**：專為繁體/簡體中文內容設計
- **手機優先**：為「看到好文章想存起來」的瞬間設計

## 快速開始

### 1. 取得 API Key

| Key | 取得位置 | 費用 |
|-----|---------|------|
| Telegram Bot Token | [@BotFather](https://t.me/BotFather) | 免費 |
| OpenRouter API Key | [openrouter.ai](https://openrouter.ai) | 免費 |

### 2. 設定

```bash
git clone https://github.com/tzongen5168/telegram-to-obsidian.git
cd telegram-to-obsidian
cp .env.example .env
# 編輯 .env 填入你的 API key
```

### 3. 建立 Obsidian 資料夾結構

```bash
./scripts/setup-vault.sh /path/to/your/obsidian/vault
```

### 4. 啟動

```bash
docker compose up -d
```

### 5. 配對 Telegram

在 Telegram 私訊你的 bot，然後核准配對：

```bash
docker exec openclaw-gateway openclaw pairing list telegram
docker exec openclaw-gateway openclaw pairing approve telegram <CODE>
```

### 6. 開始使用

傳文章給 bot，說「存進 ob」，就會自動存進你的 Obsidian。

## 常見問題

### 可以用手機的 Claude App 存嗎？
可以，用 Dispatch 功能連到你 Mac 上的 Claude Code，說「存進 ob」。但這需要 Mac 保持開啟且 Claude Code 運行中。

### 7B 模型夠嗎？
不夠。7B 模型會幻覺（假裝執行指令但實際沒有寫入檔案）。建議用 Gemini Flash（免費）或 14B 以上的本地模型。

### 免費模型有限制嗎？
OpenRouter 的 Gemini Flash 有每分鐘請求數限制，但日常存文章完全夠用。
