param(
  [string]$Branch = "main",
  [string]$Tag = "",
  [int]$MaxAttempts = 20,
  [int]$DelaySeconds = 120,
  [string]$Remote = "origin",
  [string]$LogPath = "scripts\retry_github_sync.log"
)

$ErrorActionPreference = "Stop"

function Write-Log {
  param([string]$Message)

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -Path $LogPath -Value "[$timestamp] $Message"
}

Set-Location -LiteralPath $PSScriptRoot\..
Write-Log "Retry sync started for branch '$Branch' and tag '$Tag'."

for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
  Write-Log "Attempt $attempt of $MaxAttempts."

  git push $Remote $Branch
  $branchExitCode = $LASTEXITCODE

  if ($branchExitCode -eq 0) {
    Write-Log "Branch push succeeded."

    if ($Tag -ne "") {
      git push $Remote $Tag
      $tagExitCode = $LASTEXITCODE

      if ($tagExitCode -eq 0) {
        Write-Log "Tag push succeeded. Retry sync completed."
        exit 0
      }

      Write-Log "Tag push failed with exit code $tagExitCode."
    } else {
      Write-Log "No tag requested. Retry sync completed."
      exit 0
    }
  } else {
    Write-Log "Branch push failed with exit code $branchExitCode."
  }

  if ($attempt -lt $MaxAttempts) {
    Start-Sleep -Seconds $DelaySeconds
  }
}

Write-Log "Retry sync exhausted all attempts without success."
exit 1
