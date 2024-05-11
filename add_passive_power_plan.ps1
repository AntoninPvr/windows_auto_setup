# Script to add passive power plan to Windows 10 and Windows 11
# This script reduce number of active cores and prevent cpu from boosting
# This script is useful for reducing power consumption and heat generation
# It allow use of laptop fully passive without fan noise

# Function:
#==========
function Get-GUIDFromInput {
    param (
        [string]$InputString
    )

    if ($InputString -match '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}') {
        $guid = $matches[0]
        return $guid
    } else {
        return $null
    }
}

# Add passive power plan to power plan settings
#==============================================
# Define the name for the new power plan
$PowerPlanName = "Passive"
$CpuMaxFreqDC = 1900
$CpuMaxFreqAC = 2300
$CpuParkedCoresDC = 50
$CpuParkedCoresAC = 50

$PowerSaverGUID = "a1841308-3541-4fab-bc81-f71556f20b4a"
$BalancedGUID = "381b4222-f694-41f0-9685-ff5bb260df2e"

# Create a new power plan
$Passive = powercfg -duplicatescheme $PowerSaverGUID
$PassiveGUID = Get-GUIDFromInput -InputString $Passive
if ($null -eq $PassiveGUID) {
    Write-Output "Failed to create new power plan."
    Exit
}

Write-Output "New power plan created with GUID: $PassiveGUID"
cmd /c "powercfg -changename $PassiveGUID $PowerPlanName"
Write-Output "Power plan name changed to: $PowerPlanName"

# Set additional custom settings for the "Passive" power plan
#===========================================================
# Set max CPU frequency on DC to 1900MHz
cmd /c "powercfg -setdcvalueindex $PassiveGUID SUB_PROCESSOR PROCFREQMAX $CpuMaxFreqDC"
# Set max CPU frequency on AC to 2300MHz
cmd /c "powercfg -setacvalueindex $PassiveGUID SUB_PROCESSOR PROCFREQMAX $CpuMaxFreqAC"

# Set parked CPU cores to 50% for both AC and DC
cmd /c "powercfg -setdcvalueindex $PassiveGUID SUB_PROCESSOR CPMINCORES $CpuParkedCoresDC"
cmd /c "powercfg -setacvalueindex $PassiveGUID SUB_PROCESSOR CPMINCORES $CpuParkedCoresAC"

# Add Desktop shortcut for easy toggling between power plans
#===========================================================
$DesktopPath = [System.Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path -Path $DesktopPath -ChildPath "Balanced.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "cmd.exe"
$Shortcut.Arguments = "/c start /min powercfg -setactive `"$BalancedGUID`""
$Shortcut.IconLocation = Join-Path -Path $PSScriptRoot -ChildPath "icons/Balanced.ico"
$Shortcut.Save()
Write-Output "Desktop shortcut created for Balanced power plan"

$ShortcutPath = Join-Path -Path $DesktopPath -ChildPath "Passive.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "cmd.exe"
$Shortcut.Arguments = "/c start /min powercfg -setactive `"$PassiveGUID`""
$Shortcut.IconLocation = Join-Path -Path $PSScriptRoot -ChildPath "icons/Passive.ico"
$Shortcut.Save()
Write-Output "Desktop shortcut created for Passive power plan"