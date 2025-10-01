Param(
    [string]$Message = $(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')
)

$ErrorActionPreference = 'Stop'

# Target repository URL
$repoUrl   = 'https://github.com/YunAsimov/Chat.git'
$remoteName = 'chat'

function Write-Info($msg){ Write-Host "[push_to_chat] $msg" }

# Ensure we are in the script directory
Set-Location -Path $PSScriptRoot

# Verify git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error 'git 未安装或不在 PATH 中.'
    exit 1
}

# Ensure this is a git repo
if (-not (Test-Path -Path (Join-Path $PSScriptRoot '.git'))) {
    Write-Error '当前目录不是一个 git 仓库.'
    exit 1
}

# Add (or update) remote
$existingRemoteUrl = ''
try { $existingRemoteUrl = git remote get-url $remoteName 2>$null } catch { }
if (-not $existingRemoteUrl) {
    Write-Info "添加远程 $remoteName -> $repoUrl"
    git remote add $remoteName $repoUrl | Out-Null
} elseif ($existingRemoteUrl -ne $repoUrl) {
    Write-Info "更新远程 $remoteName -> $repoUrl (原: $existingRemoteUrl)"
    git remote set-url $remoteName $repoUrl | Out-Null
}

# Determine current branch
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($branch -eq 'HEAD') { $branch = 'main' }
Write-Info "当前分支: $branch"

# Stage all changes
Write-Info 'git add -A'
git add -A

# Check if there is anything to commit
$hasStagedChanges = $true
try {
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) { $hasStagedChanges = $false }
} catch { }

if (-not $hasStagedChanges) {
    Write-Info '没有需要提交的更改.'
} else {
    $commitMsg = "auto: $Message"
    Write-Info "提交: $commitMsg"
    git commit -m $commitMsg | Out-Null
}

# Push (use -u if branch does not have upstream)
$needsSetUpstream = $false
try {
    git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>$null 1>$null
    if ($LASTEXITCODE -ne 0) { $needsSetUpstream = $true }
} catch { $needsSetUpstream = $true }

if ($needsSetUpstream) {
    Write-Info "首次推送，设置 upstream: $remoteName/$branch"
    git push -u $remoteName $branch
} else {
    Write-Info "推送到 $remoteName/$branch"
    git push $remoteName $branch
}

Write-Info '完成.'
