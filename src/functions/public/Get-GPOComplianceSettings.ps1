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
        $settingMap = Get-ConfigurationFile -ConfigurationFile Setting_Mapping -verbose:$false
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Setting Map loaded"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): $($settingMap.count) Settings "
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
        # Convert from GPO to get-mppreference settings 
        $expectedConfig = @{}
        
        #Iterate Through Each setting in the map
        foreach ($setting in $settingMap.GetEnumerator()) {
            # return $setting
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Extracting $($setting.name)"
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): GPOLabel =  $($setting.value.GPOLabel)"

            #Extract the GPO Lable and its additional info
            $policySetting = $policySettings | Where-Object -Property Name -eq $setting.value.GPOLabel

            #Extract the GPO Lable and its additional info 
            #if additional info false 
            if ($setting.value.AdditionalSetting -eq $false -OR $setting.value.AdditionalSetting -eq "DropDownList") {
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): No additional Information Or DropDownList"
                $gpoValue = $policySetting.state
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): GPO State = $($policySetting.state)"
                
                switch ($gpoValue) {
                    'Enabled' { 
                        $desiredValue = $true
                    } 'Disabled' { 
                        $desiredValue = $false
                    }
                }

                #Invert if required 
                if ($setting.value.inverted) {
                    #Flip 
                    Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Inverted Value"
                    $desiredValue = !$desiredValue
                }
                else {
                    Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Non Inverted Value"
                }

                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Compliance Expected Value = $($desiredValue)"
                $expectedConfig[$setting.name] = $desiredValue
            }
            elseif ($setting.value.AdditionalSetting -eq "ListBox") { 
                #If additional info 
                Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Additional Information = ListBox"
                $tableRows = $policySetting.ListBox.value.element

                #Table Mapping 
                $severities = @{
                    '1' = "Low"
                    '2' = "Medium"
                    '4' = "High"
                    '5' = "Severe"
                }
                
                # $actions = @{
                #     2 = "quarantine"
                #     3 = "remove"
                #     6 = "ignore"
                # }

                Foreach ($row in $tableRows) {
                    $severity = $severities[$row.name]
                    $action = $row.data
                    $expectedConfig["$($severity)ThreatDefaultAction"] = $action
                }
            } 
        }
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $expectedConfig
        #return $policySettings
    }
}
