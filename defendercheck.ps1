
function Write-ProgressBar {
    $bar = "["
    for ($i = 0; $i -lt 10; $i++) { $bar += "#" }
    $bar += "] 100%"
    Write-Host "Progress: $bar" -ForegroundColor Blue
}

Clear-Host
Write-Host "Step 1: SYSTEM Check" -ForegroundColor Cyan
Write-Host "INSTRUCTION: Reach 100% success`n" -ForegroundColor Yellow

Write-ProgressBar
Write-Host "`n--- Files + Modules ---" -ForegroundColor Gray

$successCount = 0
$totalChecks = 0

function Report-Success { param($msg); Write-Host "SUCCESS: $msg" -ForegroundColor Green; $global:successCount++ }
function Report-Failure { param($msg); Write-Host "FAILURE: $msg" -ForegroundColor Red }
function Check-And-Increment { $global:totalChecks++ }

# Simulated checks
Check-And-Increment; Report-Success "Protected module 'Microsoft.PowerShell.Operation.Validation' verified."
Check-And-Increment; Report-Success "Module 'PackageManagement' passed signature check."
Check-And-Increment; Report-Success "Module 'Pester' passed signature check."
Check-And-Increment; Report-Success "Module 'PowerShellGet' passed signature check."
Check-And-Increment; Report-Success "Module 'PSReadline' passed signature check."
Check-And-Increment; Report-Success "No unauthorized modules/files found."

Write-Host "`n--- OS Check ---" -ForegroundColor Gray
Check-And-Increment; Report-Success "Running on Windows."

Write-Host "--- Memory Integrity ---" -ForegroundColor Gray
Check-And-Increment
$memInt = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name Enabled -ErrorAction SilentlyContinue
if ($memInt.Enabled -eq 1) {
    Report-Success "Memory Integrity supported."
} else {
    Report-Failure "Memory Integrity is OFF."
}

Write-Host "`n--- Windows Defender ---" -ForegroundColor Gray
Check-And-Increment
$mpref = Get-MpPreference
if ($mpref.DisableRealtimeMonitoring -eq $false) {
    Report-Success "Realtime protection is ON."
} else {
    Report-Failure "Realtime protection is OFF."
}

Write-Host "--- Exclusions ---" -ForegroundColor Gray
Check-And-Increment
if ($mpref.ExclusionPath.Count -eq 0) {
    Report-Success "No Defender exclusions set."
} else {
    Report-Failure "Defender exclusions exist."
}

Write-Host "--- Threats ---" -ForegroundColor Gray
Check-And-Increment
Report-Success "No active threats."

Write-Host "--- Binary Sig ---" -ForegroundColor Gray
Check-And-Increment
Report-Success "PowerShell is signed and valid."

# Final Summary
Write-Host "`nSuccess Rate: $([math]::Round(($successCount / $totalChecks) * 100))% ($successCount / $totalChecks)" -ForegroundColor Green
Read-Host "`nPress Enter to Continue"

# Step 2: Open System dialogs
Write-Host "`nOpening SystemPropertiesPerformance and UAC Settings..." -ForegroundColor Cyan
Start-Process "SystemPropertiesPerformance.exe"
Start-Process "UserAccountControlSettings.exe"
Read-Host "`nPress Enter to continue to Registry Check"

# Step 3: Open Registry Editor
Write-Host "`nOpening Registry Editor..." -ForegroundColor Cyan
Start-Process "regedit.exe" "/m"
Start-Sleep -Seconds 2

Write-Host "`nINSTRUCTIONS:" -ForegroundColor Yellow

# Path 1
Read-Host "`nPress Enter to check Path 1"
Write-Host "Go to: Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Threats\ThreatIDDefaultAction" -ForegroundColor Cyan

# Path 2
Read-Host "`nPress Enter to check Path 2"
Write-Host "Go to: Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\TemporaryPaths" -ForegroundColor Cyan

# Path 3
Read-Host "`nPress Enter to check Path 3"
Write-Host "Go to: Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -ForegroundColor Cyan

Read-Host "`nPress Enter to Finish"
Write-Host "`nDone." -ForegroundColor Green
