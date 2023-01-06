. $PSScriptRoot\Import.ps1

BeforeTest

Describe $module -Tags ('unit'){
    Context "$module : Module Tests" { 
        It 'Passes ''Test-ModuleManifest''' { 
            Test-ModuleManifest -Path $moduleManifest
            $? | Should -Be $true
        }

        It "Has the module manifest file" {
            "$moduleDir\$module.psm1" | Should -Exist
        }

        It "$module has valid PowerShell Code" {
            $psFile = Get-Content -Path "$moduleDir\$module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile,[ref]$errors)
            $errors.Count | Should -Be 0
        }
    }

    $privateFunctions = @()
    if (Test-Path -Path (Join-Path -Path $moduleDir -ChildPath "functions\private")){
        $privateFunctions = @(Get-ChildItem -Path "$moduleDir\functions\private" -Filter '*.ps1' -File)
    }

    $publicFunctions = @()
    if (Test-Path -Path (Join-Path -Path $moduleDir -ChildPath "functions\public")){
        $publicFunctions = @(Get-ChildItem -Path "$moduleDir\functions\public" -Filter '*.ps1' -File)
    }

    foreach ($global:function in @($privateFunctions + $publicFunctions)) {
        Context "The function $($function.BaseName)" {
            It "Should exist"{
                $global:function.FullName | Should -Exist
            }

            It "Should be an advanced function" {
                $global:function.FullName | Should -FileContentMatch 'function'
                $global:function.FullName | Should -FileContentMatch 'cmdletbinding'
                $global:function.FullName | Should -FileContentMatch 'param'
            }

            It "has Valid Powershell Code" {
                $psFile = Get-Content -Path $global:function.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile,[ref]$errors)
                $errors.Count | Should -Be 0
            }
        }
    }
}

AfterTest