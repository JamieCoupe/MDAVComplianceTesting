. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            Context "LoopNumber Parameter" {
                It "Exist" { 
                    Get-Command Test-ComplianceFunction | Should -HaveParameter LoopNumber 
                } 
                
                It "Mandatory if required" { 
                    (Get-Command Test-ComplianceFunction).Parameters['LoopNumber'].Attributes.Mandatory | Should -be $false
                }
            }
            
            Context "OutputPath Parameter" {
                It "Exist" { 
                    Get-Command Test-ComplianceFunction | Should -HaveParameter OutputPath 
                } 
                
                It "Mandatory if required" { 
                    (Get-Command Test-ComplianceFunction).Parameters['OutputPath'].Attributes.Mandatory | Should -be $false
                }
            }
        }

        Context "Function calls" { 
            beforeall { 
                Mock Set-MpPreference {}
            }
            
            It "Calls Get-Random" {
                Mock Get-Random {}
                Mock Set-MDAVConfig {}
                Test-ComplianceFunction -LoopNumber 1
                Assert-MockCalled Get-Random
            }

            It "Calls Set-MdavConfig Secure if random number is 7" {
                Mock Get-Random { return 7 }
                Mock Set-MDAVConfig {} -ParameterFilter { $mode -eq "Secure" }
                Test-ComplianceFunction -LoopNumber 1
                Assert-MockCalled Set-MDAVConfig
            }

            It "Calls Set-MdavConfig Random if random number is not 7" {
                Mock Get-Random { return 3 }
                Mock Set-MDAVConfig {} -ParameterFilter { $mode -eq "Random" }
                Test-ComplianceFunction -LoopNumber 1
                Assert-MockCalled Set-MDAVConfig
            }

            It "Calls Measure-MDAVCompliance Function" {
                Mock Measure-MDAVCompliance {} 
                Mock Set-MDAVConfig {}
                Test-ComplianceFunction -LoopNumber 1
                Assert-MockCalled Measure-MDAVCompliance
            }

            It "Calls Out-File if output is selected" { 
                Mock Set-MDAVConfig {}
                Mock Out-File {} 
                Test-ComplianceFunction -LoopNumber 1 -OutputPath "Testdrive:\\test.json"
                Assert-MockCalled Out-File
            }
        }
    }
}

