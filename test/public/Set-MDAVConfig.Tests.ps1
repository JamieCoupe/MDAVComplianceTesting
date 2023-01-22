. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            BeforeAll { 
                $validateSet = (Get-Command Set-MDAVConfig).Parameters['Mode'].Attributes.Where{ $_ -is [ValidateSet] }
            }

            It "Exist" { 
                Get-Command Set-MDAVConfig | Should -HaveParameter Mode 
            } 
            
            It "Mandatory if required" { 
                (Get-Command Set-MDAVConfig).Parameters['Mode'].Attributes.Mandatory | Should -be $true
            }

            It "Validate Set is present" { 
                $validateSet.Count | Should -Be 1
            }

            It "Validate Set should only have 2 values" {
                $ValidateSet.ValidValues.count | Should -Be 2
            }

            It "Random is valid" { 
                $validateSet.ValidValues -contains "Random" | should -be $true
            }

            It "Secure is Valid" { 
                $validateSet.ValidValues -contains "Secure" | should -Be $true
            }
        }

        Context "Checks Admin" {
            It "Throws exception if not admin" {
                Mock Get-IsAdmin { return $false }
                Mock Set-MpPreference
                { Set-MDAVConfig -Mode Secure } | Should -Throw
            }

            It "Continues if admin" {
                Mock Get-IsAdmin { return $true }
                Mock Set-MpPreference
                { Set-MDAVConfig -Mode Secure } | Should -Not -Throw "User needs to be admin to scramble config"
            }
        }

        Context "Gets Values for mode" {
            BeforeAll {
                Mock Get-IsAdmin { return $true }
            }

            It "Gets Values for Random mode" {
                Mock Get-ConfigurationFile { return @{PossibleValues = @{
                            DisableRealTimeMonitoring = @($true, $false) 
                        } 
                    } }
                Mock Set-MpPreference
                Set-MDAVConfig -Mode Random 
                Assert-MockCalled Get-ConfigurationFile
            }

            It "Gets Values for Secure Mode" {
                Mock Get-ExpectedConfig { return @{
                        DisableRealTimeMonitoring = $false
                    } }
                Mock Set-MpPreference {}
                Set-MDAVConfig -Mode Secure 
                Assert-MockCalled Get-ExpectedConfig 
            }
        }

        Context "Handles Output" { 
            It "Calls Set-MpPreference" { 
                Mock Set-MpPreference {}
                Set-MDAVConfig -Mode Secure 
                Assert-MockCalled Set-MpPreference
            }
        }
    }
}

