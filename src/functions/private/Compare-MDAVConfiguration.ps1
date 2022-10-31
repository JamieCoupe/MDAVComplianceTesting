function Compare-MdavConfiguration {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [System.Object]
        $ActualConfiguration,
        [Parameter(Mandatory=$true)]
        [System.Object]
        $ExpectedConfiguration
    )

    begin {
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Started Execution"
    }

    process {
        $matchingSettings = @()
        $nonmatchingSettings = @()

        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Actual Configuration Keys $($ActualConfiguration.keys)"
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Expected Configuration Keys $($ExpectedConfiguration.keys)"

        if($ActualConfiguration.keys -eq $ExpectedConfiguration.keys){
            
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Key lists are equal"
    #     foreach ($actualSetting in $ActualConfiguration){
            #         for expected setting in $ExpectedConfiguration
            #             if the have the same name, 
            #                 if the have the same value,
            #                     Add to matching 
            #                 else {
            #                     Add to nonmatching 
            #                 }
            #             else 
            #                 move on 
                        
            #             case for in one but not the other  
        }
        
        else {
            Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Key lists are not equal"
        #     extract non-matching keys to nonmatching 

        #     bubble filter as above 
        
        }

    }

    end{
        Write-Verbose -Message "$(Get-TimeStamp): $($MyInvocation.MyCommand): Finished Execution"
        return $configurationComparison
    }
}