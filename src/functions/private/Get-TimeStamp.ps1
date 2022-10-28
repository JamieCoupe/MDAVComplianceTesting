function Get-TimeStamp {
    [CmdletBinding()]
    param ()

    begin {
        return "[{0:MM/dd/yy}-{0:HH:mm:ss}]" -f (Get-Date)
    }
}