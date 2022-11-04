function Measure-MDAVCompliance { 
    [Cmdletbinding()]
    param()

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        
        #Get Expected config as reusable hashmap
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Expected Configuration"
        try{
            $expectedConfiguration = Get-ConfigurationFile -ConfigurationFile 'Expected_config'
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Retrieved configuration successfully"
            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Retrieved configuration successfully: $($expectedConfiguration | Convertto-Json)"
        }
        catch {
            #Print Error and Exit function if cant get expected config
            $err = $_
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error getting expected config: $($err)"
            exit(1)
        }
    }

    process {
        #Get Setting Names from the HashMap
        $expectedSettingNames = $expectedConfiguration.keys
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Names: $($expectedSettingNames)"

        #Convert Expected Config to List of Hashmaps


        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Current Configuration"
        $mpPreference = Get-MpPreference | ConvertTo-Json  | ConvertFrom-Json

        #Get the actual config for a setting in the expected HashMap
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Filtering for Choosen Settings"
        $filteredActualConfiguration = @{}

        foreach ($setting in $expectedSettingNames){
            #Add current config to Array
            $filteredActualConfiguration += @{$setting = $mpPreference.$setting}
        }

        #Debug output to check data getting measured
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Filtered actual config = $($filteredActualConfiguration | ConvertTo-Json)"
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Formatted expected config = $($expectedConfiguration | ConvertTo-Json)"

        
        $complianceResults = Compare-MDAVConfiguration -ActualConfiguration $filteredActualConfiguration -ExpectedConfiguration $expectedConfiguration -Verbose:$true
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return  $complianceResults
    }
}
