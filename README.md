# Theme Governance

This repository is governed as a release-tracked Shopify theme workspace for the live `Trade` theme.

## Required release rule

Every approved code change must be published to both destinations:

1. Shopify live theme
2. GitHub repository `vervegrow-cmyk/shopifyTradeOps`

Local-only edits are not considered complete.
If either destination fails during a release, the missing sync must be completed as soon as access is restored so that GitHub and Shopify live return to the same code state.

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

If GitHub push fails, the script reports the failure, continues to Shopify live publish, and GitHub must be backfilled afterward so both destinations match.

## Prerequisites

- `git` must be installed
- Shopify CLI must be installed and logged into the target store
- GitHub remote target: `https://github.com/vervegrow-cmyk/shopifyTradeOps.git`

Optional GitHub remote check:

```powershell
git ls-remote origin
```

If GitHub sync is temporarily unavailable, the publish flow will still continue to Shopify live and you can push the commit/tag later.

## Rollback flow

To restore a tagged version locally and optionally publish it again:

```powershell
.\scripts\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
```

## Notes

- Live theme id: `185618825522`
- Store: `4ea863-98.myshopify.com`
- Tags use format `vYYYYMMDD-HHMMSS`
