@{
    ModuleName     = 'mdavcompliance'
    PossibleValues = @{
        DisableRealTimeMonitoring                     = @($true, $false)
        DisableBehaviorMonitoring                     = @($true, $false)     
        DisableIOAVProtection                         = @($true, $false)
        DisableScriptScanning                         = @($true, $false)
        DisableEmailScanning                          = @($true, $false)
        DisableArchiveScanning                        = @($true, $false)
        DisableScanningNetworkFiles                   = @($true, $false)
        DisableScanningMappedNetworkDrivesForFullScan = @($true, $false)    
        MAPSReporting                                 = @(0, 1, 2)
        SubmitSamplesConsent                          = @(0, 1, 2, 3)
        ModerateThreatDefaultAction                   = @(1, 2, 3, 6, 8, 9 , 10) # 'Clean', 'Quarantine', 'Remove', 'Allow', 'UserDefined', 'NoAction', 'Block' in order. https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows
        HighThreatDefaultAction                       = @(1, 2, 3, 6, 8, 9 , 10) # 'Clean', 'Quarantine', 'Remove', 'Allow', 'UserDefined', 'NoAction', 'Block' in order. https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows
        LowThreatDefaultAction                        = @(1, 2, 3, 6, 8, 9 , 10) # 'Clean', 'Quarantine', 'Remove', 'Allow', 'UserDefined', 'NoAction', 'Block' in order. https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows
        SevereThreatDefaultAction                     = @(1, 2, 3, 6, 8, 9 , 10) # 'Clean', 'Quarantine', 'Remove', 'Allow', 'UserDefined', 'NoAction', 'Block' in order. https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows
        UnknownThreatDefaultAction                    = @(1, 2, 3, 6, 8, 9 , 10) # 'Clean', 'Quarantine', 'Remove', 'Allow', 'UserDefined', 'NoAction', 'Block' in order. https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows
    }
}