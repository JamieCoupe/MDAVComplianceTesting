. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Function Tests" { 
        Context "Parameter Tests" { 
            Context "ConfigurationFile" { 
                BeforeAll { 
                    $validateSet = (Get-Command Get-ConfigurationFile).Parameters['ConfigurationFile'].Attributes.Where{ $_ -is [ValidateSet] }
                }

                It "Should Exist" {
                    Get-Command Get-ConfigurationFile | Should -HaveParameter ConfigurationFile 
                }

                It "Should be Mandatory" { 
                    (Get-Command Get-ConfigurationFile).parameters['ConfigurationFile'].Attributes.Mandatory | Should -be $true
                }
        
                It "Validate Set is present" { 
                    $validateSet.Count | Should -Be 1
                }
    
                It "Validate Set should only have 3 values" {
                    $ValidateSet.ValidValues.count | Should -Be 3
                }
    
                It "Expected_Config is valid" { 
                    $validateSet.ValidValues -contains "Expected_Config" | should -be $true
                }
    
                It "Module is Valid" { 
                    $validateSet.ValidValues -contains "Module" | should -Be $true
                }

                It "Setting_Mapping is Valid" { 
                    $validateSet.ValidValues -contains "Setting_Mapping" | should -Be $true
                }
            } 
            
        }

        Context "Functionality Tests" {
            It "Returns object" {
                $res = Get-ConfigurationFile -ConfigurationFile Module
                $res | Should -BeOfType [System.Collections.Hashtable]
            }
        }
    }
}
