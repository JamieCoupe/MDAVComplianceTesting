<#
.SYNOPSIS

Measures the compliance level of MDAV security control.

.DESCRIPTION

Measures the compliance level of MDAV security control.
Compares the actual config to an expected config and generates a report as a PowerShell object.

.PARAMETER ExpectedConfiguration
Specifies the expected configuration if the default on in the configuration file is not be be used. Optional. 

.PARAMETER TestTitle
Specifies the title of the test if the default is not to be user. Optional. 

.INPUTS

None. You cannot pipe objects to Measure-MDAVCompliance

.OUTPUTS

System.Object. Measure-MDAVCompliance returns an object with the compliance results and metadata for the MDAV security control 

.EXAMPLE

PS> Measure-MDAVCompliance

.EXAMPLE

PS> Measure-MDAVCompliance -TestTitle "Example"

.EXAMPLE

PS> Measure-MDAVCompliance -TestTitle "ExampleTitle" -ExpectedConfiguration $ExpectedConfigurationHashtable

.LINK

http://www.fabrikam.com/extension.html

#>
function Measure-MDAVCompliance { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [System.Object]
        $ExpectedConfiguration,
        [Parameter(Mandatory = $false)]
        [String]
        $TestTitle = "MDAV Compliance Scan"
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        
        #Get Expected config from config file if not passed in as a parameter
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Expected Configuration"
        if (!$ExpectedConfiguration) {
            $ExpectedConfiguration = Get-ExpectedConfig
        }
        $actualConfiguration = Get-ActualConfig -ExpectedConfiguration $expectedConfiguration
    }

    process {
        #Debug output to check data getting measured
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Filtered actual config = $($actualConfiguration | ConvertTo-Json)"
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Formatted expected config = $($expectedConfiguration | ConvertTo-Json)"

        $complianceResults = @{Title = $TestTitle }
        $complianceResults['Hostname'] = [System.Net.Dns]::GetHostName()
        $complianceResults['User'] = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $complianceResults['TimeStarted'] = Get-TimeStamp
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #### Title: $($complianceResults.Title)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #### Hostname: $($complianceResults.Hostname)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #### User: $($complianceResults.User)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #### Time Started: $($complianceResults.TimeStarted)"


        $complianceResults['RawData'] = Compare-MDAVConfiguration -ActualConfiguration $actualConfiguration -ExpectedConfiguration $expectedConfiguration 
       

        #Get overall fail/pass
        $overallStatus = $false
        if (($complianceResults.rawdata.teststate | Sort-Object -unique).count -gt 1) {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Not all tests passed"
        }
        elseif (($complianceResults.rawdata.teststate | Sort-Object -unique).count -eq 0 -and ($complianceResults.rawdata.teststate | Sort-Object -unique -eq $true)) {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): All tests passed"
            $overallStatus = $true
        }
        else { 
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): All tests failed"
        }

        $complianceResults['OverallStatus'] = $overallStatus
        
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #########################Overall-Results#########################"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): All Tests Passed: $($overallStatus)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #########################Overall-Results#########################"
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return  $complianceResults
    }
}
