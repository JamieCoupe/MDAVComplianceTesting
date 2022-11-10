function Get-ExpectedConfig { 
    [Cmdletbinding()]
    param()

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
    }

    process {
        #Get Expected config as reusable hashmap
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Getting Expected Configuration"
        try {
            $expectedConfiguration = Get-ConfigurationFile -ConfigurationFile 'Expected_config'
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Retrieved configuration successfully"
            Write-Debug -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Retrieved configuration successfully: $($expectedConfiguration | Convertto-Json)"
        }
        catch {
            #Print Error and Exit function if cant get expected config
            $err = $_
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Error getting expected config: $($err)"
            Throw "Error getting expected config"
        }
    }


    end {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return  $expectedConfiguration
    }
}