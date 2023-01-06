function Get-ConfigurationFile {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('Expected_Config', 'Module', 'Setting_Mapping')]
        [String]
        $ConfigurationFile
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
    }

    process {
        $srcDirectory = Split-Path (Split-Path $PSScriptRoot) -Parent

        switch($ConfigurationFile){
            'Module'{
                $configurationFilePath = "$($srcDirectory)\dependencies\mdavcompliance_config.psd1"
            }
            'Expected_config' {
                $configurationFilePath = "$($srcDirectory)\dependencies\expected_mdav_config.psd1"
            }
            'Setting_Mapping' {
                $configurationFilePath = "$($srcDirectory)\dependencies\gpo_mppreference_mapping.psd1"
            }
        }

        $configurationFileContent = Import-PowerShellDataFile -Path $configurationFilePath
    }

    end{
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $configurationFileContent
    }
}