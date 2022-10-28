Import-Module Pester -Passthru
. $PSScriptRoot\Import.ps1

BeforeTest

$ConfigAll = [PesterConfiguration]@{
    Run = @{
        Container = $functionTests
        Passthru = $true
    }
    Output = @{
        Verbosity = 'Detailed'
    }
}

$tests = Invoke-Pester -Configuration $ConfigAll