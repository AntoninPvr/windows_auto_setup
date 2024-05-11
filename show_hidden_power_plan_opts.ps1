# Script to show hidden power plan options in Windows 10 and Windows 11

# Add park core option to power plan settings
#============================================
$ParkCoreRegistryPath = "HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"
$ParkCoreName = "Attributes"
$ParkCoreValue = 2

# Check if the registry key exists
If (-NOT (Test-Path $ParkCoreRegistryPath)) {
    Write-Output "Registry key not found"
    Exit
}
# Set the registry value
Else {
    Set-ItemProperty -Path $ParkCoreRegistryPath -Name $ParkCoreName -Value $ParkCoreValue
}

# Add processor maximum frequency option to power plan settings
#==============================================================
$ProcessorMaxFrequencyRegistryPath = "HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100"
$ProcessorMaxFrequencyName = "Attributes"
$ProcessorMaxFrequencyValue = 2

# Check if the registry key exists
If (-NOT (Test-Path $ProcessorMaxFrequencyRegistryPath)) {
    Write-Output "Registry key not found"
    Exit
}
# Set the registry value
Else {
    Set-ItemProperty -Path $ProcessorMaxFrequencyRegistryPath -Name $ProcessorMaxFrequencyName -Value $ProcessorMaxFrequencyValue
}
