param(
  [string]$Tag,
  [string]$ThemeId = "18561882552",
  [string]$Store = "4ea863-98.myshopify.com",
  [switch]$PushTheme
)

if (-not $Tag) {
  Write-Host "Available tags:"; git tag --list
  Write-Host "Run with -Tag <tagname> to rollback."
  exit 1
}

# Create a safety branch from the tag
$branch = "restore-$Tag"
Write-Host "Creating branch $branch from tag $Tag..."

git checkout -b $branch $Tag

Write-Host "Working tree now at tag $Tag on branch $branch. Review changes and test locally."

if ($PushTheme) {
  Write-Host "Pushing this version to Shopify theme $ThemeId..."
  shopify theme push --theme=$ThemeId --store=$Store
}

Write-Host "Rollback to $Tag completed locally."
