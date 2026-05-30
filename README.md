# Theme Governance

这个仓库用于维护 Shopify live 主题 `Trade`，并要求每次批准的代码修改都同步到以下两个目标：

1. Shopify live theme `#185618825522`
2. GitHub 仓库 `vervegrow-cmyk/shopifyTradeOps`

## 默认发布规则

- 代码修改完成后，默认直接执行同步，不需要再单独询问是否发布。
- 标准目标是 `GitHub + Shopify live` 双同步。
- 如果 GitHub 临时不可用，允许先完成 Shopify live 发布，但 GitHub 必须在恢复后尽快补同步，直到两端一致。
- 本地只改不发，不算完成。

## 标准发布命令

```powershell
cd "d:\\桌面文件下载\\shopify Theme 20260529"
.\scripts\commit_tag_push.ps1 -Message "Describe the change"
```

发布脚本默认执行以下顺序：

1. `git add -A`
2. 创建 Git commit
3. 创建时间戳 tag
4. 推送 commit 到 GitHub
5. 推送 tag 到 GitHub
6. 执行 `shopify theme check`
7. 推送到 Shopify live

## 回滚命令

```powershell
.\scripts\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
```

## 说明

- GitHub 远程地址：`https://github.com/vervegrow-cmyk/shopifyTradeOps.git`
- Store：`4ea863-98.myshopify.com`
- Tag 格式：`vYYYYMMDD-HHMMSS`
