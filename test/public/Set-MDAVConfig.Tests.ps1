. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            It "Exist" { 
                Get-Command Set-MDAVConfig | Should -HaveParameter Mode 
            } 
            
            It "Mandatory if required" { 
                
            }

            It "Validate Set is correct" { 

            }
        }
    }
}

AfterTest