function Test-ComplianceFunction { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]
        $LoopNumber = 10)

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        $metaData = @{
            Hostname       = [System.Net.Dns]::GetHostName()
            User           = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            TestStartTime  = "[{0:MM/dd/yy}-{0:HH:mm:ss}]" -f (Get-Date)
            NumberOfLoops  = $LoopNumber 
            ExpectedConfig = Get-ExpectedConfig
        }
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): MetaData: $($metaData | convertto-json )"
    }

    process {
        $results = @{MetaData = $metaData }
        $rawData = @()
        $counter = 1 

        ## Execute Tests 
        While ($counter -le $LoopNumber){
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Test #$($counter)/$($LoopNumber)"

            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Random Config"
            try{
                Set-MDAVConfig -Mode Random -Verbose:$false
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
            } catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            }

            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Measuring Compliance"
            try{
                $rawData += [PSCustomObject]@{
                    TestNumber = $counter
                    Data = Measure-MDAVCompliance -TestTitle "Script Test - $($counter) of $($LoopNumber)" -Verbose:$false
                } 
                
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Success"
            } catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            }

            $counter++
        }

        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Resetting Secure Configuration"
        Set-MDAVConfig -Mode Secure -Verbose:$false

        $results['RawData'] = $rawData

        ##Summarize Results
    }

    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $results 
    }
}