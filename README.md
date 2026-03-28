# Telegram to Obsidian

Save anything from your phone to Obsidian via Telegram. AI auto-summarizes, tags, and categorizes. Free.

**[繁體中文版](#繁體中文)**

---

## What It Does

```
You see something worth saving on your phone
  → Send to Telegram bot + say "save to ob"
  → AI processes it (summarize, tag, categorize)
  → Saved as structured markdown in your Obsidian vault
  → Synced via Dropbox/iCloud/Git
  → Want to find it later? Just ask the bot.
```

No need to open Obsidian. No need to sit at your computer. Just send and forget.

## What You Can Save

| Type | How to use | Example |
|------|-----------|---------|
| Articles | Copy the text, send + "save to ob" | Facebook posts, blog articles, news |
| URLs | Send the link + "save to ob" | Any web article link |
| YouTube videos | Send link + description, "save to ob" | Tutorial videos, talks |
| Tweets / Threads | Copy the thread text, send + "save to ob" | Twitter/X insights |
| Podcast notes | Type your takeaways, send + "save to ob" | Key points from episodes |
| Book highlights | Paste highlights, send + "save to ob" | Kindle highlights, reading notes |
| Quick ideas | Just type your thought, send + "save to ob" | Shower thoughts, business ideas |
| Meeting notes | Type or paste notes, send + "save to ob" | Action items, decisions |

## Find It Later

Don't remember where you saved something? Just ask:

- "Find my notes about AI" → searches your vault
- "What did I save about marketing last week?" → finds it
- "Show me that article about Dropbox CTO" → instant recall

## Features

- **AI-powered**: Auto-generates summary, tags, and category — not just raw copy-paste
- **Search & recall**: Ask the bot to find any saved note by keyword
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
  model: google/gemini-2.0-flash-001    # Free — can save, but weak on classification & summaries
  # model: anthropic/claude-sonnet-4-6  # Paid (~$0.01/article) — recommended, reliable tool use
  # model: meta-llama/llama-4-scout     # Free — may not support tool calling
```

> **Which model should I use?**
>
> | Model | Cost | Tool calling | Classification | Summary quality |
> |-------|------|-------------|---------------|----------------|
> | Gemini 2.0 Flash | Free | Works sometimes | Unreliable | Basic |
> | Claude Sonnet 4.6 | ~$0.01/article | Reliable | Accurate | High quality |
> | Llama 4 Scout/Maverick | Free | Doesn't work | N/A | N/A |
> | Local 7B models | Free | Doesn't work | N/A | N/A |
>
> **Recommendation:** Start with Gemini Flash (free) to test the setup. If you want reliable auto-classification and high-quality summaries, add $5 credit to OpenRouter and switch to Claude Sonnet.

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

# Telegram 存進 Obsidian

手機上看到任何值得存的東西，傳到 Telegram，AI 自動整理、分類、存進 Obsidian。免費。

## 可以存什麼？

| 類型 | 怎麼用 | 範例 |
|------|--------|------|
| 文章 | 複製內容，傳給 bot + 「存進 ob」 | FB 貼文、部落格、新聞 |
| 網址 | 傳連結 + 「存進 ob」 | 任何網頁文章連結 |
| YouTube 影片 | 傳連結 + 影片描述，「存進 ob」 | 教學影片、演講 |
| Twitter/X | 複製推文串，「存進 ob」 | 有價值的推文討論 |
| Podcast 筆記 | 打你的重點，「存進 ob」 | 節目重點整理 |
| 書摘 | 貼上劃線內容，「存進 ob」 | Kindle 劃線、讀書筆記 |
| 靈感 | 直接打字，「存進 ob」 | 突然想到的點子、商業構想 |
| 會議紀錄 | 打或貼筆記，「存進 ob」 | 行動項目、決策紀錄 |

## 之後找得到嗎？

直接問 bot 就好：

- 「幫我找 ob 裡關於 AI 的筆記」→ 搜尋你的 vault
- 「我之前存過一篇行銷的文章」→ 幫你找到
- 「那篇 Dropbox 技術長的文章在哪」→ 秒找

## 功能

- **AI 驅動**：自動摘要、標籤、分類，不是簡單複製貼上
- **搜尋回溯**：問 bot 就能找到任何存過的筆記
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
