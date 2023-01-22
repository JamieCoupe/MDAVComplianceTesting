@{
    MAPSReporting                                 = @{  
        GPOLabel          = "Join Microsoft MAPS"
        Inverted          = $False
        AdditionalSetting = "DropDownList"
    }
    SubmitSamplesConsent                          = @{  
        GPOLabel          = "Send file samples when further analysis is required"
        Inverted          = $False
        AdditionalSetting = "DropDownList"
    }
    DisableIOAVProtection                         = @{  
        GPOLabel          = "Scan all downloaded files and attachments"
        Inverted          = $True
        AdditionalSetting = $False
    }
    DisableRealTimeMonitoring                     = @{  
        GPOLabel          = "Turn off real-time protection"
        Inverted          = $False
        AdditionalSetting = $False 
    } 
    DisableBehaviorMonitoring                     = @{  
        GPOLabel          = "Turn on behavior monitoring"
        Inverted          = $True        
        AdditionalSetting = $False 
    } 
    DisableScanningMappedNetworkDrivesForFullScan = @{  
        GPOLabel          = "Run full scan on mapped network drives"
        Inverted          = $True       
        AdditionalSetting = $False 
    }  
    DisableArchiveScanning                        = @{  
        GPOLabel          = "Scan archive files"
        Inverted          = $True       
        AdditionalSetting = $False 
    }  
    DisableScanningNetworkFiles                   = @{  
        GPOLabel          = "Scan network files"
        Inverted          = $True       
        AdditionalSetting = $False 
    }  
    DisableEmailScanning                          = @{  
        GPOLabel          = "Turn on e-mail scanning"
        Inverted          = $True       
        AdditionalSetting = $False 
    }   
    ThreatDefaultAction                           = @{  
        GPOLabel          = "Specify threat alert levels at which default action should not be taken when detected"
        Inverted          = $False
        AdditionalSetting = "ListBox"
    }
}