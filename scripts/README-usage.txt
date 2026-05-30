Usage examples (PowerShell):

# Commit and tag without pushing theme
.\commit_tag_push.ps1 -Message "Update footer links"

# Commit, tag and push to Shopify
.\commit_tag_push.ps1 -Message "Release hero update" -PushTheme

# List tags and rollback (interactive)
.\rollback_to_tag.ps1 -Tag v20260529143000 -PushTheme