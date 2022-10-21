#Unblock files
Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File

#Dot source Private functions. 
Get-ChildItem -Path $PSScriptRoot\functions\private\*.ps1 | ForEach-Object { . $_.FullName}

#Dot source Public functions. 
Get-ChildItem -Path $PSScriptRoot\functions\public\*.ps1 | ForEach-Object { . $_.FullName}
