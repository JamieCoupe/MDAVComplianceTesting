<#
.SYNOPSIS

Extracts the Defender settings from GPO based on the setting mapping in src/dependencies/gpo_mppreference_mapping file

.DESCRIPTION

This function generats a report of the input GPO (which must be a GPO within the domain this device is part of) and creates a list of PowerShell styled settings. 

.PARAMETER GUID
The GPO GUID that you wish to extract 

.INPUTS

None. You cannot pipe objects to Get-GPOComplianceSettings

.OUTPUTS

System.Object. Get-GPOComplianceSettings returns an object with extracted settings. This is in the same format as the example within src/dependencies/expected_mdav_confg

.EXAMPLE

PS> Get-GPOComplianceSettings -GUID 4ebceb3b-0104-4fe4-a8f8-c69de0e37921

.EXAMPLE

PS> Get-GPOComplianceSettings -GUID 4ebceb3b-0104-4fe4-a8f8-c69de0e37921 -verbose

.LINK

https://github.com/JamieCoupe/MDAVComplianceTesting

#>
function Get-GPOComplianceSettings { 
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Guid
    )

    begin {
      
        try {
            Import-Module GroupPolicy -Verbose:$false
        }
        catch { 
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Failed to import GroupPolicy module. Is it available?"
            Throw "Failed to import GroupPolicy module"
        }
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

            }

            Foreach ($row in $tableRows) {
                $severity = $severities[$row.name]
                $action = $row.data
                $expectedConfig["$($severity)ThreatDefaultAction"] = $action
            }
        } 
    }
    


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $expectedConfig
        #return $policySettings
    }
}
