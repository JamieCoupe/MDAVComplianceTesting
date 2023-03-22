<#
.SYNOPSIS

A supporting function and not part of the core compliance scanner. A wrapper for Measure-MDAVCompliance and Set-MDAVConfig to allow for large batches of tests to be run. 

.DESCRIPTION

A wrapper for Measure-MDAVCompliance and Set-MDAVConfig to allow for large batches of tests to be run. 


.PARAMETER LoopNumber

The number of test iterations to run

.PARAMETER OutputPath

The path to save the output tests to 

.INPUTS

None. You cannot pipe objects to Test-ComplianceFunction

.OUTPUTS

Returns the test results to stout which can be assigned as in example 2

.EXAMPLE

PS> Test-ComplianceFunction -LoopNumber 10 -OutputPath $path -verbose

.EXAMPLE

PS> $test_results = Test-ComplianceFunction -LoopNumber 10 -OutputPath $path -verbose


.LINK

https://github.com/JamieCoupe/MDAVComplianceTesting

#>
function Test-ComplianceFunction { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]
        $LoopNumber = 10,
        [Parameter(Mandatory = $false)]
        [String]
        $OutputPath
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        $metaData = @{
            Hostname       = [System.Net.Dns]::GetHostName()
            User           = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            TimeStarted  = "[{0:MM/dd/yy}-{0:HH:mm:ss}]" -f (Get-Date)
            NumberOfLoops  = $LoopNumber 
            ExpectedConfig = Get-ExpectedConfig
        }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): MetaData: $($metaData | convertto-json )"
    }

    process {
        $results = [ordered]@{MetaData = $metaData }
        $results += @{ExpectedConfigTests = @() }
        $rawData = @()
        $counter = 1 

        ## Execute Tests 
        While ($counter -le $LoopNumber) {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Test $($counter)/$($LoopNumber)"

            
            try {
                $randomNumber = Get-Random -Minimum 1 -Maximum 10
                if ($randomNumber -eq 7) {
                    Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Secure Config"
                    Set-MDAVConfig -Mode Secure -Verbose:$false
                    $results.ExpectedConfigTests += $counter
                }
                else { 
                    Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Random Config"
                    Set-MDAVConfig -Mode Random -Verbose:$false
                }
                
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
            }
            catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            }

            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Measuring Compliance"
            try {
                $rawData += [PSCustomObject]@{
                    TestNumber = $counter
                    Data       = Measure-MDAVCompliance -TestTitle "Script Test - $($counter) of $($LoopNumber)" -Verbose:$false
                } 
                
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
            }
            catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            }

            $counter++
        }

        try { 
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Resetting to Secure Configuration"
            Set-MDAVConfig -Mode Secure -Verbose:$false
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
        }
        catch {
            $err = $_ 
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"

        }
        $results['MetaData']['TimeEnded'] = Get-TimeStamp
        $results['RawData'] = $rawData
        
    }

    end {
        if ($OutputPath) {
            try {
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Writing to File: $($OutputPath)"
                $results | Convertto-Json -Depth 100 | Out-File $OutputPath
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
            }
            catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            }
            
        }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $results 
    }
}