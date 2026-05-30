param(
  [Parameter(Mandatory = $true)]
  [string]$Message,
  [string]$ThemeId = "185618825522",
  [string]$Store = "4ea863-98.myshopify.com",
  [switch]$SkipGitHubPush,
  [switch]$SkipShopifyPush
)

$ErrorActionPreference = "Stop"
$script:HadGitHubPushFailure = $false

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Label,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host "==> $Label" -ForegroundColor Cyan
  & $Action
  if ($LASTEXITCODE -ne 0) {
    throw "$Label failed with exit code $LASTEXITCODE."
  }
}

function Invoke-OptionalGitHubStep {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Label,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host "==> $Label" -ForegroundColor Cyan
  & $Action
  if ($LASTEXITCODE -ne 0) {
    $script:HadGitHubPushFailure = $true
    Write-Host "GitHub sync failed in this step. Shopify live publish will continue, and GitHub must be backfilled afterward." -ForegroundColor Yellow
  }
}

if (-not (Test-Path ".git")) {
  throw "This folder is not a Git repository."
}

$changes = git status --porcelain
if (-not $changes) {
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
  Invoke-OptionalGitHubStep -Label "Push commit to GitHub" -Action {
    git push origin HEAD
  }

  if (-not $HadGitHubPushFailure) {
    Invoke-OptionalGitHubStep -Label "Push tag to GitHub" -Action {
      git push origin $tag
    }
  } else {
    Write-Host "Skipping tag push because commit push to GitHub failed." -ForegroundColor Yellow
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
if ($HadGitHubPushFailure) {
  Write-Host "Shopify live publish completed, but GitHub push did not succeed in this run." -ForegroundColor Yellow
}
