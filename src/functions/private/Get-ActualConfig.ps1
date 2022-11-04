function Get-ActualConfig {
    [Cmdletbinding()]
    param()

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
    }

    process {
        #Get Setting Names from the HashMap
        $expectedSettingNames = $expectedConfiguration.keys
        Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Names: $($expectedSettingNames)"

        #Convert Expected Config to List of Hashtables
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Current Configuration"
        $mpPreference = Get-MpPreference | ConvertTo-Json  | ConvertFrom-Json

        #Get the actual config for a setting in the expected HashMap
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Filtering for Choosen Settings"
        $filteredActualConfiguration = @{}

        foreach ($setting in $expectedSettingNames) {
            #Add current config to Array
            $filteredActualConfiguration += @{$setting = $mpPreference.$setting }
        }
    }

    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return  $filteredActualConfiguration
    }
}