<#
.SYNOPSIS

A supporting function and not part of the core compliance scanner. Sets the configuration of MDAV to a secure configuration (the expected on in dependencies) or a random config

.DESCRIPTION

Sets the configuration of MDAV to a secure configuration (the expected on in dependencies) or a random config


.PARAMETER Mode

Determines if Set-MDAVConfig applies the secure or the random config

.INPUTS

None. You cannot pipe objects to Set-MDAVConfig

.OUTPUTS

None. 

.EXAMPLE

PS> Set-MDAVConfig -Mode Secure

.EXAMPLE

PS> Set-MDAVConfig -Mode Random -verbose


.LINK

https://github.com/JamieCoupe/MDAVComplianceTesting

#>
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
        if (!$(Get-IsAdmin)) {
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
        $newConfig = @{}

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
            
            $newConfig[$settingName] = $valueToSet
            
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
        #return $newConfig
    }
}