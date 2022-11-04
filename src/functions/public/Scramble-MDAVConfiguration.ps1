function Set-RandomMDAVConfiguration { 
    [Cmdletbinding()]
    param()

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
        $expectedConfiguration = Get-ExpectedConfig
    }

    process {
        #Get current config for settings listed 
        #foreach setting
        #if bool 
            #if true make false
            #else make true 
        # if number 
            #Choose random between 0 - 2 
        # Set-mppreference to the setting and value 
    }

    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
    }
}