. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            Context "GUID Parameters" {
                It "Exist" { 
                    Get-Command Get-GPOComplianceSettings | Should -HaveParameter GUID 
                } 
            }
        }

        Context "Calls Depenant functions" {
            It "Gets setting Map"{

            } 

            It "Imports GroupPolicy" { 

            }

            It "Throws if it cant import GroupPolicy" { 

            }

            It "Generates GPO Report" { 

            }
        }

        Context "Extracts Settings" { 
            It "Standard enabled Setting" { 

            }

            It "Standards Disabled Setting" { 

            }

            It "Enabled List Box" { 

            }

            It "Disabled List Box" { 

            }
        }

        Context "Output" { 
            It "To console"{

            }

            It "To file"{
                
            }
        }
    }
}