. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            It "Exist" { 
                Get-Command Get-TestSummary | Should -HaveParameter TestResultPath 
            } 
            
            It "Mandatory if required" { 
                (Get-Command Get-TestSummary).Parameters['TestResultPath'].Attributes.Mandatory | Should -be $true
            }
        }
    }
}

