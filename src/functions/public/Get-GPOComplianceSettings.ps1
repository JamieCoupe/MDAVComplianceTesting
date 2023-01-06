<#
.SYNOPSIS


.DESCRIPTION



.EXAMPLE

PS> Get-GPOComplianceSettings


.LINK



#>
function Get-GPOComplianceSettings { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Guid
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        Import-Module GroupPolicy -Verbose:$false
        $settingMapping = Get-ConfigurationFile -ConfigurationFile Setting_Mapping -verbose:$false
    }

    process {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting GPO report"
        try {
            [xml]$xmlReport = Get-GPOReport -Guid $Guid -ReportType Xml
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Successfully loaded GPO settings"
        }
        catch { 
            $err = $_ 
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error: $($err)"
            Throw "Failed to load GPO XML"
        }

        $policySettings = $xmlReport.gpo.Computer.ExtensionData.Extension.Policy
        $policyNames = $policySettings.Name
        # Convert from GPO to get-mppreference settings 
        $gpoConfiguration = @{}

        foreach ($setting in $policyNames) {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): GPO setting: $($setting)"
            
            #Get Settings and Value 
            $desiredSetting = ($settingMapping.GetEnumerator() | Where-Object value -eq $setting).name   
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Desired Setting: $($desiredSetting)"
            
            $desiredValueState = ($policySettings | Where-Object Name -eq $setting).state
            
            # Convert to MP-Preference Format
            Switch ($desiredValueState) {
                'Enabled' {
                    $desiredValue = $true
                }
                'Disabled' {
                    $desiredValue = $false
                }
            }

            # Explicilty handle default threat actions  
            if ($setting -eq "Specify threat alert levels at which default action should not be taken when detected") {
                $setLevels = ($policySettings | Where-Object Name -eq $setting).listbox.value.element.data
                
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): SetLevels = $($SetLevels | Convertto-json)"

                $gpoConfiguration["LowThreatDefaultAction"] = $setLevels[0]
                $gpoConfiguration["ModerateThreatDefaultAction"] =  $setLevels[1]
                $gpoConfiguration["HighThreatDefaultAction"] = $setLevels[2]
                $gpoConfiguration["SevereThreatDefaultAction"] =  $setLevels[3] 
                continue
            }

            #Explicitly Handle Maps Config
            if ($setting -eq "Join Microsoft MAPS") {
                $desiredSetting = $setting
                
#$desiredValue =  

            }

            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Desired ValueState = $($desiredValueState)"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Desired Value = $($desiredValue)"
            $gpoConfiguration[$desiredSetting] = $desiredValue
        }
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        #return $gpoConfiguration
        return $policySettings
    }
}
