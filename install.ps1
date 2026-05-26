$ErrorActionPreference = 'Stop'
$baseUrl = 'https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master'

function Parse-FrontMatter($content) {
    $lines = $content -split "`n"
    $state = 'outside'; $fm = @(); $body = @(); $passedFirst = $false
    foreach ($line in $lines) {
        if ($line.Trim() -eq '---') {
            if (-not $passedFirst) { $passedFirst = $true; $state = 'fm'; continue }
            else { $state = 'body'; continue }
        }
        if ($state -eq 'fm') { $fm += $line }
        else { $body += $line }
    }
    $fmStr = ($fm -join "`n").Trim()
    $bodyStr = ($body -join "`n").TrimStart()
    return @{ FrontMatter = $fmStr; Body = $bodyStr }
}

function Install-Md($path, $url) {
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        Invoke-WebRequest -Uri $url -OutFile $tmp -ErrorAction Stop
        $null = mkdir (Split-Path $path -Parent) -Force 2>$null
        if (Test-Path $path) {
            $tContent = Get-Content $tmp -Raw
            $eContent = Get-Content $path -Raw
            $t = Parse-FrontMatter $tContent
            $e = Parse-FrontMatter $eContent
            if ($t.FrontMatter) {
                $merged = "---`n$($t.FrontMatter)`n---`n`n$($t.Body)`n`n---`n`n$($e.Body)"
            } else {
                $merged = "$($t.Body)`n`n---`n`n$($e.Body)"
            }
            [IO.File]::WriteAllText($path, $merged, [Text.Encoding]::UTF8)
            Write-Host "  ~ Merged $path"
        } else {
            Move-Item $tmp $path -Force
            Write-Host "  + Created $path"
        }
    } finally {
        if (Test-Path $tmp) { Remove-Item $tmp -Force }
    }
}

function Install-Other($path, $url) {
    if (Test-Path $path) {
        Write-Host "  - Skipped $path (exists)"
        return
    }
    $null = mkdir (Split-Path $path -Parent) -Force 2>$null
    try {
        Invoke-WebRequest -Uri $url -OutFile $path -ErrorAction Stop
        Write-Host "  + Created $path"
    } catch {
        if (Test-Path $path) { Remove-Item $path -Force }
        Write-Host "  x Failed to download $path" -ForegroundColor Red
    }
}

function Merge-Gitignore($url) {
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        Invoke-WebRequest -Uri $url -OutFile $tmp -ErrorAction Stop
        if (Test-Path '.gitignore') {
            $existing = Get-Content '.gitignore'
            $template = Get-Content $tmp
            $missing = $template | Where-Object { $_ -and ($existing -notcontains $_) }
            if ($missing) {
                Add-Content '.gitignore' -Value @('', '# agentic-boilerplate') + $missing
                Write-Host "  ~ Merged .gitignore"
            } else {
                Write-Host "  - Skipped .gitignore (up to date)"
            }
        } else {
            Move-Item $tmp '.gitignore' -Force
            Write-Host "  + Created .gitignore"
        }
    } finally {
        if (Test-Path $tmp) { Remove-Item $tmp -Force }
    }
}

function Ensure-Dir($dir) {
    $null = mkdir $dir -Force 2>$null
    $gitkeep = Join-Path $dir '.gitkeep'
    if (-not (Test-Path $gitkeep)) {
        $null = New-Item $gitkeep -ItemType File -Force
        Write-Host "  + Created $dir/"
    } else {
        Write-Host "  - Skipped $dir/ (exists)"
    }
}

# ── Main ──

Write-Host "agentic-boilerplate -- installing into $((Get-Location).Path)"
Write-Host ""

# .md files (YAML-aware prepend merge)
$mdFiles = @(
    'AGENTS.md',
    '.agents/skills/init/SKILL.md',
    '.agents/skills/brainstorm/SKILL.md',
    '.agents/skills/concise/SKILL.md',
    '.agents/skills/implement/SKILL.md',
    '.agents/skills/init/references/tradeoffs.md',
    '.agents/skills/init/references/templates-adr.md',
    '.agents/skills/init/references/templates-docs.md',
    'docs/templates/000-plan.md',
    'docs/templates/ADR.md',
    'docs/templates/AGENTS.md',
    'docs/templates/ARCHITECTURE.md',
    'docs/templates/PROJECT_STRUCTURE.md',
    'docs/templates/TODO.md'
)
foreach ($f in $mdFiles) {
    $url = "$baseUrl/$($f -replace '\\', '/')"
    Install-Md $f $url
}

# Non-md files (skip if exists)
Install-Other 'Makefile' "$baseUrl/Makefile"
Install-Other '.agents/skills/init/scripts/detect.sh' "$baseUrl/.agents/skills/init/scripts/detect.sh"

# .gitignore merge
Merge-Gitignore "$baseUrl/.gitignore"

# Directory structure
Ensure-Dir 'docs/agents'
Ensure-Dir 'docs/ADR'
Ensure-Dir 'docs/plans'
Ensure-Dir 'docs/plans/.archive'
Ensure-Dir 'docs/UAT'
Ensure-Dir 'docs/UAT/.archive'
Ensure-Dir 'docs/wiki'
Ensure-Dir 'src'

Write-Host ""
Write-Host "Done."
Write-Host ""
Write-Host "Next step:"
Write-Host "  make setup"
Write-Host "    Creates symlinks for AI-tool compatibility"
Write-Host "    (.cursorrules, .windsurfrules, CLAUDE.md -> AGENTS.md)"
Write-Host ""
Write-Host "Then open the project with your AI agent."
Write-Host "If docs/agents/ is empty, the init skill will prompt you"
Write-Host "to configure project-specific docs."
