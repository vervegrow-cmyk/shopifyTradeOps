Usage examples (PowerShell):

# Publish to both GitHub and Shopify live
.\commit_tag_push.ps1 -Message "Update footer links"

# Publish to Shopify live even if GitHub is temporarily unavailable
.\commit_tag_push.ps1 -Message "Live publish with deferred GitHub sync"

# Commit/tag only, skip GitHub push
.\commit_tag_push.ps1 -Message "Local checkpoint" -SkipGitHubPush

# Commit/tag/GitHub push only, skip Shopify live push
.\commit_tag_push.ps1 -Message "Repo sync only" -SkipShopifyPush

# Governance note
# Approved code changes should be synchronized to both GitHub and Shopify live by default.
# Codex should execute the sync directly after changes are made and does not need to ask for a separate publish confirmation.

# List tags and rollback locally
.\rollback_to_tag.ps1 -Tag v20260529143000 -PushTheme
