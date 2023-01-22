. $PSScriptRoot\..\Import.ps1

BeforeTest

Describe $module -Tags ('unit') {
    Context "$module : Function Tests" { 
        Context "Functionality Tests" {
            It "Calls get-configurationfile function" {
                Mock  get-configurationfile { }
                Get-ExpectedConfig
                Assert-MockCalled  get-configurationfile
            }
           
            It "Returns a hash table" {
                Get-ExpectedConfig | Should -beofType [Object]
            }
        }
    }
}
