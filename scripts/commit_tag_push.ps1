param(
  [string]$Message = "Update theme",
  [string]$ThemeId = "18561882552",
  [string]$Store = "4ea863-98.myshopify.com",
  [switch]$PushTheme
)

# Ensure we're in a git repo
if (-not (Test-Path ".git")) {
  git init
  git config user.name "theme-admin"
  git config user.email "theme@local"
  git add -A
  git commit -m "chore: initial commit"
}

# Stage changes
git add -A

# Check for changes
$changes = git status --porcelain
if (-not $changes) {
  Write-Host "No changes to commit."
  exit 0
}

# Commit
git commit -m $Message

# Create timestamped tag
$tag = "v$(Get-Date -Format yyyyMMdd-HHmmss)"
git tag -a $tag -m "$Message"

# Push commits and tags if remote exists
try {
  git push origin --follow-tags
} catch {
  Write-Host "Warning: failed to push to origin. Configure remote if needed." -ForegroundColor Yellow
}

# Optionally push theme to Shopify
if ($PushTheme) {
  Write-Host "Pushing theme to Shopify..."
  shopify theme push --theme=$ThemeId --store=$Store
}

Write-Host "Committed and tagged as $tag"