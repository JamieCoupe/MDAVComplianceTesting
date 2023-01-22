Function Get-IsAdmin {
    [OutputType([boolean])]
    [cmdletbinding()]
    param()

    begin {}

    process { 
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            return $true
        }
        else { 
            return $false 
        }
    }

    end {} 
}