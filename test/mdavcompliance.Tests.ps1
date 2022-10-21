. .\Import.ps1

BeforeTest

Describe $module -Tags ('unit'){
    Context "$module : Module Tests" { 
        It 'Passes ''Test-ModuleManifest''' { 
            Test-ModuleManifest -Path $moduleManifest
            $? | Should -Be $true
        }
    }
}

AfterTest