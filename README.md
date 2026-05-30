# Theme Governance

This repository is governed as a release-tracked Shopify theme workspace for the live `Trade` theme.

## Required release rule

Every approved code change must be published to both destinations:

1. Shopify live theme
2. GitHub repository `vervegrow-cmyk/shopifyTradeOps`

Local-only edits are not considered complete.

## Standard publish flow

From the repo root:

```powershell
cd "d:\桌面文件下载\shopify Theme 20260529"
.\scripts\commit_tag_push.ps1 -Message "Describe the change"
```

The publish script now enforces this order:

1. stage the working tree
2. create a Git commit
3. create a timestamp tag
4. push commit and tag to GitHub
5. run `shopify theme check`
6. push to Shopify live theme

If GitHub push fails, the Shopify live push is not attempted.

## Prerequisites

- `git` must be installed
- Shopify CLI must be installed and logged into the target store
- GitHub authentication must already work for `origin`

Verify GitHub access:

```powershell
git push origin main
```

If you see `Permission denied (publickey)`, add the machine SSH public key to the GitHub account or repo access before publishing.

## Rollback flow

To restore a tagged version locally and optionally publish it again:

```powershell
.\scripts\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
```

## Notes

- Live theme id: `185618825522`
- Store: `4ea863-98.myshopify.com`
- Tags use format `vYYYYMMDD-HHMMSS`
