@{
    DisableRealTimeMonitoring                     = $false
    DisableBehaviorMonitoring                     = $false        
    DisableIOAVProtection                         = $false
    DisableScriptScanning                         = $false
    DisableEmailScanning                          = $false
    DisableArchiveScanning                        = $false
    DisableScanningNetworkFiles                   = $false
    DisableScanningMappedNetworkDrivesForFullScan = $false    
    MAPSReporting                                 = 1
    SubmitSamplesConsent                          = 1
    ModerateThreatDefaultAction                   = 2 #Numberic Value for Quarantine https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-defender#defender-threatseveritydefaultaction
    HighThreatDefaultAction                       = 2 #Numberic Value for Quarantine https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-defender#defender-threatseveritydefaultaction
    LowThreatDefaultAction                        = 2 #Numberic Value for Quarantine https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-defender#defender-threatseveritydefaultaction
    SevereThreatDefaultAction                     = 2 #Numberic Value for Quarantine https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-defender#defender-threatseveritydefaultaction
    UnknownThreatDefaultAction                    = 2 #Numberic Value for Quarantine https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-defender#defender-threatseveritydefaultaction       
}