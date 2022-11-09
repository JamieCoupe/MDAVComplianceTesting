function Set-MDAVConfig { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Random', 'Secure')]
        [String]
        $Mode
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Mode = $($Mode)"

        #Check for Admin
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): User Needs to be admin to execute this scrambler otherwise it will fail"
            Throw "User needs to be admin to scramble config"
        }
    }

    process {
        switch($Mode){
            'Random'{
                $possibleValues = (Get-ConfigurationFile -ConfigurationFile Module).PossibleValues
            } 
            'Secure' { 
                $possibleValues = Get-ExpectedConfig
            }
        }
        


        Foreach ($setting in $possibleValues.GetEnumerator()) {
            $settingName = $setting.name
            $settingPossibleValues = $setting.value
            switch($Mode){
                'Random'{
                    $valueToSet = Get-Random -InputObject $settingPossibleValues
                } 
                'Secure' { 
                    $valueToSet = $setting.value
                }
            }
            
            
            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Name: $($settingName)"
            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Possible Values: $($settingPossibleValues)"
            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Selected Value: $($valueToSet)"

            $setConfigParams = @{
                $settingName = $valueToSet
            }

            try {
                Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting config: $($setConfigParams | Convertto-json)"
                Set-MpPreference @setConfigParams
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): $($settingName) = $($valueToSet) <> Set"
            }
            catch { 
                $err = $_ 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): $($settingName) = $($valueToSet) <> Failed"
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error setting config: $($err)"
            }
            
        }
    }

    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
    }
}