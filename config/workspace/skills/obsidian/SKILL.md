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

## 存入筆記

```bash
# 存入一篇文章到對應資料夾
cat > "/obsidian/30-Resources/AI趨勢/2026-03-28 文章標題.md" << 'EOF'
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
echo "已存入 Obsidian"
```

**分類規則：**
- AI、機器學習、自動化 → `30-Resources/AI趨勢/`
- 商業模式、創業、管理 → `30-Resources/商業策略/`
- 程式、技術、工具 → `30-Resources/技術筆記/`
- 行銷、社群、內容 → `30-Resources/行銷/`
- 專案相關 → `10-Projects/`
- 不確定 → `00-Inbox/`

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
- 存完後必須回報：「已存入 Obsidian：[完整檔名]」
- 搜尋時如果沒找到，直接說「ob 裡沒有相關筆記」，不要編造內容
- 所有操作都是真實的 shell 指令，不要假裝執行
