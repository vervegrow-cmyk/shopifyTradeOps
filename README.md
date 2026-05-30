# Theme Governance — 使用说明

目标：对 `Trade` 主题（ID: 18561882552）实行可回溯治理。每次修改都要生成一个 Git 提交并自动打标签，必要时可回滚至任一标签。

放置位置：仓库根目录（本地主题目录）。

主要脚本：

- `scripts/commit_tag_push.ps1` — 提交改动并创建时间戳标签；可选上传到 Shopify。
- `scripts/rollback_to_tag.ps1` — 从指定标签创建恢复分支，可选推送到 Shopify。

示例：提交并打标签（同时推送到 Shopify）：

```powershell
cd "d:\\桌面文件下载\\shopify Theme 20260529"
.\scripts\commit_tag_push.ps1 -Message "Fix header spacing" -PushTheme
```

示例：回滚到某个标签并推送到 Shopify：

```powershell
cd "d:\\桌面文件下载\\shopify Theme 20260529"
.\scripts\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
```

注意：

- 推荐先在本地或临时分支测试回滚结果，再决定是否用 `-PushTheme` 将该版本部署到线上。
- 如果尚未配置远程仓库，请运行 `git remote add origin <your-repo-url>` 并推送初始提交。
- 本脚本使用时间戳作为标签名：`vYYYYMMDDHHMMSS`。

如需我为你配置远程仓库并推送初始提交，请授权并提供仓库地址。