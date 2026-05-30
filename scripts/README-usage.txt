Usage examples (PowerShell):

# Publish to both GitHub and Shopify live
.\commit_tag_push.ps1 -Message "Release hero update"

# Publish to Shopify live even if GitHub push is currently unavailable
.\commit_tag_push.ps1 -Message "Live publish with deferred GitHub sync"

# Governance note
# Every approved change must end up in both GitHub and Shopify live.
# If GitHub is temporarily unavailable, publish to Shopify live first and backfill GitHub afterward.

# Commit/tag only, skip GitHub push
.\commit_tag_push.ps1 -Message "Local checkpoint" -SkipGitHubPush

# Commit/tag/GitHub push only, skip Shopify live push
.\commit_tag_push.ps1 -Message "Repo sync only" -SkipShopifyPush

# List tags and rollback locally
.\rollback_to_tag.ps1 -Tag v20260529-143000

# Rollback and push the restored version to Shopify live
.\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
