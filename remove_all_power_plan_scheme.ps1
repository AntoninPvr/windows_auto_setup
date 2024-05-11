# Script to retsore default power plan schemes in Windows 10 and Windows 11
cmd /c "powercfg -restoredefaultschemes"

Write-Output "All power schemes deleted."