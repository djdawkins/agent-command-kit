#Requires -Version 5.1
<#
  install.ps1 - installs agent-command-kit globally.
  Run once per machine. Not per project - the commands work in every
  project afterward since they're installed to user-profile locations.

  Usage:
    irm https://raw.githubusercontent.com/djdawkins/agent-command-kit/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"

$KitRepo = "https://github.com/djdawkins/agent-command-kit.git"
$TmpDir = Join-Path $env:TEMP ("agent-command-kit-" + [guid]::NewGuid())

try {
    Write-Host "Fetching agent-command-kit..."
    # git writes normal progress ("Cloning into...") to stderr. With
    # ErrorActionPreference = Stop, PowerShell treats ANY stderr line from
    # a native command as a terminating error even on success - so we
    # temporarily relax that and check $LASTEXITCODE ourselves instead.
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    git clone --depth 1 --quiet $KitRepo $TmpDir 2>&1 | Out-Null
    $cloneExitCode = $LASTEXITCODE
    $ErrorActionPreference = $prevEap

    if ($cloneExitCode -ne 0) {
        throw "git clone failed with exit code $cloneExitCode"
    }

    # 1. Scripts - the actual git-mechanics logic, installed once, invoked
    #    by absolute path from whatever project you're in.
    $ScriptsDest = Join-Path $env:USERPROFILE ".agent-kit\scripts"
    New-Item -ItemType Directory -Force -Path $ScriptsDest | Out-Null
    Copy-Item (Join-Path $TmpDir "scripts\*.sh") $ScriptsDest -Force
    Write-Host "Installed scripts to $ScriptsDest"

    # 2. Claude Code - global commands
    $ClaudeDest = Join-Path $env:USERPROFILE ".claude\commands"
    New-Item -ItemType Directory -Force -Path $ClaudeDest | Out-Null
    Copy-Item (Join-Path $TmpDir "commands\*.md") $ClaudeDest -Force
    Write-Host "Installed Claude Code commands to $ClaudeDest"

    # 3. OpenCode - global commands
    $OpenCodeDest = Join-Path $env:USERPROFILE ".config\opencode\command"
    New-Item -ItemType Directory -Force -Path $OpenCodeDest | Out-Null
    Copy-Item (Join-Path $TmpDir "commands\*.md") $OpenCodeDest -Force
    Write-Host "Installed OpenCode commands to $OpenCodeDest"

    # 4. Codex - global prompts
    if ($env:CODEX_HOME) {
        $CodexPromptsDir = Join-Path $env:CODEX_HOME "prompts"
    } else {
        $CodexPromptsDir = Join-Path $env:USERPROFILE ".codex\prompts"
    }
    New-Item -ItemType Directory -Force -Path $CodexPromptsDir | Out-Null
    Copy-Item (Join-Path $TmpDir "commands\*.md") $CodexPromptsDir -Force
    Write-Host "Installed Codex prompts to $CodexPromptsDir"

    Write-Host ""
    Write-Host "Done. once-upon-a-time and the-end are now available in every project."
    Write-Host "Restart Claude Code, OpenCode, and Codex (or start new sessions) to pick them up."
}
finally {
    if (Test-Path $TmpDir) {
        Remove-Item -Recurse -Force $TmpDir
    }
}