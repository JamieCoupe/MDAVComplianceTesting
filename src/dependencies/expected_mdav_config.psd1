@{
    Settings = @{
        DisableRealTimeMonitoring                     = $false
        DisableBehaviorMonitoring                     = $false        
        SisableIOAVProtection                         = $false
        DisableScriptScanning                         = $false
        DisableEmailScanning                          = $false
        MAPSReporting                                 = 1
        SubmitSamplesConsent                          = 1
        ModerateThreatDefaultAction                   = 'Quarantine'
        HighThreatDefaultAction                       = 'Quarantine'
        LowThreatDefaultAction                        = 'Quarantine'
        SevereThreatDefaultAction                     = 'Quarantine'
        UnknownThreatDefaultAction                    = 'Quarantine'
        DisableArchiveScanning                        = $false
        DisableScanningNetworkFiles                   = $false
        DisableScanningMappedNetworkDrivesForFullScan = $false                                              
    }
}