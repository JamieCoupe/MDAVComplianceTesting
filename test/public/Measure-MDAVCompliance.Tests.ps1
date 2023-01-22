. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            Context "ExpectedConfig Parameters" {
                It "Exist" { 
                    Get-Command Measure-MDAVCompliance | Should -HaveParameter ExpectedConfiguration 
                } 
            
                It "Mandatory if required" { 
                    (Get-Command Measure-MDAVCompliance).Parameters['ExpectedConfiguration'].Attributes.Mandatory | Should -be $false
                }
            }

            Context "TestTitle Parameter" {
                It "Exist" { 
                    Get-Command Measure-MDAVCompliance | Should -HaveParameter TestTitle 
                } 
            
                It "Mandatory if required" { 
                    (Get-Command Measure-MDAVCompliance).Parameters['TestTitle'].Attributes.Mandatory | Should -be $false
                }
            }

            Context "OutputPath Parameter" { 
                It "Exist" { 
                    Get-Command Measure-MDAVCompliance | Should -HaveParameter OutputPath 
                } 
            
                It "Mandatory if required" { 
                    (Get-Command Measure-MDAVCompliance).Parameters['OutputPath'].Attributes.Mandatory | Should -be $false
                }
            }
        }

        Context "Handles ExpectedConfig parameter" { 
            It "Gets Expected Config when its not passed as parameter" {
                Mock Get-ExpectedConfig { return @{
                        DisableRealTimeMonitoring = $false
                    } }
                Measure-MDAVCompliance
                Assert-MockCalled Get-ExpectedConfig
            }

            It "Gets Actual Config " {
                Mock Get-ActualConfig { return @{
                        DisableRealTimeMonitoring = $false
                    } }
                Measure-MDAVCompliance
                Assert-MockCalled Get-ActualConfig 
            }
        }

        Context "Calls Compare-MdavConfiguration" {
            It "Calls the compare-MdavConfiguration function" { 
                Mock Compare-MDAVConfiguration
                Measure-MDAVCompliance
                Assert-MockCalled Compare-MDAVConfiguration
            }
        }

        Context "Outputs the Content Correctly" { 
            It "Outputs to file when called" { 
                Mock Out-File {}
                Measure-MDAVCompliance -OutputPath "Testdrive:test.json"
                Assert-MockCalled Out-File
            }
        }
    }
}