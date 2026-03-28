---
name: obsidian
description: 讀寫 Ken哥的 Obsidian 第二大腦。存入文章筆記、搜尋現有內容、列出資料夾。當 Ken哥 說「存進 ob」、「去 ob 找」、「ob 裡有沒有」時使用。
metadata:
  {
    "openclaw": {
      "emoji": "📓",
      "requires": { "bins": ["bash", "grep", "find"] }
    }
  }
---

# obsidian — 第二大腦技能

Obsidian Vault 掛載在容器內 `/obsidian/`，使用 shell 指令直接讀寫 `.md` 檔案。

## 資料夾結構（PARA）

```
/obsidian/
├── 00-Inbox/        預設收件匣，不確定分類時存這裡
├── 10-Projects/     進行中的專案筆記
├── 20-Areas/        AI自動化、業務接案、自媒體、電子書
├── 30-Resources/    AI趨勢、商業策略、技術筆記、行銷
├── 40-Archive/      封存
└── 50-Templates/    範本
```

## 分類規則（必須遵守，禁止全部丟 00-Inbox）

收到內容後，你必須先判斷分類，再存入對應資料夾。**嚴禁偷懶全部存到 00-Inbox。**

| 關鍵字 / 主題 | 存入路徑 |
|---|---|
| AI、機器學習、LLM、GPT、Claude、自動化、agent | `30-Resources/AI趨勢/` |
| 商業模式、創業、管理、融資、startup | `30-Resources/商業策略/` |
| 程式、coding、API、框架、Docker、技術工具 | `30-Resources/技術筆記/` |
| 行銷、marketing、SEO、社群、廣告、品牌、內容策略 | `30-Resources/行銷/` |
| 正在進行的專案相關內容 | `10-Projects/` |
| 真的無法判斷時（極少數情況） | `00-Inbox/` |

**判斷流程（嚴格按順序執行）：**
1. 閱讀文章內容，判斷主題
2. 對照上表，決定目標資料夾（例如 `30-Resources/商業策略/`）
3. 用 `mkdir -p` 建立目標資料夾
4. 用 `cat >` 直接寫入目標資料夾，**絕對不要先存到 00-Inbox 再移動**
5. 用 `ls` 確認檔案確實存在於目標資料夾

**錯誤示範（禁止）：**
```bash
# 錯！不要存到 00-Inbox
cat > "/obsidian/00-Inbox/2026-03-28 文章標題.md" << 'EOF'
```

**正確示範：**
```bash
# 對！直接存到分類資料夾
cat > "/obsidian/30-Resources/商業策略/2026-03-28 文章標題.md" << 'EOF'
```

## 存入筆記

```bash
# 第一步：確保目標資料夾存在（根據分類判斷結果替換路徑）
mkdir -p "/obsidian/30-Resources/商業策略/"

# 第二步：直接存入分類資料夾（不是 00-Inbox！）
cat > "/obsidian/30-Resources/商業策略/2026-03-28 文章標題.md" << 'EOF'
---
title: 文章標題
source: https://來源網址
date: 2026-03-28
tags: [AI, 趨勢]
category: 30-Resources/AI趨勢
---

## 核心觀點
（一句話說明這篇文章最重要的觀點）

## 重點摘要
- 重點一
- 重點二
- 重點三

## 與我的關聯
（這個知識對 Ken哥 的零人力公司有什麼意義）
EOF
echo "已存入 Obsidian：30-Resources/AI趨勢/2026-03-28 文章標題.md"
```

## 搜尋筆記

```bash
# 搜尋包含關鍵字的筆記（列出檔名）
grep -rl "關鍵字" /obsidian/ --include="*.md"

# 搜尋並顯示內容片段
grep -r "關鍵字" /obsidian/ --include="*.md" -l | head -5 | while read f; do
  echo "=== $f ==="
  grep -A 3 "關鍵字" "$f"
done

# 列出所有筆記
find /obsidian -name "*.md" | grep -v ".obsidian" | sort
```

## 讀取筆記

```bash
# 讀取特定筆記
cat "/obsidian/30-Resources/AI趨勢/2026-03-28 文章標題.md"

# 列出某資料夾的所有筆記
ls "/obsidian/30-Resources/AI趨勢/"
```

## 注意事項

- 檔名格式：`YYYY-MM-DD 標題.md`
- **每篇文章只存一份，禁止重複存檔。** 判斷好分類後，只存到該分類資料夾，不要同時存到 00-Inbox
- 存完後必須回報：「已存入 Obsidian：[完整檔名]」
- 搜尋時如果沒找到，直接說「ob 裡沒有相關筆記」，不要編造內容
- 所有操作都是真實的 shell 指令，不要假裝執行
