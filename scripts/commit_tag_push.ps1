param(
  [Parameter(Mandatory = $true)]
  [string]$Message,
  [string]$ThemeId = "185618825522",
  [string]$Store = "4ea863-98.myshopify.com",
  [switch]$SkipGitHubPush,
  [switch]$SkipShopifyPush
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Label,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host "==> $Label" -ForegroundColor Cyan
  & $Action
}

if (-not (Test-Path ".git")) {
  throw "This folder is not a Git repository."
}

$statusBefore = git status --porcelain
if (-not $statusBefore) {
  Write-Host "No changes to publish."
  exit 0
}

Invoke-Step -Label "Stage changes" -Action {
  git add -A
}

Invoke-Step -Label "Create commit" -Action {
  git commit -m $Message
}

$tag = "v$(Get-Date -Format yyyyMMdd-HHmmss)"
Invoke-Step -Label "Create tag $tag" -Action {
  git tag -a $tag -m $Message
}

if (-not $SkipGitHubPush) {
  Invoke-Step -Label "Push commit to GitHub" -Action {
    git push origin HEAD
  }

  Invoke-Step -Label "Push tag to GitHub" -Action {
    git push origin $tag
  }
} else {
  Write-Host "Skipping GitHub push by request." -ForegroundColor Yellow
}

if (-not $SkipShopifyPush) {
  Invoke-Step -Label "Run Shopify theme check" -Action {
    shopify theme check
  }

  Invoke-Step -Label "Push to Shopify live theme" -Action {
    shopify theme push --theme=$ThemeId --store=$Store --live --allow-live
  }
} else {
  Write-Host "Skipping Shopify live push by request." -ForegroundColor Yellow
}

Write-Host "Publish flow completed. Commit message: $Message" -ForegroundColor Green
Write-Host "Release tag: $tag" -ForegroundColor Green
