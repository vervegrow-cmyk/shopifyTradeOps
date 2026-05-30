Usage examples (PowerShell):

# Publish to both GitHub and Shopify live
.\commit_tag_push.ps1 -Message "Release hero update"

# Commit/tag only, skip GitHub push
.\commit_tag_push.ps1 -Message "Local checkpoint" -SkipGitHubPush

# Commit/tag/GitHub push only, skip Shopify live push
.\commit_tag_push.ps1 -Message "Repo sync only" -SkipShopifyPush

# List tags and rollback locally
.\rollback_to_tag.ps1 -Tag v20260529-143000

# Rollback and push the restored version to Shopify live
.\rollback_to_tag.ps1 -Tag v20260529-143000 -PushTheme
