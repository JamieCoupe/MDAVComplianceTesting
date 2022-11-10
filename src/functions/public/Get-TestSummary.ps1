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
        try {
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
        # Gather MetaData
        $totalNumberOfTests = $testJson.metadata.NumberOfLoops
        $testHostname = $testJson.metadata.Hostname
        $testUsername = $testJson.metadata.User
        $TestTime = $testJson.metadata.TestStartTime
        $expectedConfigTests = $testjson.ExpectedConfigTests

        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ######### Test-Metadata ########"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Test Host: $($testHostname)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Test User: $($testUsername)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Test Time: $($TestTime)"
        
        ####
        # Print overall data for numbers
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ######### Test-Summary ########"
        $negativeTests = $testJson.rawdata | Where-Object { $_.data.overallstatus -eq $false }
        $positiveTests = $testJson.rawdata | Where-Object { $_.data.overallstatus -eq $true } 
        
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # TotalNumber of Tests: $($totalNumberOfTests)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of Negative Tests: $($negativeTests.count)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of Positive Tests: $($positiveTests.count)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of Tests that had expected config set: $($expectedConfigTests.count)"

        ####
        # Print metrics data
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ######### Test-Metrics ########"
        # True Negative
        # Number of test that have overallstatus = false and are not in the expected config list 
        $trueNegTest = $negativeTests | Where-Object { $_.TestNumber -notin $expectedConfigTests }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of True Negative Tests: $($trueNegTest.count)"

        # True Positive
        # NUmber of test that have overallstatus = true and are in the expected config list 
        $truePosTest = $positiveTests | Where-Object { $_.TestNumber -in $expectedConfigTests }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of True Positive Tests: $($truePosTest.count)"

        # False Negative
        # Number of test that have overallstatus = fales and are in the exptecd config list 
        $falseNegTest = $negativeTests | Where-Object { $_.TestNumber -in $expectedConfigTests }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of False Negative Tests: $($falseNegTest.count)"

        # False Positive 
        # Number of tests that have overallstatus = true and are not in the expected config list 
        $falsePosTest = $positiveTests | Where-Object { $_.TestNumber -notin $expectedConfigTests }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # Number of False Positive Tests: $($falsePosTest.count)"

        ####
        # Rate for each of the above. 
        $trueNegTestRate = "$(($trueNegTest.count / $totalNumberOfTests)*100)%"
        $truePosTestRate = "$(($truePosTest.count / $totalNumberOfTests)*100)%"
        $falseNegTestRate = "$(($falseNegTest.count / $totalNumberOfTests)*100)%"
        $falsePosTestRate = "$(($FalsePosTest.count / $totalNumberOfTests)*100)%"

        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ######### Test-Metrics-Rates ########"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # True Negative Rate: $($trueNegTestRate)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # True Positive Rate: $($truePosTestRate)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # False Negative Rate: $($falseNegTestRate)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): # False Positive Rate: $($falsePosTestRate)"

        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ######### Test-Summary-END ########"
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $testJson
    }
}
