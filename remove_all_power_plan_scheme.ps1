# Script to retsore default power plan schemes in Windows 10 and Windows 11
Start-Process -FilePath "powercfg.exe" -ArgumentList "-restoredefaultschemes"

Write-Output "All power schemes deleted."
