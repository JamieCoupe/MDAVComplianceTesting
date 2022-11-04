function Measure-MDAVCompliance { 
    [Cmdletbinding()]
    param()

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        
        #Get Expected config as reusable hashmap
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Expected Configuration"
        $expectedConfiguration = Get-ExpectedConfig
        $actualConfiguration  = Get-ActualConfig
    }

    process {
        #Debug output to check data getting measured
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Filtered actual config = $($actualConfiguration | ConvertTo-Json)"
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Formatted expected config = $($expectedConfiguration | ConvertTo-Json)"

        
        $complianceResults = Compare-MDAVConfiguration -ActualConfiguration $actualConfiguration -ExpectedConfiguration $expectedConfiguration -Verbose:$true
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return  $complianceResults
    }
}
