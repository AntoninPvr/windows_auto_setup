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

# Create a new power plan
$NewPlan = powercfg -duplicatescheme $PowerSaverGUID
$NewPlanGUID = Get-GUIDFromInput -InputString $NewPlan
if ($null -eq $NewPlanGUID) {
    Write-Output "Failed to create new power plan."
    Exit
}

Write-Output "New power plan created with GUID: $NewPlanGUID"
Start-Process -FilePath "powercfg.exe" -ArgumentList "-changename", "$NewPlanGUID", "$PowerPlanName"
Write-Output "Power plan name changed to: $PowerPlanName"

# Set additional custom settings for the "Passive" power plan
#===========================================================
# Set max CPU frequency on DC to 1900MHz
#powercfg -setdcvalueindex $NewPlanGUID SUB_PROCESSOR PROCFREQMAX $CpuMaxFreqDC
Start-Process -FilePath "powercfg.exe" -ArgumentList "-setdcvalueindex", "$NewPlanGUID", "SUB_PROCESSOR", "PROCFREQMAX", "$CpuMaxFreqDC"
# Set max CPU frequency on AC to 2300MHz
Start-Process -FilePath "powercfg.exe" -ArgumentList "-setacvalueindex", "$NewPlanGUID", "SUB_PROCESSOR", "PROCFREQMAX", "$CpuMaxFreqAC"

# Set parked CPU cores to 50% for both AC and DC
Start-Process -FilePath "powercfg.exe" -ArgumentList "-setdcvalueindex", "$NewPlanGUID", "SUB_PROCESSOR", "CPMINCORES", "$CpuParkedCoresDC"
Start-Process -FilePath "powercfg.exe" -ArgumentList "-setacvalueindex", "$NewPlanGUID", "SUB_PROCESSOR", "CPMINCORES", "$CpuParkedCoresAC"
