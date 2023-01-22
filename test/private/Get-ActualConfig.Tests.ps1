. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Function Tests" { 
        Context "Parameter Tests" { 
            Context "ExpectedConfiguration" { 
                It "Should Exist" {
                    Get-Command Get-ActualConfig | Should -HaveParameter ExpectedConfiguration 
                }

                It "Should be Mandatory" { 
                    (Get-Command Get-ActualConfig).parameters['ExpectedConfiguration'].Attributes.Mandatory | Should -be $true
                }
            } 
            
        }

        Context "Functionality Tests" {
            It "Calls Get-MpPreference function" {
                Mock Get-MpPreference { }
                $testJson = @{"DisableRealTimeMonitoring" = $true} | Convertto-Json
                Get-ActualConfig -ExpectedConfiguration $testJson
                Assert-MockCalled Get-MpPreference
            }
           
            It "Returns a hash table" {
                Mock Get-MpPreference { }
                $testJson = @{"DisableRealTimeMonitoring" = $true} | Convertto-Json
                Get-ActualConfig -ExpectedConfiguration $testJson | Should -beofType [Object]
            }
        }
    }
}
