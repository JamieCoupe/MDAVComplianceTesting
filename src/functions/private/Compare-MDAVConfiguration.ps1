function Compare-MdavConfiguration {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ActualConfiguration,
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ExpectedConfiguration
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
    }

    process {

        #Loop expected settings from config
        $configurationComparison = @()
        foreach ($expectedSetting in $ExpectedConfiguration.GetEnumerator()) {
            Write-Verbose  -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): ########################TEST-START########################"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting: $($expectedSetting.Name)"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Expected Value: $($expectedSetting.Value)"
            $testState = $false
            
            #Use Actualconfig hashtable as a lookup for the expected value 
            try {
                $actualSettingValue = $ActualConfiguration[$expectedSetting.Name]
            }
            catch { 
                #Output error if the actual value doesnt exist
                $err = $_
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error getting setting value $($err)"
                $actualSettingValue = "Error getting setting value"
            }
            
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Actual Value: $($actualSettingValue)"

            #Change the state if it matches or not 
            if ($expectedSetting.Value -ne $actualSettingValue) { 
                $testState = $false
            }
            else {
                $testState = $true
            }

            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Result: $($testState)"
            Write-Verbose  -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): #########################TEST-END#########################"

            #Create custom output object 
            $testResult = [PSCustomObject]@{
                SettingName   = $expectedSetting.Name
                TestState     = $testState 
                ExpectedValue = $expectedSetting.Value
                ActualValue   = $actualSettingValue
            }

            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Results: $($testResult | Convertto-json)"

            #Add custom output to the overall results 
            $configurationComparison += $testResult
        }
    }

    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $configurationComparison
    }
}