<#
.SYNOPSIS


.DESCRIPTION



.EXAMPLE

PS> Get-TestSummary


.LINK



#>
function Get-TestSummary { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $TestResultPath
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        try{
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Loading Data"
            $testJson = Get-Content $TestResultPath | Out-String | ConvertFrom-Json
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): - Successful"
        }
        catch { 
            $err = $_
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): - Failed"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error getting expected config: $($err)"
        }
    }

    process {
        # Total Number of test 

        # True Negative
        # Number of test that have overallstatus = false and are not in the expected config list 

        # True Positive
        # NUmber of test that have overallstatus = true and are in the expected config list 

        # False Negative
        # Number of test that have overallstatus = fales and are in the exptecd config list 

        # False Positive 
        # Number of tests that have overallstatus = true and are not in the expected config list 

        # Rate for each of the above. 
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"

    }
}
