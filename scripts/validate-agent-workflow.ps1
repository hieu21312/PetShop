# Agent Workflow Response Validator (PowerShell)
param (
    [Parameter(Mandatory=$true)]
    [string]$ResponseFilePath
)

if (-not (Test-Path $ResponseFilePath)) {
    Write-Error "Target response file '$ResponseFilePath' does not exist."
    exit 1
}

$content = Get-Content $ResponseFilePath -Raw

$errors = @()

# 1. Check Mandatory Workflow Fields
$requiredFields = @("active_role", "task_classification", "artifact_decision", "workflow_path", "validation_plan")
foreach ($field in $requiredFields) {
    if ($content -notmatch "\*\*$field\*\*|\|$field\|") {
        $errors += "Missing mandatory Workflow Declaration field: $field"
    }
}

# 2. Check forbidden external planning artifacts
if ($content -match "brain/|virtual_dir/|hidden_dir/") {
    $errors += "Forbidden: Planning artifacts must live under 'docs/ai/spec/', not virtual/brain directories."
}

# 3. Check forbidden destructive rollback commands
if ($content -match "git checkout|git restore|git reset --hard") {
    $errors += "Forbidden: Unapproved destructive git rollback commands detected."
}

if ($errors.Count -gt 0) {
    Write-Host "[FAIL] Workflow Validation Errors Found:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host " - $err" -ForegroundColor Red
    }
    exit 1
} else {
    Write-Host "[PASS] Agent Workflow Response Validation Succeeded!" -ForegroundColor Green
    exit 0
}
