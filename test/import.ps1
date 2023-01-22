$here = Split-Path -Parent -Path $MyInvocation.MyCommand.Path -ErrorAction Stop

#Dot Source Pester functions 
if(Test-Path (Join-Path -Path $here -ChildPath 'helpers')){
    Get-ChildItem -Path (Join-Path -Path $here -ChildPath 'helpers') -Filter '*.ps1' -File | 
    Select-Object -ExpandProperty FullName | ForEach-Object { . $_}
}

#Get Module Data 
$global:module = Get-ModuleName -TestDirectory $here
$global:moduleDir = Get-SourceDirectory -TestDirectory $here
$global:moduleManifest = Get-ModuleManifest -TestDirectory $here
$global:moduleTests = $here

#Import Function for prior to tests
function BeforeTest { 
    Import-Module $moduleManifest.FullName -Scope Global
}

#Remove Function for after tests
function AfterTest { 
    Get-Module $module -ErrorAction SilentlyContinue | Remove-Module -Force -ErrorAction SilentlyContinue
}